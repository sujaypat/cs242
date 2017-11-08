//
//  FollowingViewController.swift
//  GitHub Viewer
//
//  Created by Sujay Patwardhan on 10/19/17.
//  Copyright © 2017 Sujay Patwardhan. All rights reserved.
//

import UIKit
import CoreData

class FollowingViewController: PersonListViewController {
    
    override func viewDidLoad() {
        // only pulls users who are followed by the current user
        fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "following == YES")
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // allows unfollow and handles API call for unfollowing
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let person = fetchedResultsController.object(at: indexPath)
        let username = person.userName!
        let id = person.id
        
        let unfollow = UITableViewRowAction(style: .normal, title: "Unfollow", handler: { action, indexPath in
            GithubService.unfollowUser(target: username)
            .onSuccess { _ in
                    DispatchQueue.main.async() {
                        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
                        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
                        guard let result = try? CoreDataManager.shared.persistentContainer.viewContext.fetch(fetchRequest) else { return }
                        
                        var person: Person
                        switch result.count {
                        case 1:
                            person = result[0]
                            person.following = false
                        default:
                            break
                        }
                    }
                }
            .perform(withAuthorization: UserModel.shared)
        })
        unfollow.backgroundColor = .red
        
        return [unfollow]
    }
    // handles creating alert to follow a user
    @IBAction func follow() {
        let alert = UIAlertController(title: "Follow", message: "Enter a user to follow", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let value = textField!.text!
            print("Text field: \(value)")
            
            // follows and then gets data about user to add to table
            GithubService.followUser(target: value)
            .onSuccess { _ in
                GithubService.getUser(byName: value)
                .onSuccess { (json) in
                    guard let json = json as? [String: Any] else { return }
                    DispatchQueue.main.async() {
                        guard let id = json["id"] as? Int64 else { return }
                        
                        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
                        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
                        guard let result = try? CoreDataManager.shared.persistentContainer.viewContext.fetch(fetchRequest) else { return }
                        
                        var person: Person
                        switch result.count {
                        case 0:
                            person = Person(context: CoreDataManager.shared.persistentContainer.viewContext)
                            person.follower = false
                        case 1:
                            person = result[0]
                        default:
                            fatalError("Internal error")
                        }
                        
                        person.id        = id
                        person.following = true
                        person.imgURL    = json["avatar_url"] as? String ?? ""
                        person.url       = json["html_url"]   as? String ?? ""
                        person.userName  = json["login"]      as? String ?? ""
                    }
                }
                .perform(withAuthorization: UserModel.shared)
            }
            .perform(withAuthorization: UserModel.shared)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

}
