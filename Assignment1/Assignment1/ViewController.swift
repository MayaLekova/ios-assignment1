//
//  ViewController.swift
//  Assignment1
//
//  Created by Maya Lekova on 1/20/17.
//  Copyright © 2017 Maya Lekova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    let movieData = MovieData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = movieData
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

