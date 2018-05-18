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
    var isFavourite: Bool? {
        didSet {
            if self.isFavourite! {
                self.isFavouriteLabel.text = "Favourite"
            } else {
                self.isFavouriteLabel.text = ""
            }
        }
    }
    
    //MARK: IBOutlets
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var isFavouriteLabel: UILabel!
    @IBOutlet weak var tintView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tintView.layer.cornerRadius = 16.0
        tintView.clipsToBounds = true
        movieImageView.layer.cornerRadius = 16.0
        movieImageView.clipsToBounds = true
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
            //Only set title, if no image
            if let title = movie?.title {
                self.movieTitle.text = title
            } else {
                self.movieTitle.text = "N/A"
            }
        }
    }
    
    //Prevents reuse of images and text
    func resetCell() {
        self.movieImageView.image = nil
        self.isFavouriteLabel.text = ""
    }

}
