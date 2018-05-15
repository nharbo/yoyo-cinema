//
//  MovieAPIManager.swift
//  YoYo_Cinema
//
//  Created by Nicolai Harbo on 15/05/2018.
//  Copyright © 2018 nicoware. All rights reserved.
//

import Foundation
import Alamofire

class MovieAPIManager {
    
    //Make class a singleton - we only need 1 instance
    static let sharedInstance = MovieAPIManager()
    private init() { }
    
    //MARK: - Constants
    let baseUrl = "https://api.themoviedb.org/3/search/movie?api_key="
    
    //MARK: - Structs
    struct CallStatus {
        var success: Bool
        var movies: [Movie]?
        var error: String?
    }
    
    //For decoding JSON objects
    struct JsonObj: Decodable {
        let page: Int
        let total_results: Int
        let total_pages: Int
        let results: [JsonMovie]
    }
    
    struct JsonMovie: Decodable {
        let id: Int?
        let title: String?
        let poster_path: String?
        let overview: String?
    }
    
    //MARK: Api calls (GET)
    
    //Get movies from keywords. Atm. it only gets the first page (20 elements)
    func getMoviesFromSearch(query: String, callback: @escaping (CallStatus) -> Void){
        
        var queryUrlFriendly = query.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        var urlString = getUrlWithKey() + "&query=\(queryUrlFriendly!)"
        
        print(urlString)

        Alamofire.request(urlString, method: .get)
            .responseJSON { response in
                
                guard let data = response.data as? Data else {
                    let response = CallStatus(success: false, movies: nil, error: "Error: No data to decode")
                    callback(response)
                    return
                }
                
                guard let general = try? JSONDecoder().decode(JsonObj.self, from: data) else {
                    let response = CallStatus(success: false, movies: nil, error: "Error: Couldn't decode data into Movies")
                    callback(response)
                    return
                }
                
                //Map returned movies to Movie-objects
                var movieArray = [Movie]()
                for singleMovie in general.results {
                    let movie = Movie()

                    if let id = singleMovie.id as? Int { movie.id = id}
                    if let title = singleMovie.title as? String { movie.title = title}
                    if let poster_path = singleMovie.poster_path as? String { movie.poster_path = "https://image.tmdb.org/t/p/w500\(poster_path)"}
                    if let overview = singleMovie.overview as? String { movie.overview = overview}

                    movieArray.append(movie)
                }
                
                let response = CallStatus(success: true, movies: movieArray, error: nil)
                callback(response)
        }
        
    }
    
    //MARK: - Helper methods
    func getUrlWithKey() -> String {
        let apiKey = "4cb1eeab94f45affe2536f2c684a5c9e"
        return baseUrl + apiKey
    }
    
    
}
