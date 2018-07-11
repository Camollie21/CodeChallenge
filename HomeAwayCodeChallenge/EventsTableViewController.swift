//
//  EventsTableViewController.swift
//  HomeAwayCodeChallenge
//
//  Created by Cameron Ollivierre on 6/25/18.
//  Copyright © 2018 Cameron Ollivierre. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EventsTableViewController: UITableViewController {
    let searchController = UISearchController(searchResultsController: nil)
    var searchBar: UISearchBar { return searchController.searchBar }
    var viewModel = EventViewModel()
    let disposeBag = DisposeBag()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSearchController()
        setupCellTapHandling()
        //Set tableview data source to nil so that the RxSwift Library can act as the data source, istead of the UItableviewcontroller.
        tableView.dataSource = nil
        tableView.register(UINib(nibName: "Event Cell", bundle: nil), forCellReuseIdentifier: "event cell")
        
        //bind the search bar text to the viewModel searach text. This way when the search controller text updates so will the search text variable in viewModel, starting the sequence whcuhc wil eventually return the reults
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        //Set up the tableView to subcribe to the data driver
        viewModel.data.drive(tableView.rx.items(cellIdentifier: "Event Cell", cellType: EventsTableViewCell.self)) { _, event, cell in

            //Set up the cells event image to subscribe to the returned driver.
            self.viewModel.driverForEventItem(eventItem: event)
                .drive(cell.eventPreviewImage.rx.image)
                .disposed(by: self.disposeBag)
            //Format the dae string
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = DateFormatter.Style.full
            dateformatter.timeStyle = DateFormatter.Style.short
            
            cell.eventTitle.text = event.title
            cell.eventTime.text = event.dateAndTime
            cell.eventTime.text = dateformatter.string(from: Date())
            cell.eventLocation.text = event.venue.location
            cell.heartImage.isHidden = true
            
            //Check if the returned event has been added to favorites. if so show the favorite image
            if let favoritesArray = self.defaults.object(forKey: "Favorites") as? [Int] {
                for id in (favoritesArray){
                    if (id == event.id) {
                        cell.heartImage.isHidden = false
                    }
                }
            }
            
         }.disposed(by: disposeBag)
    }
    
    private func setupCellTapHandling() {
        //On selecting the cell take in the event and pass the value to the detailview
        tableView
            .rx
            .modelSelected(Event.self)
            .subscribe(onNext: { [weak self]
                event in
                guard let strongSelf = self else {return}
                guard let eventDetailVC = strongSelf.storyboard?.instantiateViewController(withIdentifier: "EventDetail") as? EventsDetailViewController else {return}
                eventDetailVC.setEvent(event: event)
                strongSelf.navigationController?.pushViewController(eventDetailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Enter Event Search"
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
}
