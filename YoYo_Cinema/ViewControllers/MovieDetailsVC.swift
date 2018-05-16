//
//  MovieDetailsVC.swift
//  YoYo_Cinema
//
//  Created by Nicolai Harbo on 16/05/2018.
//  Copyright © 2018 nicoware. All rights reserved.
//

import UIKit
import SDWebImage
import ZOZolaZoomTransition

class MovieDetailsVC: UIViewController {
    
    //MARK: - Constants
    let controller = DetailsController()
    
    //MARK: - Variables
    var movie: Movie?
    
    //MARK: - IBOutlets
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = movie?.title!
        
        if let imageUrl = movie?.poster_path {
            let url = URL(string: imageUrl)
            self.backgroundImageView.sd_setImage(with: url) { (image, error, cacheType, url) in
            }
        }
        
        //Get details and set elements with the received data
        self.controller.getMovieDetails(movie: self.movie!) { (response) in
            if response.success {
                if let movie = response.movie {
                    if let releaseDate = movie.release_date { self.releaseDateLabel.text = "Released: \(releaseDate)" }
                    if let genres = movie.genres {
                        let string = genres.map {$0.name}.joined(separator: ", ")
                        self.genresLabel.text = "Genre(s): \(string)"
                    }
                    if let tagline = movie.tagline { self.taglineLabel.text = "'\(tagline)'" }
                    if let overview = movie.overview { self.overviewLabel.text = overview }
                } else {
                    //Set N/A
                }
            } else {
                if let error = response.error {
                    //TODO: Show error message - maybe dismiss view
                    print(error)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

