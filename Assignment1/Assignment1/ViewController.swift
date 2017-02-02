//
//  ViewController.swift
//  Assignment1
//
//  Created by Maya Lekova on 1/20/17.
//  Copyright © 2017 Maya Lekova. All rights reserved.
//

import UIKit
import Kingfisher
import MBProgressHUD

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var ownView: UIView!
    
    var episodes: Array<Search>? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var totalPages = 0
    var currentPage = 0
    static let resultsPerPage = 10
    
    var currentEpisode: MovieDetails?
    var currentSearchTerm: String?
    
    let searchController = UISearchController(searchResultsController: nil)
    var loadingNotification: MBProgressHUD?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let nib = UINib(nibName: "MoviePreviewTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "MoviePreviewTableViewCell")
        
        // SearchResultsUpdater allows class to be informed of text changes
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchBar.placeholder = NSLocalizedString("mainScreen.searchBar.placeholder", comment: "")
        
        // Set localized "Cancel" button title
        // as described in http://stackoverflow.com/a/40257292
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = NSLocalizedString("mainScreen.searchBar.cancel", comment: "")
        
        // Attach the newly created searchBar to the table's header
        self.tableView.tableHeaderView = searchController.searchBar
        
        // TODO: Localize titles
        searchController.searchBar.scopeButtonTitles = ["Movie", "Episode", "Series", "All"]
        searchController.searchBar.delegate = self
        
        // Register to receive notification data
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateMovieData), name:  NSNotification.Name(rawValue: "gotMovieData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateMovieDetails), name:  NSNotification.Name(rawValue: "gotMovieDetails"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.edgesForExtendedLayout = []
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "detailView" {
            self.searchController.isActive = false

            let detailView = segue.destination as! DetailViewController
            detailView.movieDetails = self.currentEpisode
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showLoadingNotification() {
        self.loadingNotification = MBProgressHUD.showAdded(to: self.ownView, animated: true)
        loadingNotification?.mode = MBProgressHUDMode.indeterminate
        loadingNotification?.label.text = "Loading"
    }
    
    func hideLoadingNotification() {
        self.loadingNotification?.hide(animated: true)
    }
    
    func performSearch() {
        if let searchTerm = self.currentSearchTerm {
            self.showLoadingNotification()
            
            self.episodes = []
            MovieData.sharedInstance.searchForMovies(movieTitle: searchTerm)
        }
    }

    /** This listens out for the data model to send data
     
     - parameter notification : NSNotification The data passed as key value dictionary to our listener method
     */
    func updateMovieData(notification : NSNotification) {
        guard let episodeInfo = notification.userInfo,
            let episodes   = episodeInfo["episodes"]   as? Array<Search>,
            let totalResults = episodeInfo["totalResults"] as? Int else {
                print("ERROR: updateMovieData unable to parse userInfo from notification")
                return
        }
        
        self.hideLoadingNotification()
        self.episodes?.append(contentsOf: episodes)
        
//      To better understand this formula
//        results	-> pages
//        31 		-> 4
//        30 		-> 3
//        29 		-> 3
        self.totalPages = (totalResults - 1) / ViewController.resultsPerPage + 1
    }

    func updateMovieDetails(notification : NSNotification) {
        let movieDetailsObj = notification.userInfo as? Dictionary<String, MovieDetails>
        if let movieDetails = movieDetailsObj?["details"] {
            self.hideLoadingNotification()
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
            self.showLoadingNotification()
            MovieData.sharedInstance.obtainMovieDetails(imdbID: imdbID)
        } else {
            print("ERROR: episode without imdbID")
        }
    }
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        
        guard let searchTerm = self.currentSearchTerm else {
            return
        }
        
        let lastElement = (episodes?.count ?? 0) - 1
        if indexPath.row == lastElement && self.currentPage < self.totalPages {
            self.currentPage += 1
            
            MovieData.sharedInstance.searchForMovies(movieTitle: searchTerm, page: self.currentPage)
        }
    }
}

// MARK: Search Scheduler

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for: UISearchController) {
    }
}

// MARK: Search Delegate

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.currentSearchTerm = searchBar.text!
        self.performSearch()
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.currentPage = 1
        return true
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        // TODO
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.currentSearchTerm = searchBar.text!
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
        // to limit network activity, reload 3 seconds after last key press.
        // as described in http://stackoverflow.com/a/34544749
        self.perform(#selector(self.reload), with: nil, afterDelay: 3)
    }
    func reload() {
        self.performSearch()
    }
}

