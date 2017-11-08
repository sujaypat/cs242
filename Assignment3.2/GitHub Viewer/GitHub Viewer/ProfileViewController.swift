//
//  ProfileViewController.swift
//  GitHub Viewer
//
//  Created by Sujay Patwardhan on 10/19/17.
//  Copyright © 2017 Sujay Patwardhan. All rights reserved.
//

import UIKit
import Foundation
import OAuthSwift
import CoreData

let USER: String = "coreos"

class ProfileViewController: UIViewController {

    // connections to all the interface elements
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var actualName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var repos: UIButton!
    @IBOutlet weak var followers: UIButton!
    @IBOutlet weak var following: UIButton!
    @IBOutlet weak var created: UILabel!
    
    
    var username = USER.components(separatedBy: "/").last!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GithubService.getUser(byName: username)
        .onSuccess { (json) in
//            guard let json = json as? [String: Any] else { return }

            self.downloadImage(url: URL(string: json["avatar_url"].stringValue)! )

            DispatchQueue.main.async() {
                // populate the labels on the profile page
                self.actualName.text = json["name"].stringValue
                self.userName.text   = json["login"].stringValue
                self.bio.text        = json["bio"].string ?? "No bio provided :("
                self.website.text    = json["blog"].string ?? "No website provided :("
                self.email.text      = json["email"].string ?? "No public email :("
                self.created.text    = "created on: " + (json["created_at"].string ?? "")

                // populate button labels
                self.repos.setTitle("\(json["public_repos"].intValue) public repos", for: .normal)
                self.followers.setTitle("Followers: \(json["followers"].intValue)",  for: .normal)
                self.following.setTitle("Following: \(json["following"].intValue)",  for: .normal)
            }
        }
        .onFailure { (reason: String) in
            print(reason)
        }
        .perform(withAuthorization: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // enable using buttons or tabs to change tabs
    @IBAction func changeTab(sender: UIButton) {
        guard let tabBarController = tabBarController, let label = sender.currentTitle else { return }

        print(label)
        if label.contains("repos") {
            tabBarController.selectedIndex = 1
        }
        if label.contains("Following") {
            tabBarController.selectedIndex = 2
        }
        if label.contains("Followers") {
            tabBarController.selectedIndex = 3
        }
    }
    
    // The below functions are from a stack overflow question about downloading images from a url
    // to use in an ImageView
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }.resume()
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.avatar.image = UIImage(data: data)
            }
        }
    }


}

