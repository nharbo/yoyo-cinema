//
//  RealmManager.swift
//  YoYo_Cinema
//
//  Created by Nicolai Harbo on 16/05/2018.
//  Copyright © 2018 nicoware. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let sharedInstance = RealmManager()
    private init() { }
    
    //MARK: - Constants
    let realm = try! Realm()
    
    func isFavourite(movie: Movie) -> Bool {
        if (realm.object(ofType: RealmMovie.self, forPrimaryKey: movie.id!) != nil) {
            return true
        }
        return false
    }
    
    func addFavourite(movie: Movie, callback: (_ success: Bool) -> Void) {
        let realmMovie = RealmMovie()
        realmMovie.id = movie.id!
        realmMovie.title = movie.title
        if let poster_path = movie.poster_path { realmMovie.poster_path = poster_path }
        if let overview = movie.overview { realmMovie.overview = overview }
        if let release_date = movie.release_date { realmMovie.release_date = release_date }
        if let runtime = movie.runtime { realmMovie.runtime = runtime }
        if let tagline = movie.tagline { realmMovie.tagline = tagline }

        if let _ = movie.genres {
            let arr = List<RealmGenre>()
            for genre in movie.genres! {
                //Check if genre already exists in Realm
                
                //If yes, get the genre and add it to the array
                
                //If no, create it
                let realmGenre = RealmGenre()
                realmGenre.id = genre.id
                realmGenre.name = genre.name
                arr.append(realmGenre)
            }
            realmMovie.genres = arr
        }
        
        try! realm.write {
            realm.add(realmMovie)
            callback(true)
        }
    }
    
    func removeFavourite(movie: Movie, callback: (_ success: Bool) -> Void) {
        if let movieToRemove = realm.object(ofType: RealmMovie.self, forPrimaryKey: movie.id!) {
            print("User to remove: \(movieToRemove)")
            try! realm.write {
                realm.delete(movieToRemove)
                callback(true)
                print("Current user REMOVEd from Realm! (realm manager)")
            }
        } else {
            callback(false)
            print("could not remove user")
        }
    }
    
    func getFavourites() {
        
    }
    
    
}
