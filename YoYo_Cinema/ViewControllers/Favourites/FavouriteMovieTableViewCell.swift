//
//  FavouriteMovieTableViewCell.swift
//  YoYo_Cinema
//
//  Created by Nicolai Harbo on 17/05/2018.
//  Copyright © 2018 nicoware. All rights reserved.
//

import UIKit

@objc protocol FavouriteMovieTableViewCellDelegate: class {
    func removeFromFavourites(movie: Movie)
}

class FavouriteMovieTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    var movie: Movie? {
        didSet {
            updateInfo()
        }
    }
    var delegate: FavouriteMovieTableViewCellDelegate?
    
    //MARK: - IBOUtlets
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var removeFavouriteButton: UIButton!
    
    //MARK: - IBActions
    @IBAction func removeFavouriteButtonTapped(_ sender: Any) {
        print("removeFavouriteButtonTapped")
        self.delegate?.removeFromFavourites(movie: self.movie!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //MARK: - Functions
    func updateInfo() {
        if let imageUrl = movie?.poster_path {
            let url = URL(string: imageUrl)
            self.movieImageView.sd_setImage(with: url) { (image, error, cacheType, url) in
            }
        } else {
            //TODO: Set placeholder
        }
        if let title = movie?.title {
            self.titleLabel.text = title
        } else {
            self.titleLabel.text = "N/A"
        }
    }
    
    //Prevents reuse of images and text
    func resetCell() {
        self.movieImageView.image = nil
        self.titleLabel.text = ""
    }

}
