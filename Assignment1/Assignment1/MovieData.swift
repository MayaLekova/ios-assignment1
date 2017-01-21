//
//  MovieData.swift
//  Assignment1
//
//  Created by Maya Lekova on 1/20/17.
//  Copyright © 2017 Maya Lekova. All rights reserved.
//

import UIKit

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

class MovieData: NSObject {
    var episodes: Array<Episodes>?

    // Escaped data from http://www.omdbapi.com/?t=Game%20of%20Thrones&Season=1
    let json = "{\"Title\":\"Game of Thrones\",\"Season\":\"1\",\"totalSeasons\":\"8\",\"Episodes\":[{\"Title\":\"Winter Is Coming\",\"Released\":\"2011-04-17\",\"Episode\":\"1\",\"imdbRating\":\"9.0\",\"imdbID\":\"tt1480055\"},{\"Title\":\"The Kingsroad\",\"Released\":\"2011-04-24\",\"Episode\":\"2\",\"imdbRating\":\"8.8\",\"imdbID\":\"tt1668746\"},{\"Title\":\"Lord Snow\",\"Released\":\"2011-05-01\",\"Episode\":\"3\",\"imdbRating\":\"8.6\",\"imdbID\":\"tt1829962\"},{\"Title\":\"Cripples, Bastards, and Broken Things\",\"Released\":\"2011-05-08\",\"Episode\":\"4\",\"imdbRating\":\"8.7\",\"imdbID\":\"tt1829963\"},{\"Title\":\"The Wolf and the Lion\",\"Released\":\"2011-05-15\",\"Episode\":\"5\",\"imdbRating\":\"9.1\",\"imdbID\":\"tt1829964\"},{\"Title\":\"A Golden Crown\",\"Released\":\"2011-05-22\",\"Episode\":\"6\",\"imdbRating\":\"9.1\",\"imdbID\":\"tt1837862\"},{\"Title\":\"You Win or You Die\",\"Released\":\"2011-05-29\",\"Episode\":\"7\",\"imdbRating\":\"9.2\",\"imdbID\":\"tt1837863\"},{\"Title\":\"The Pointy End\",\"Released\":\"2011-06-05\",\"Episode\":\"8\",\"imdbRating\":\"9.0\",\"imdbID\":\"tt1837864\"},{\"Title\":\"Baelor\",\"Released\":\"2011-06-12\",\"Episode\":\"9\",\"imdbRating\":\"9.6\",\"imdbID\":\"tt1851398\"},{\"Title\":\"Fire and Blood\",\"Released\":\"2011-06-19\",\"Episode\":\"10\",\"imdbRating\":\"9.4\",\"imdbID\":\"tt1851397\"}],\"Response\":\"True\"}"

    override init() {
        if let jsonObj = json.parseJSONString {
            if let movieData = jsonObj as? NSDictionary {
                if let movieObj = Json4Swift_Base(dictionary: movieData)
                {
                    episodes = movieObj.episodes
                    // maybe retrieve data with pictures from http://www.omdbapi.com/?s=Batman
                    // and construct custom cells with pictures
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

extension MovieData: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (episodes?.count) ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = episodes?[indexPath.row].title ?? "Unknown entry"
        
        cell.textLabel!.text = item
        
        return cell
    }
}
