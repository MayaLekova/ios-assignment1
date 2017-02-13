//
//  MoviePreviewTableViewCell.swift
//  Assignment1
//
//  Created by Maya Lekova on 1/28/17.
//  Copyright © 2017 Maya Lekova. All rights reserved.
//

import UIKit

class MoviePreviewTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieDescription: UITextView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var favourMovie: UIButton!

    var data: Search?
    var disableFavourites = false

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setEmptyIcon() {
        let btnImage = UIImage(named: "FavourIcon")
        self.favourMovie.setImage(btnImage , for: UIControlState.normal)
    }
    func setFilledIcon() {
        let btnImage = UIImage(named: "FavourFilledIcon")
        self.favourMovie.setImage(btnImage , for: UIControlState.normal)
    }
    
    func setDataForView(movieData: Search, disableFavourites: Bool = false) {
        self.data = movieData
        self.disableFavourites = disableFavourites
        if self.disableFavourites {
            self.favourMovie.isHidden = true
        } else {
            if self.data?.canFavour ?? true {
                self.setEmptyIcon()
            } else {
                self.setFilledIcon()
            }
        }
        
        self.movieTitle.text = movieData.title ?? "No title"
 
        let url = URL(string: movieData.poster ?? "")
        // Make sure to have placeholder as described in https://github.com/rs/SDWebImage/issues/9
        self.movieImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Placeholder"))
        
        self.movieDescription.text = movieData.year ?? ""
    }

    @IBAction func favourMovie(_ sender: UIButton) {
        if disableFavourites {
            return
        }
        self.data?.favour()
        self.setFilledIcon()
    }
}
