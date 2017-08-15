//
//  DetailViewController.swift
//  HomeAway
//
//  Created by Austin Cherry on 8/14/17.
//  Copyright © 2017 Vluxe. All rights reserved.
//

import UIKit

protocol Favorited: class {
    func didFavorite()
}

class DetailViewController: UIViewController {
    let detailView = DetailView()
    weak var delegate: Favorited?
    var event: EventViewModel? {
        didSet {
            guard let event = event else {return}
            title = event.shortTitle
            detailView.titleLabel.text = event.title
            detailView.locationLabel.text = event.displayLocation
            detailView.dateLabel.text = event.date
            if let url = event.imageURL {
                detailView.imgView.kf.setImage(with: url)
            }
        }
    }
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "heart"), style: .plain, target: self, action: #selector(favorite))
        checkHeartColor()
    }
    
    // MARK: - Target Actions
    
    func favorite() {
        guard let event = event else {return}
        SeatGeekClient.shared.updateFavorite(eventId: event.id, isFavorited: !event.isFavorited)
        checkHeartColor()
        delegate?.didFavorite()
    }
    
    func checkHeartColor() {
        guard let event = event else {return}
        navigationItem.rightBarButtonItem?.tintColor = event.isFavorited ? .red : .gray
    }
}
