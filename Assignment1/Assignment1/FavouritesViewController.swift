//
//  FavouritesViewController.swift
//  Assignment1
//
//  Created by Maya Lekova on 2/9/17.
//  Copyright © 2017 Maya Lekova. All rights reserved.
//

import UIKit
import RealmSwift

class FavouritesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var notificationToken: NotificationToken?

    var favourites: Results<Search>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "MoviePreviewTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "MoviePreviewTableViewCell")
    }
    
    func observeFavouritesChanges() {
        self.notificationToken = self.favourites?.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // TODO: add a static method to Favourable
        do {
            let realm = try Realm()
            
            self.favourites = realm.objects(Search.self)
        } catch let error as NSError {
            print("Error while obtaining reference to DB: \(error)")
        }
        
        observeFavouritesChanges()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        notificationToken?.stop()
    }
}

// MARK: TableViewDataSource

extension FavouritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (favourites?.count) ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviePreviewTableViewCell", for: indexPath) as! MoviePreviewTableViewCell
        if let item = favourites?[indexPath.row] {
            cell.setDataForView(movieData: item)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // let the controller to know that able to edit tableView's row
        return true
    }
}

extension FavouritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentEpisode = favourites?[indexPath.row]
        // TODO: obtain details for current episode
    }
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // add the action button you want to show when swiping on tableView's cell , in this case add the delete button.
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action , indexPath) -> Void in
            
            // Your delete code here.....
            if let favToDelete = self.favourites?[indexPath.row] {
                favToDelete.unfavour()
            }
        })
        
        // You can set its properties like normal button
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction]
    }
}
