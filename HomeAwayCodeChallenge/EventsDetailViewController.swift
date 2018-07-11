//
//  EventsDetailViewController.swift
//  HomeAwayCodeChallenge
//
//  Created by Cameron Ollivierre on 6/25/18.
//  Copyright © 2018 Cameron Ollivierre. All rights reserved.
//

import UIKit


class EventsDetailViewController: UIViewController {
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventPreviewImage: UIImageView!

    var currentEvent: Event?
    let viewModel = EventViewModel()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString: String? = currentEvent?.performers[0].imageURL
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let imageCache = appDelegate.imageCache
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(favoriteButtonPressed))

        guard let image = urlString else { return }
        guard let url = URL(string: image) else { return }
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = DateFormatter.Style.full
        dateformatter.timeStyle = DateFormatter.Style.short
        
        self.eventTitle.text = currentEvent?.title
        self.eventLocation.text = currentEvent?.venue.location
        self.eventTime.text = currentEvent?.dateAndTime
        self.eventTime.text = dateformatter.string(from: Date())
        self.eventPreviewImage.image = imageCache.imageFromCacheWithUrl(url:url)
    }
    
    @IBAction func favoriteButtonPressed(sender: AnyObject) {
        var favoritesArray = defaults.object(forKey: "Favorites") as? [Int]
        //if no events have been addded to favorites initialize the favorites array to store in user defaults
        if favoritesArray == nil {
            let test: [Int] = [(currentEvent?.id)!]
            defaults.set(test, forKey: "Favorites")
            return
        }
        //If Favorites array already exists create a dummy array append the new favorite then replace the user default with the new array
        favoritesArray?.append((currentEvent?.id)!)
        defaults.removeObject(forKey: "Favorites")
        defaults.set(favoritesArray, forKey: "Favorites")
    }
    //init functuon to set the event selected from the tableView
    func setEvent(event: Event) {
        currentEvent = event
    }
}
