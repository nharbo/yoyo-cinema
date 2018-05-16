//
//  RealmGenre.swift
//  YoYo_Cinema
//
//  Created by Nicolai Harbo on 16/05/2018.
//  Copyright © 2018 nicoware. All rights reserved.
//

import Foundation
import RealmSwift

class RealmGenre: Object {
    
    @objc dynamic var id: NSNumber?
    @objc dynamic var name: String?
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
