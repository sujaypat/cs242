//
//  ProfileViewController.swift
//  GitHub Viewer
//
//  Created by Sujay Patwardhan on 10/19/17.
//  Copyright © 2017 Sujay Patwardhan. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import OAuthSwift
import CoreData

let USER : String = "https://api.github.com/users/sujaypat";

class ProfileViewController: UIViewController {
    
    var json : JSON = JSON.null;
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
        // Do any additional setup after loading the view, typically from a nib.
        getUserData(url: "https://api.github.com/users/\(self.username)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    func getUserData(url: String) {
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                self.json = JSON(value)
//                print("JSON: \(self.json)")
                self.downloadImage(url: URL(string: self.json["avatar_url"].stringValue)!)
                self.actualName.text = self.json["name"].stringValue
                self.userName.text = self.json["login"].stringValue
                self.bio.text = self.json["bio"].string ?? "No bio provided :("
                self.website.text = self.json["blog"].string ?? "No website provided :("
                self.email.text = self.json["email"].string ?? "No public email :("
                self.created.text = "created on: " + self.json["created_at"].stringValue
                self.repos.setTitle((self.json["public_repos"].stringValue + " public repos"), for: .normal)
                self.followers.setTitle(("Followers: " + self.json["followers"].stringValue), for: .normal)
                self.following.setTitle(("Following: " + self.json["following"].stringValue), for: .normal)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func changeTab(sender: UIButton) {
        let label = sender.currentTitle!
        print(label)
        if label.contains("repos"){
            super.tabBarController!.selectedIndex = 1;
        }
        if label.contains("Following"){
            super.tabBarController!.selectedIndex = 2;
        }
            if label.contains("Followers"){
            super.tabBarController!.selectedIndex = 3;
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

