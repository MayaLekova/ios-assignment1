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
    
    var currentPage = 0
    var currentEpisode: MovieDetails?
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let nib = UINib(nibName: "MoviePreviewTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "MoviePreviewTableViewCell")
        
        // SearchResultsUpdater allows class to be informed of text changes
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        
        // Attach the newly created searchBar to the table's header
        self.tableView.tableHeaderView = searchController.searchBar
        
        // TODO: Localize titles
        searchController.searchBar.scopeButtonTitles = ["Movie", "Episode", "Series", "All"]
        searchController.searchBar.delegate = self
        
        // Register to receive notification data
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateMovieData), name:  NSNotification.Name(rawValue: "gotMovieData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateMovieDetails), name:  NSNotification.Name(rawValue: "gotMovieDetails"), object: nil)
        
        // TODO: get movieTitle from search bar
        MovieData.sharedInstance.searchForMovies(movieTitle: "Futurama")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "detailView" {
            let detailView = segue.destination as! DetailViewController
            detailView.movieDetails = self.currentEpisode
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /** This listens out for the data model to send data
     
     - parameter notification : NSNotification The data passed as key value dictionary to our listener method
     */
    func updateMovieData(notification : NSNotification) {
        let episodeInfo = notification.userInfo as? Dictionary<String,Array<Search>?>
        episodes = episodeInfo?["episode"] ?? Array<Search>()
    }

    func updateMovieDetails(notification : NSNotification) {
        let movieDetailsObj = notification.userInfo as? Dictionary<String,MovieDetails>
        if let movieDetails = movieDetailsObj?["details"] {
            self.currentEpisode = movieDetails
            self.performSegue(withIdentifier: "detailView", sender: nil)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: TableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (episodes?.count) ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviePreviewTableViewCell", for: indexPath) as! MoviePreviewTableViewCell
        if let item = episodes?[indexPath.row] {
            cell.setDataForView(movieData: item)
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentEpisode = episodes?[indexPath.row]
        if let imdbID = currentEpisode?.imdbID {
            MovieData.sharedInstance.obtainMovieDetails(imdbID: imdbID)
        } else {
            print("ERROR: episode without imdbID")
        }
    }
}

// MARK: Search Scheduler

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for: UISearchController) {
        // TODO fire scheduleSearch
    }
}

// MARK: Search Delegate

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TODO
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // TODO
        self.currentPage = 1
        return true
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        // TODO
    }
}

