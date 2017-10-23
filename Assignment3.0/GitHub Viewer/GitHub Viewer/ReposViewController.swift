//
//  SecondViewController.swift
//  GitHub Viewer
//
//  Created by Sujay Patwardhan on 10/19/17.
//  Copyright © 2017 Sujay Patwardhan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ReposViewController: UITableViewController {
    
    @IBOutlet weak var webView : UIWebView!
    
    struct Repo {
        let repoName : String
        let userName : String
        let description : String
        let url : URL
    }
    var repos = [Repo]()
    var json : JSON = JSON.null;
    var user : String = USER + "/repos";


    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData(url: user)
    }

    func getUserData(url: String) {
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                self.json = JSON(value)
                print("JSON: \(self.json)")
                self.parseJSON()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func parseJSON(){
        let repoArray = self.json.arrayValue
        for repo in repoArray {
            let name = repo["name"].stringValue
            let owner = repo["owner"]["login"].stringValue
            let description = repo["description"].string ?? "No description provided"
            let url = URL(string: repo["html_url"].stringValue)
            
            let cell = Repo(repoName: name, userName: owner, description: description, url: url!)
            repos.append(cell)
        }
        
        self.tableView.reloadData()
    }
    
    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let repo = repos[indexPath.row]
        cell.textLabel!.text = repo.repoName
        cell.detailTextLabel?.text = repo.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        UIApplication.shared.openURL(repos[indexPath.row].url)
    }

}

