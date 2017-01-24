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

    static let sharedInstance = MovieData()
    private init() {
    }
    
    func parseData() {
        Alamofire.request("https://www.omdbapi.com/?s=Game%20of%20Thrones&page=1&type=series").responseString { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
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
}
