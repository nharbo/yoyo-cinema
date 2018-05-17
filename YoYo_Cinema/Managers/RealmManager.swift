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
                let realmGenre = RealmGenre()
                realmGenre.id = genre.id
                realmGenre.name = genre.name
                arr.append(realmGenre)
            }
            realmMovie.genres = arr
        }
        
        try! realm.write {
            realm.add(realmMovie, update: true) //Update allows realmGenres with the same id as primary key
            callback(true)
        }
    }
    
    func removeFavourite(movie: Movie, callback: (_ success: Bool) -> Void) {
        if let movieToRemove = realm.object(ofType: RealmMovie.self, forPrimaryKey: movie.id!) {
            try! realm.write {
                realm.delete(movieToRemove)
                callback(true)
            }
        } else {
            callback(false)
        }
    }
    
    func getFavourites(callback: (_ movies: [Movie]) -> Void) {
        let favourites = realm.objects(RealmMovie.self) //Returns Results<RealmMovie> - convert to regular array of Movie
        var arr = [Movie]()
        for favourite in favourites {
            let movie = Movie()
            movie.id = favourite.id
            movie.title = favourite.title
            if let poster_path = favourite.poster_path { movie.poster_path = poster_path }
            if let overview = favourite.overview { movie.overview = overview }
            if let release_date = favourite.release_date { movie.release_date = release_date }
            movie.runtime = favourite.runtime
            if let tagline = favourite.tagline { movie.tagline = tagline }
            
            var genreArr = [Genre]()
            for genre in favourite.genres {
                let genre = Genre(id: genre.id, name: genre.name!)
                genreArr.append(genre)
            }
            movie.genres = genreArr
            
            arr.append(movie)
            
        }
        callback(arr)
    }
    
    
}
