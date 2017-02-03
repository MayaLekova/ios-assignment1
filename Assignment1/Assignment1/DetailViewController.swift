//
//  DetailViewController.swift
//  Assignment1
//
//  Created by Maya Lekova on 1/31/17.
//  Copyright © 2017 Maya Lekova. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var movieDetails: MovieDetails?
    
    @IBOutlet weak var moviePlot: UITextView!
    @IBOutlet weak var movieTitle: UITextView!
    @IBOutlet weak var moviePoster: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        movieTitle.text = movieDetails?.title ?? "No title"
        moviePlot.text = movieDetails?.plot ?? "Empty plot"

        let url = URL(string: movieDetails?.poster ?? "")
        self.moviePoster.kf.setImage(with: url)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        movieTitle.setContentOffset(CGPoint.zero, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
