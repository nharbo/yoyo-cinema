//
//  SearchController.swift
//  YoYo_Cinema
//
//  Created by Nicolai Harbo on 15/05/2018.
//  Copyright © 2018 nicoware. All rights reserved.
//

import Foundation

class SearchController {
    
    //MARK: - Constants
    let api = SearchMoviesIntegration.sharedInstance
    
    //MARK: - Structs
    struct CallStatus {
        var success: Bool
        var movies: [Movie]?
        var error: String?
    }
    
    func getMoviesFromSearch(query: String, callback: @escaping (CallStatus) -> Void){
        api.getMoviesFromSearch(query: query) { (response) in
            let response = CallStatus(success: response.success, movies: response.movies, error: response.error)
            callback(response)
        }
    }
    
}
