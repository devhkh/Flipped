//
//  Line.swift
//  Flipped
//
//  Created by mc309 on 9/30/23.
//

import UIKit
import RealmSwift

class Line: Object {
    @Persisted var id: String = UUID.init().uuidString
    
    @Persisted var frameId: String = ""
    @Persisted var createdAt = Date()
 
    override static func primaryKey() -> String? {
      return "id"
    }
}
