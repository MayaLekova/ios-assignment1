//
//  MovieData.swift
//  Assignment1
//
//  Created by Maya Lekova on 1/20/17.
//  Copyright © 2017 Maya Lekova. All rights reserved.
//

import UIKit
import Alamofire

// Inspired by http://stackoverflow.com/a/27269242
extension String {
    
    var parseJSONString: Any? {
        
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let jsonData = data {
            // Will return an object or nil if JSON decoding fails
            do {
                let parsedData = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
                return parsedData
            } catch {
                return nil
            }
        } else {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
}

class MovieData {
    var episodes: Array<Search>?
    var json = "Invalid"
    
    static fileprivate let apiController = APIController()

    static let sharedInstance = MovieData()
    private init() {
    }
    
    func searchForMovies(movieTitle: String) {
        // TODO: get rid of temporary data
        self.episodes = []
        guard let url = MovieData.apiController.createURLWithComponents(term: SearchTerm.byTitle(movieTitle)) else {
            print("ERROR: invalid URL for movieTitle \(movieTitle)")
            return
        }
        Alamofire.request(url).responseString { response in
            if let JSON = response.result.value {
                self.json = JSON
                
                if let jsonObj = self.json.parseJSONString {
                    if let movieData = jsonObj as? NSDictionary {
                        if let movieObj = Json4Swift_Base(dictionary: movieData)
                        {
                            self.episodes = movieObj.search
                            //post our data
                            let episodesLoaded = ["episode" : self.episodes]
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "gotMovieData"), object: self , userInfo: episodesLoaded)
                        } else {
                            print("Unable to construct movie object")
                        }
                    } else {
                        print("Unable to interpret parsed object as dictionary")
                        print(jsonObj)
                    }
                } else {
                    print("Unable to parse JSON")
                }
            }
        }
    }
    
    func obtainMovieDetails(imdbID: String) {
        guard let url = MovieData.apiController.createURLWithComponents(term: .byImdbID(imdbID)) else {
            print("ERROR: invalid URL for imdbID \(imdbID)")
            return
        }
        Alamofire.request(url).responseString { response in
            if let JSON = response.result.value,
            let jsonObj = JSON.parseJSONString,
            let movieData = jsonObj as? NSDictionary,
            let movieObj = MovieDetails(dictionary: movieData) {
                let movieDetails = ["details": movieObj]
                NotificationCenter.default.post(name: Notification.Name(rawValue: "gotMovieDetails"), object: self , userInfo: movieDetails)
            }
        }
    }
}
