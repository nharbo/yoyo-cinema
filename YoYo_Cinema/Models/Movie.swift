//
//  Movie.swift
//  YoYo_Cinema
//
//  Created by Nicolai Harbo on 15/05/2018.
//  Copyright © 2018 nicoware. All rights reserved.
//

import Foundation

class Movie: NSObject {
    
    var id: Int?
    var title: String?
    var poster_path: String?
    var overview: String?
    var genres: [Genre]?
    var release_date: String?
    var runtime: Int?
    var tagline: String?

}


