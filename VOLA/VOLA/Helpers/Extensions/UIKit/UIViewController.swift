//
//  UIViewController.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/6/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import UIKit

extension UIViewController: StoryboardIdentifiable {}

extension UIViewController {

    func performSegue(_ segue: Segue) {
        performSegue(withIdentifier: segue.identifier, sender: self)
    }

    func findActivityIndicator() -> UIActivityIndicatorView? {
        var currentIndicator: UIActivityIndicatorView? = nil
        for case let indicator as UIActivityIndicatorView in view.subviews {
            currentIndicator = indicator
            break
        }

        return currentIndicator
    }

    func displayActivityIndicator() {
        guard findActivityIndicator() == nil else {
            // Make sure there isn't already an activity indicator
            Logger.error(UIError.existingActivityIndicator.localizedDescription)
            return
        }

        let indicator = UIActivityIndicatorView(frame: view.frame)
        indicator.activityIndicatorViewStyle = .gray
        indicator.center = view.center
        indicator.isHidden = false
        indicator.startAnimating()
        self.view.addSubview(indicator)
    }

    func removeActivityIndicator() {
        for case let indicator as UIActivityIndicatorView in view.subviews {
            indicator.removeFromSuperview()
        }
    }
}
