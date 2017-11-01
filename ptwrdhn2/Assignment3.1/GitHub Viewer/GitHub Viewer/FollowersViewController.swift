//
//  FollowersViewController.swift
//  GitHub Viewer
//
//  Created by Sujay Patwardhan on 10/19/17.
//  Copyright © 2017 Sujay Patwardhan. All rights reserved.
//

import UIKit

// this class makes one modification to the parent controller
class FollowersViewController: PersonListViewController {

    // MARK: UIViewController
    override func viewDidLoad() {
        // only pulls users who follow the current user
        fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "follower == YES")
        super.viewDidLoad()
    }
}
