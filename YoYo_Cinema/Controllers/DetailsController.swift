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
    let realm = RealmManager.sharedInstance
    
    //MARK: - Structs
    struct CallStatus {
        var success: Bool
        var movie: Movie?
        var error: String?
    }
    
    //MARK: - API calls
    func getMovieDetails(movie: Movie, callback: @escaping (CallStatus) -> Void){
        api.getMovieDetails(movie: movie) { (response) in
            let response = CallStatus(success: response.success, movie: response.movie, error: response.error)
            callback(response)
        }
    }
    
    //MARK: - Realm calles
    func isMovieAFavourite(movie: Movie) -> Bool {
        if realm.isFavourite(movie: movie) {
            return true
        } else {
            return false
        }
    }
    
    func addFavourite(movie: Movie, callback: (_ success: Bool) -> Void) {
        realm.addFavourite(movie: movie) { (success) in
            if success {
                callback(true)
            }
        }
    }
    
    func removeFavourite(movie: Movie, callback: (_ success: Bool) -> Void) {
        realm.removeFavourite(movie: movie) { (success) in
            if success {
                callback(true)
            }
        }
    }
    
}
