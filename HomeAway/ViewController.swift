//
//  ViewController.swift
//  HomeAway
//
//  Created by Austin Cherry on 8/14/17.
//  Copyright © 2017 Vluxe. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating, Favorited {
    var events = [EventViewModel]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Events", comment: "")
        
        // setup TableView
        tableView.register(EventTableCell.self, forCellReuseIdentifier: EventTableCell.reuseIdentifier)
        
        // setup search bar at the top
        searchController.searchResultsUpdater = self
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        // run a inital serach to populate the tableView with some Texas pride. ;)
        search(text: "Texas Rangers")
    }
    
    /// Simple way to reload the existing viewModels with the favorited items.
    func reload() {
        var viewModels = [EventViewModel]()
        for model in events {
            viewModels.append(EventViewModel(event: model.event))
        }
        events = viewModels
        tableView.reloadData()
    }
    
    /// Return results from the SeatGeek Service/endpoint.
    /// - Parameter text: query text to send to the service.
    func search(text: String) {
        guard text != "" else {return} // don't run the query if there is no text.
        SeatGeekClient.shared.getEvents(query: text) { [weak self] (es, error) in
            guard let s = self, let es = es else {return}
            if let error = error {
                print("failure: \(error)")
                return
            }
            DispatchQueue.main.async { // dispatch to the main queue, so we can update the UI
                s.events.removeAll()
                for event in es {
                    s.events.append(EventViewModel(event: event))
                }
                s.tableView.reloadData()
            }
        }
    }
    
    // MARK: - TableViewDelegate & Datasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableCell
        
        let event = events[indexPath.row]
        cell.titleLabel.text = event.title
        cell.locationLabel.text = event.displayLocation
        cell.dateLabel.text = event.date
        cell.favoritedView.isHidden = !event.isFavorited
        cell.imgView.image = nil
        if let url = event.imageURL {
            cell.imgView.kf.setImage(with: url)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.event = events[indexPath.row]
        vc.delegate = self
        splitViewController?.showDetailViewController(UINavigationController(rootViewController: vc), sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
        
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(text: searchText)
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        search(text: searchBar.text!)
    }
    
    // MARK: - Favorited
    
    func didFavorite() {
        reload()
    }

}

