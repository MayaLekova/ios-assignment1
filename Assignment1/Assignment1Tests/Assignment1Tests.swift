//
//  Assignment1Tests.swift
//  Assignment1Tests
//
//  Created by Maya Lekova on 1/20/17.
//  Copyright © 2017 Maya Lekova. All rights reserved.
//

import XCTest
@testable import Assignment1

class Assignment1Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMovieSearchSucceeds() {
        MovieData.sharedInstance.searchForMovies(movieTitle: "Batman")
        // TODO: How to test the result?
        XCTAssert(MovieData.sharedInstance.episodes!.count > 0)
    }

    func testMovieSearchFails() {
        MovieData.sharedInstance.searchForMovies(movieTitle: "NonexistingMovie")
        XCTAssert(MovieData.sharedInstance.episodes!.count == 0)
    }
    
    func testMovieDetails() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "gotMovieDetails"), object: nil, queue: nil, using: {
            notification in
                let movieDetailsObj = notification.userInfo as? Dictionary<String,MovieDetails>
                let movieDetails = movieDetailsObj?["details"] ?? nil
                XCTAssert((movieDetails != nil))
                XCTAssert(movieDetails!.title == "Futurama")
        })
        MovieData.sharedInstance.obtainMovieDetails(imdbID: "tt0149460")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
