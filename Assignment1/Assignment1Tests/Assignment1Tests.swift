//
//  Assignment1Tests.swift
//  Assignment1Tests
//
//  Created by Maya Lekova on 1/20/17.
//  Copyright © 2017 Maya Lekova. All rights reserved.
//

import XCTest
@testable import Assignment1

class MovieDataTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMovieSearchSucceeds() {
        let exp = expectation(description: "Alamofire")
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "gotMovieData"), object: nil, queue: nil, using: {
            notification in
            guard let episodeInfo = notification.userInfo else {
                XCTFail()
                return
            }
            let totalResults = episodeInfo["totalResults"] as? Int ?? 0
            let episodes = episodeInfo["episodes"] as? Array<Search> ?? []
            XCTAssert(totalResults > 0)
            XCTAssert(episodes.count > 0)
            
            exp.fulfill()
        })
        MovieData.sharedInstance.searchForMovies(movieTitle: "Batman")
        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testMovieSearchFails() {
        let exp = expectation(description: "Alamofire")
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "gotMovieData"), object: nil, queue: nil, using: {
            notification in
            guard let episodeInfo = notification.userInfo else {
                XCTFail()
                return
            }
            let totalResults = episodeInfo["totalResults"] as? Int ?? 0
            XCTAssertEqual(totalResults, 0)
            
            exp.fulfill()
        })
        MovieData.sharedInstance.searchForMovies(movieTitle: "NonexistingMovie")
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testMovieDetails() {
        let exp = expectation(description: "Alamofire")
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "gotMovieDetails"), object: nil, queue: nil, using: {
            notification in
                let movieDetailsObj = notification.userInfo as? Dictionary<String,MovieDetails>
                let movieDetails = movieDetailsObj?["details"] ?? nil
                XCTAssertNotNil(movieDetails)
                XCTAssert(movieDetails!.title == "Futurama")
            
                exp.fulfill()
        })
        MovieData.sharedInstance.obtainMovieDetails(imdbID: "tt0149460")
        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
