//
//  ViewController.swift
//  Assignment1
//
//  Created by Maya Lekova on 1/20/17.
//  Copyright © 2017 Maya Lekova. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var episodes: Array<Search>? {
        didSet{
            //everytime savedarticles is added to or deleted from table is refreshed
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // Register to receive notification data
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.notifyObservers), name:  NSNotification.Name(rawValue: "gotMovieData"), object: nil)
        MovieData.sharedInstance.parseData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /** This listens out for the data model to send data
     
     - parameter notification : NSNotification The data passed as key value dictionary to our listener method
     */
    func notifyObservers(notification : NSNotification) {
        let episodeInfo = notification.userInfo as? Dictionary<String,Array<Search>?>
        episodes = episodeInfo?["episode"] ?? Array<Search>()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (episodes?.count) ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = episodes?[indexPath.row].title ?? "Unknown entry"
        cell.textLabel!.text = item
        
        let url = URL(string: episodes?[indexPath.row].poster ?? "")
        // Make sure to have placeholder as described in https://github.com/rs/SDWebImage/issues/9
        cell.imageView?.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Placeholder"))
        
        return cell
    }
}
