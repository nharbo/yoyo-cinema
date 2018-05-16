//
//  RealmMovie.swift
//  YoYo_Cinema
//
//  Created by Nicolai Harbo on 16/05/2018.
//  Copyright © 2018 nicoware. All rights reserved.
//

import Foundation
import RealmSwift

class RealmMovie: Object {
    
    @objc dynamic var id: NSNumber?
    @objc dynamic var title: String?
    @objc dynamic var poster_path: String?
    @objc dynamic var overview: String?
    @objc dynamic var genres: [RealmGenre]?
    @objc dynamic var release_date: String?
    @objc dynamic var runtime: NSNumber?
    @objc dynamic var tagline: String?
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
