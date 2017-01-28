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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDataForView(movieData: Search) {
        self.movieTitle.text = movieData.title ?? "No title"
 
        let url = URL(string: movieData.poster ?? "")
        // Make sure to have placeholder as described in https://github.com/rs/SDWebImage/issues/9
        self.movieImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Placeholder"))
    }
    
}
