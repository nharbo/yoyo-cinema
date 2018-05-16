//
//  DetailsController.swift
//  YoYo_Cinema
//
//  Created by Nicolai Harbo on 16/05/2018.
//  Copyright © 2018 nicoware. All rights reserved.
//

import Foundation

class DetailsController {
    
    //MARK: - Constants
    let api = GetDetailsIntegration.sharedInstance
    
    //MARK: - Structs
    struct CallStatus {
        var success: Bool
        var movie: Movie?
        var error: String?
    }
    
    func getMovieDetails(movie: Movie, callback: @escaping (CallStatus) -> Void){
        api.getMovieDetails(movie: movie) { (response) in
            let response = CallStatus(success: response.success, movie: response.movie, error: response.error)
            callback(response)
        }
    }
    
}
