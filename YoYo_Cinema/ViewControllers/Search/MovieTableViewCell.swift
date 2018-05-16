//
//  MovieTableViewCell.swift
//  YoYo_Cinema
//
//  Created by Nicolai Harbo on 15/05/2018.
//  Copyright © 2018 nicoware. All rights reserved.
//

import UIKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    var movie: Movie? {
        didSet {
            self.updateCell()
        }
    }
    
    //MARK: IBOutlets
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Functions
    func updateCell() {
        if let imageUrl = movie?.poster_path {
            let url = URL(string: imageUrl)
            self.movieImageView.sd_setImage(with: url) { (image, error, cacheType, url) in
            }
        } else {
            //TODO: Set placeholder
        }
        if let title = movie?.title {
            self.movieTitle.text = title
        } else {
            self.movieTitle.text = "N/A"
        }
    }
    
    //Prevents reuse of images and text
    func resetCell() {
        self.movieImageView.image = nil
        self.movieTitle.text = ""
    }

}
