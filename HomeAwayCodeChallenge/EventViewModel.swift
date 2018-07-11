//
//  EventViewModel.swift
//  HomeAwayCodeChallenge
//
//  Created by Cameron Ollivierre on 6/25/18.
//  Copyright © 2018 Cameron Ollivierre. All rights reserved.
//

import RxSwift
import RxCocoa


protocol ImageCaching {
    func saveImageToCache(image: UIImage?, url: URL)
    
    func imageFromCacheWithUrl(url: URL) -> UIImage?
}

class EventViewModel {

    let searchText = Variable("")
    let disposeBag = DisposeBag()
    
    //lazy load the Event Array driver when search text updates. This will start the sequence that returns serch requests and udpates the binded table view
    lazy var data: Driver<[Event]> = {

        return self.searchText.asObservable()
            .distinctUntilChanged()
            .flatMapLatest(EventViewModel.getEventsWith)
            .asDriver(onErrorJustReturn: [])
    }()
    
    func driverForEventItem(eventItem: Event) -> Driver<UIImage?> {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let imageCache = appDelegate.imageCache
        
        //Format image URL
        let urlString: String? = eventItem.performers[0].imageURL
        guard let image = urlString else { return Driver.just(nil) }
        guard let url = URL(string: image) else { return Driver.just(nil) }
        let urlRequest = URLRequest(url: url)

        //If image is available in cache then return before sending a request
        if let image = imageCache.imageFromCacheWithUrl(url:url) {
            return Driver.just(image)
        }
        
        
        //Subscribe to the response of the image request and save the result to cache as a dicitnary pair
        let response = URLSession.shared.rx.data(request: urlRequest).map{ UIImage(data: $0) }
        
        response.subscribe(onNext: {image in
            imageCache.saveImageToCache(image: image, url: url)
        }).disposed(by: disposeBag)
        
        return response.asDriver(onErrorJustReturn: nil)
    }
    
    static func getEventsWith(_ searchText: String) -> Observable<[Event]> {
        let newString = searchText.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        guard !searchText.isEmpty,
            let url = URL(string: "https://api.seatgeek.com/2/events?q=\(newString)&client_id=MTIwNjE3MjF8MTUyOTk2OTA3Ni43Mw") else {
                return Observable.just([])
        }
        
        let urlRequest = URLRequest(url: url)
        return URLSession.shared.rx.data(request: urlRequest)
            .retry(3)
            .map(parse)
    }
    
    static func parse(json: Data) -> [Event] {
        guard let response = try? JSONDecoder().decode(Response.self, from: json) else {
            return []
        }
        return response.events
    }
}

