//
//  FirstViewController.swift
//  GitHub Viewer
//
//  Created by Sujay Patwardhan on 10/19/17.
//  Copyright © 2017 Sujay Patwardhan. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class FirstViewController: UIViewController {
    
    var json : JSON = JSON.null;
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var actualName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        avatar.image = UIImage(named: "first")
        // Do any additional setup after loading the view, typically from a nib.
        getUserData(url: "https://api.github.com/users/redsn0w422")
//        print(self.json)
        
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
                print("JSON: \(self.json)")
                self.downloadImage(url: URL(string: self.json["avatar_url"].stringValue)!)
                self.actualName.text = self.json["name"].stringValue
                self.userName.text = self.json["login"].stringValue
                self.bio.text = self.json["bio"].string ?? "No bio provided :("
                self.website.text = self.json["blog"].string ?? "No website provided :("
                self.email.text = self.json["email"].string ?? "No public email :("
            case .failure(let error):
                print(error)
            }
        }
    }
    
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
//                self.avatar.image = UIImage(named: "first")
                self.avatar.image = UIImage(data: data)
            }
        }
    }


}

