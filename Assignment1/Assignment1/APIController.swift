//
//  APIController.swift
//  Assignment1
//
//  Created by Maya Lekova on 1/30/17.
//  Copyright © 2017 Maya Lekova. All rights reserved.
//

import Foundation

class APIController {
    func createURLWithComponents(movieTitle: String) -> URL? {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = "https";
        urlComponents.host = "www.omdbapi.com";
        urlComponents.path = "";
        
        // add params
        let searchQuery = URLQueryItem(name: "s", value: movieTitle)
        // TODO:
//        type 	No 	movie, series, episode 	<empty> 	Type of result to return.
//        y 	No 		<empty> 	Year of release.
//        r 	No 	json, xml 	json 	The data type to return.
//        page 	No 	1-100 	1 	Page number to return.
//        callback 	No 		<empty> 	JSONP callback name.
//        v 	No 		1 	API version (reserved for future use).
        
        urlComponents.queryItems = [searchQuery]
        
        return urlComponents.url
    }
}
