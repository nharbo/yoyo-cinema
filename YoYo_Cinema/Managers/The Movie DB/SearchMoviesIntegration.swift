//
//  MovieAPIManager.swift
//  YoYo_Cinema
//
//  Created by Nicolai Harbo on 15/05/2018.
//  Copyright © 2018 nicoware. All rights reserved.
//

import Foundation
import Alamofire

class SearchMoviesIntegration {
    
    //Make class a singleton - we only need 1 instance
    static let sharedInstance = SearchMoviesIntegration()
    private init() { }
    
    //MARK: - Constants
    let dict = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "theMovieDB", ofType: "plist")!)
    
    //MARK: - Variables
    private var _latestSearchResults: [Movie]!
    var latestSearchResults: [Movie]? {
        get {
            return _latestSearchResults
        }
        set {
            _latestSearchResults = newValue
        }
    }
    
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
        
        let queryUrlFriendly = query.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        let urlString = Constants.BASE_API_URL + "search/movie?api_key=" + self.getApiKey() + "&query=\(queryUrlFriendly!)"

        Alamofire.request(urlString, method: .get)
            .responseJSON { response in
                
                //Check if there's data
                guard let data = response.data as? Data else {
                    let response = CallStatus(success: false, movies: nil, error: "Error: No data to decode")
                    callback(response)
                    return
                }
                
                //Check if data decodes
                guard let general = try? JSONDecoder().decode(JsonObj.self, from: data) else {
                    let response = CallStatus(success: false, movies: nil, error: "Error: Couldn't decode data into Movies")
                    callback(response)
                    return
                }
                
                //Map returned movies to Movie-objects
                var movieArray = [Movie]()
                for singleMovie in general.results {
                    let movie = Movie()

                    if let id = singleMovie.id { movie.id = id}
                    if let title = singleMovie.title { movie.title = title}
                    if let poster_path = singleMovie.poster_path { movie.poster_path = "https://image.tmdb.org/t/p/w500\(poster_path)"}
                    if let overview = singleMovie.overview { movie.overview = overview}

                    movieArray.append(movie)
                }
                
                self.latestSearchResults = movieArray
                let response = CallStatus(success: true, movies: movieArray, error: nil)
                callback(response)
        }
    }
    
    
    //MARK: - Helper methods
    func getApiKey() -> String {
        return (dict?.object(forKey: "apiKey") as? String)!
    }
    
    
}
