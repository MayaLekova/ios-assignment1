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
    static fileprivate let apiController = APIController()

    static let sharedInstance = MovieData()
    private init() {
    }
    
    func searchForMovies(movieTitle: String, page: Int = 1, type: MovieType = .MTAll) {
        guard let url = MovieData.apiController.createURLWithComponents(term: SearchTerm.byTitle(movieTitle), page: page, type: type) else {
            print("ERROR: invalid URL for movieTitle \(movieTitle)")
            return
        }
        
        Alamofire.request(url).responseString { response in
            if let JSON = response.result.value,
            let jsonObj = JSON.parseJSONString,
            let movieData = jsonObj as? NSDictionary,
            let movieObj = Json4Swift_Base(dictionary: movieData){
                let episodesLoaded: [String : Any] = [
                    "episodes" : movieObj.search as Any,
                    "totalResults" : movieObj.totalResults as Any]
                NotificationCenter.default.post(name: Notification.Name(rawValue: "gotMovieData"), object: self , userInfo: episodesLoaded)
            }
        }
    }
    
    func obtainMovieDetails(imdbID: String) {
        guard let url = MovieData.apiController.createURLWithComponents(term: .byImdbID(imdbID)) else {
            print("ERROR: invalid URL for imdbID \(imdbID)")
            return
        }
        Alamofire.request(url).responseString { response in
            guard response.result.isSuccess else {
                print("ERROR: unable to obtain movie details for imdbID: \(imdbID)")
                return
            }
            if let JSON = response.result.value,
            let jsonObj = JSON.parseJSONString,
            let movieData = jsonObj as? NSDictionary,
            let movieObj = MovieDetails(dictionary: movieData) {
                if movieObj.response != nil && movieObj.response! == false {
                    let errorObj = APIResponse(dictionary: movieData)
                    print("\(errorObj!) while trying to obtain movie details for imdbID: \(imdbID)")
                    return
                }
                
                let movieDetails = ["details": movieObj]
                NotificationCenter.default.post(name: Notification.Name(rawValue: "gotMovieDetails"), object: self , userInfo: movieDetails)
            }
        }
    }
}
