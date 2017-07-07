//
//  EventDetailViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/15/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit
import Kingfisher

class EventDetailViewController: UIViewController, XIBInstantiable {

    @IBOutlet weak var registeredLabel: RegisteredLabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var volunteersNeededView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sponsoredView: UIView!
    @IBOutlet weak var sponsorImageView: UIImageView!
    @IBOutlet weak var registerView: UIView!

    var event: Event = Event()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Configure stack view
        configureDetailView()
    }

    func configureDetailView() {
        // Details viewable in all events
        eventTitleLabel.text = event.name
        addressLabel.text = event.location.addressString()
        descriptionLabel.text = event.description
        if let eventImageURL = event.eventImageURL {
            eventImageView.kf.setImage(with: eventImageURL)
        }

        // Optional view
        volunteersNeededView.isHidden = !event.areVolunteersNeeded
        if let sponsorImageURL = event.sponsorImageURL {
            sponsorImageView.kf.setImage(with: sponsorImageURL)
        } else {
            sponsoredView.isHidden = true
        }

        // Views dependent on event.eventType status
        registeredLabel.eventType = event.eventType
        if event.eventType == .unregistered {
            let registerBarButton = UIBarButtonItem(title: "register.prompt.label".localized, style: .plain, target: self, action: #selector(onRegisterPressed(_:)))
            navigationItem.rightBarButtonItem = registerBarButton
        }
    }
}

// MARK: - IBActions
extension EventDetailViewController {
    @IBAction func onDirectionsPressed(_ sender: Any) {
        // TODO open map app
    }

    @IBAction func onRegisterPressed(_ sender: Any) {
        let registrationVC: EventRegistrationViewController = UIStoryboard(.home).instantiateViewController()
        registrationVC.event = event
        navigationController?.show(registrationVC, sender: self)
    }
}
