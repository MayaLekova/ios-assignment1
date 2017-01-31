//
//  APIController.swift
//  Assignment1
//
//  Created by Maya Lekova on 1/30/17.
//  Copyright © 2017 Maya Lekova. All rights reserved.
//

import Foundation

enum SearchTerm {
    case byTitle(String)
    case byImdbID(String)
}

class APIController {
    private static func searchQuery(by term: SearchTerm) -> URLQueryItem {
        switch term {
        case .byTitle(let title):
            return URLQueryItem(name: "s", value: title)
        case .byImdbID(let imdbID):
            return URLQueryItem(name: "i", value: imdbID)
        }
    }
    private static func plotLength(by term: SearchTerm) -> URLQueryItem? {
        switch term {
        case .byImdbID:
            return URLQueryItem(name: "plot", value: "full")
        default:
            return nil
        }
    }
    private static func pageNumber(by term: SearchTerm, page: Int = 1) -> URLQueryItem? {
        switch term {
        case .byTitle:
            return URLQueryItem(name: "page", value: "\(page)")
        default:
            return nil
        }
    }
   
    func createURLWithComponents(term: SearchTerm, page: Int = 1) -> URL? {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = "https";
        urlComponents.host = "www.omdbapi.com";
        urlComponents.path = "";
        
        // add params
        let searchQuery = APIController.searchQuery(by: term)
        let plotLength = APIController.plotLength(by: term)
        let pageNumber = APIController.pageNumber(by: term, page: page)
        // TODO:
//        type 	No 	movie, series, episode 	<empty> 	Type of result to return.
//        y 	No 		<empty> 	Year of release.
//        r 	No 	json, xml 	json 	The data type to return.
//        page 	No 	1-100 	1 	Page number to return.
//        callback 	No 		<empty> 	JSONP callback name.
//        v 	No 		1 	API version (reserved for future use).
        
        urlComponents.queryItems = [searchQuery]
        if plotLength != nil {
            urlComponents.queryItems?.append(plotLength!)
        }
        if pageNumber != nil {
            urlComponents.queryItems?.append(pageNumber!)
        }
        
        return urlComponents.url
    }
}
