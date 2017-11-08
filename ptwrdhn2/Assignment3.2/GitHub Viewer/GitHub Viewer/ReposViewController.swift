//
//  ReposViewController.swift
//  GitHub Viewer
//
//  Created by Sujay Patwardhan on 10/19/17.
//  Copyright © 2017 Sujay Patwardhan. All rights reserved.
//

import UIKit
import SafariServices
import APIManager
import CoreData

class ReposViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    // allows star/unstar button and handles API calls for those actions
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let reponame = fetchedResultsController.object(at: indexPath).name!
        let star = UITableViewRowAction(style: .normal, title: "Star/Unstar") { action, index in
            // if following, unfollows and vice versa
            GithubService.doesUserHaveStarred(byUsername: USER, repoName: reponame)
            .onSuccess { _ in
                GithubService.unstarRepo(byUsername: USER, repoName: reponame)
                .onFailure { reason in
                    print(reason)
                }
                .perform(withAuthorization: UserModel.shared)
            }
            .onFailure { _ in
                GithubService.starRepo(byUsername: USER, repoName: reponame)
                .onFailure { reason in
                    print(reason)
                }
                .perform(withAuthorization: UserModel.shared)
            }
            .perform(withAuthorization: UserModel.shared)
            self.tableView.isEditing = false
        }
        star.backgroundColor = .blue
        
        return [star]
    }
    
    // MARK: CoreData
    lazy var fetchedResultsController: NSFetchedResultsController<Repo> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Repo> = Repo.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to launch NSFetchedResultsController.performFetch()")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let profileViewController = segue.destination as? ProfileViewController,
            let indexPath = sender as? IndexPath {
            profileViewController.username = fetchedResultsController.object(at: indexPath).userName ?? ""
        }
    }
    
    // MARK: UITableViewDatasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return 0 }
        return fetchedObjects.count
    }
    
    // create, populate, and use reusable rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let repo = fetchedResultsController.object(at: indexPath)
        cell.detailTextLabel?.text = repo.desc
        cell.textLabel?.text = repo.name
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return 0 }
        return fetchedObjects.count > 0 ? 1 : 0
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let view = SFSafariViewController(url: URL(string: fetchedResultsController.object(at: indexPath).url!)!)
        self.present(view, animated: true, completion: nil)
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // handles the possible table row operations
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let insertIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [insertIndexPath], with: .fade)
        case .delete:
            guard let deleteIndexPath = indexPath else { return }
            tableView.deleteRows(at: [deleteIndexPath], with: .fade)
        case .update:
            guard let updateIndexPath = indexPath else { return }
            tableView.reloadRows(at: [updateIndexPath], with: .fade)
        case .move:
            guard let fromIndexPath = indexPath, let toIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [toIndexPath],   with: .fade)
            tableView.deleteRows(at: [fromIndexPath], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

}

