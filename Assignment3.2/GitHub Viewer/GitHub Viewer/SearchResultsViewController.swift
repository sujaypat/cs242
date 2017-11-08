//
//  SearchResultsViewController.swift
//  GitHub Viewer
//
//  Created by Sujay Patwardhan on 11/5/17.
//  Copyright © 2017 Sujay Patwardhan. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class SearchResultsViewController: UITableViewController, UISearchBarDelegate {
    
    struct userResult {
        var id: Int64
        var imgURL: String
        var url: String
        var userName: String
    }
    
    struct repoResult {
        var desc: String
        var name: String
        var url: String
    }
    
    var users = [userResult]()
    var repos = [repoResult]()
    let searchController = UISearchController(searchResultsController: nil)
    
    var shouldSearchRepos: Bool {
        return searchController.searchBar.selectedScopeButtonIndex == 0 ||
        searchController.searchBar.selectedScopeButtonIndex == 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchBar.scopeButtonTitles = ["stars asc", "stars desc", "followers asc", "followers desc"]
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()
    }

    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        print(searchText)
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (shouldSearchRepos) {
            GithubService.searchForRepo(params: ["q": searchController.searchBar.text!.lowercased(), "per_page": "10", "sort": "stars", "order": (searchController.searchBar.selectedScopeButtonIndex == 0 ? "asc" : "desc")])
            .onSuccess { (json) in
                self.repos.removeAll()
                guard let json = json as? [String: Any] else { return }
                
                DispatchQueue.main.async() {

                    for item in (json["items"] as! [[String: Any]]) {

                        guard let name = item["name"] as? String else { continue }

                        let desc     = item["description"] as? String ?? "No description provided"
                        let url      = item["html_url"]    as? String ?? ""


                        self.repos.append(repoResult(desc: desc, name: name, url: url))
                    }
                    self.tableView.reloadData()
                }
            }
            .onFailure { reason in
                print(reason)
            }
            .perform(withAuthorization: UserModel.shared)
        }
        else {
            GithubService.searchForUser(params: ["q": searchController.searchBar.text!.lowercased(), "per_page": "10", "sort": "followers", "order": (searchController.searchBar.selectedScopeButtonIndex == 2 ? "asc" : "desc")])
            .onSuccess { (json) in
                self.users.removeAll()
                guard let json = json as? [String: Any] else { return }

                DispatchQueue.main.async() {
                
                    for item in (json["items"] as! [[String: Any]]) {

                        guard let id = item["id"] as? Int64 else { continue }
                        
                        let imgURL    = item["avatar_url"] as? String ?? ""
                        let url       = item["html_url"]   as? String ?? ""
                        let userName  = item["login"]      as? String ?? ""
                        
                        self.users.append(userResult(id: id, imgURL: imgURL, url: url, userName: userName))
                    }
                    self.tableView.reloadData()
                }
            }
            .onFailure { reason in
                print(reason)
            }
            .perform(withAuthorization: UserModel.shared)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if(shouldSearchRepos) {
            let repo = repos[indexPath.row]
            cell.textLabel?.text = repo.name
            cell.detailTextLabel?.text = repo.desc
        }
        else {
            let person = users[indexPath.row]
            
            let url = URL(string: person.imgURL)!
            let data = try! Data(contentsOf: url)
            let image = UIImage(data: data)
            cell.imageView?.image = image
            cell.textLabel?.text = person.userName
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if (shouldSearchRepos) {
            let view = SFSafariViewController(url: URL(string: repos[indexPath.row].url)!)
            self.present(view, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "showProfileViewController", sender: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shouldSearchRepos ? repos.count : users.count
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let profileViewController = segue.destination as? ProfileViewController,
            let indexPath = sender as? IndexPath {
            profileViewController.username = users[indexPath.row].userName
        }
    }
}
