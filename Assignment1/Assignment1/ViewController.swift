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
    var currentScope: MovieType = .MTAll
    
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
        self.definesPresentationContext = true
        searchController.searchBar.placeholder = NSLocalizedString("mainScreen.searchBar.placeholder", comment: "")
        
        // Set localized "Cancel" button title
        // as described in http://stackoverflow.com/a/40257292
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = NSLocalizedString("mainScreen.searchBar.cancel", comment: "")
        
        // Attach the newly created searchBar to the table's header
        self.tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.scopeButtonTitles = [
            MovieType.MTAll.localizedString,
            MovieType.MTMovie.localizedString,
            MovieType.MTEpisode.localizedString,
            MovieType.MTSeries.localizedString
        ]
        searchController.searchBar.delegate = self
        
        // Register to receive notification data
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateMovieData), name:  NSNotification.Name(rawValue: "gotMovieData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateMovieDetails), name:  NSNotification.Name(rawValue: "gotMovieDetails"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.edgesForExtendedLayout = []
        
        // Redo the request in order to work around "Object has been deleted or invalidated." exception
        // when favouring the same movie after it's been removed from favourites
        // More info: http://stackoverflow.com/questions/32308842/realm-can-i-save-a-object-after-delete-the-object
        performSearch()
        
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchController.isActive = false
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
            MovieData.sharedInstance.searchForMovies(movieTitle: searchTerm, page: self.currentPage, type: self.currentScope)
        }
    }

    /** This listens out for the data model to send data
     
     - parameter notification : NSNotification The data passed as key value dictionary to our listener method
     */
    func updateMovieData(notification : NSNotification) {
        self.hideLoadingNotification()

        guard let episodeInfo = notification.userInfo,
                let totalResults = episodeInfo["totalResults"] as? Int else {
            print("ERROR: updateMovieData unable to parse userInfo from notification")
            return
        }
        
        //      To better understand this formula
        //        results	-> pages
        //        31 		-> 4
        //        30 		-> 3
        //        29 		-> 3
        self.totalPages = (totalResults - 1) / ViewController.resultsPerPage + 1
        
        guard let episodes = episodeInfo["episodes"] as? Array<Search> else {
            self.episodes = []
            // TODO: display "No movies found" warning
            return
        }
        self.episodes?.append(contentsOf: episodes)
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
        
        guard self.currentSearchTerm != nil else {
            return
        }
        
        let lastElement = (episodes?.count ?? 0) - 1
        if indexPath.row == lastElement && self.currentPage < self.totalPages {
            self.currentPage += 1
            self.performSearch()
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
        let scopeString = searchBar.scopeButtonTitles![selectedScope]
        guard let currentScope = MovieType(localizedString: scopeString) else {
            print("ERROR: Unknown string value for movie type \(scopeString)")
            return
        }
        
        if currentScope != self.currentScope {
            self.currentScope = currentScope
            self.performSearch()
        }
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

