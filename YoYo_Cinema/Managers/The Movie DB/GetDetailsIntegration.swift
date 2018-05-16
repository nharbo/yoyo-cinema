//
//  GetDetailsIntegration.swift
//  YoYo_Cinema
//
//  Created by Nicolai Harbo on 16/05/2018.
//  Copyright © 2018 nicoware. All rights reserved.
//

import Foundation
import Alamofire

class GetDetailsIntegration {
    
    //Make class a singleton - we only need 1 instance
    static let sharedInstance = GetDetailsIntegration()
    private init() { }
    
    //MARK: - Constants
    let dict = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "theMovieDB", ofType: "plist")!)
    
    //MARK: - Structs
    struct CallStatus {
        var success: Bool
        var movie: Movie?
        var error: String?
    }
    
    //For decoding JSON objects
    struct JsonObj: Decodable {
        var genres: [JsonGenres]?
        let release_date: String?
        let runtime: Int?
        let tagline: String?
    }
    
    struct JsonGenres: Decodable {
        let id: Int?
        let name: String?
    }
    
    
    //MARK: - API calls
    func getMovieDetails(movie: Movie, callback: @escaping (CallStatus) -> Void) {
        
        let urlString = Constants.BASE_API_URL + "movie/\(movie.id!)?api_key=" + self.getApiKey()
        
        Alamofire.request(urlString, method: .get)
            .responseJSON { response in
                
                //Check if there's data
                guard let data = response.data as? Data else {
                    let response = CallStatus(success: false, movie: nil, error: "Error: No data to decode")
                    callback(response)
                    return
                }
                
                //Check if data decodes
                guard let general = try? JSONDecoder().decode(JsonObj.self, from: data) else {
                    let response = CallStatus(success: false, movie: nil, error: "Error: Couldn't decode data into MoviesDetails")
                    callback(response)
                    return
                }
                
                //Add result to movieobject
                if let release_date = general.release_date { movie.release_date = release_date }
                if let runtime = general.runtime { movie.runtime = runtime }
                if let tagline = general.tagline { movie.tagline = tagline }
                
                if let genres = general.genres {
                    var arr = [Genre]()
                    for genre in genres {
                        let genre = Genre(id: genre.id!, name: genre.name!)
                        arr.append(genre)
                    }
                    movie.genres = arr
                }
                
                
                let response = CallStatus(success: true, movie: movie, error: nil)
                callback(response)
        }
    }
    
    //MARK: - Helper methods
    func getApiKey() -> String {
        return (dict?.object(forKey: "apiKey") as? String)!
    }
    
    
}
