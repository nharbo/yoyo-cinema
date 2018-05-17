//
//  FavouritesController.swift
//  YoYo_Cinema
//
//  Created by Nicolai Harbo on 17/05/2018.
//  Copyright © 2018 nicoware. All rights reserved.
//

import Foundation

class FavouritesController {
    
    //MARK: - Constants
    let realm = RealmManager.sharedInstance
    
    //MARK: - Realm calls
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
    
    func getFavourites(callback: (_ realmMovies: [Movie]) -> Void) {
        realm.getFavourites { (result) in
            callback(result)
        }
    }
    
    
}
