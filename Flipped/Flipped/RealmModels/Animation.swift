//
//  Animation.swift
//  Flipped
//
//  Created by mc309 on 9/30/23.
//

import UIKit
import RealmSwift

class Animation: Object {
    @Persisted var id: String = UUID.init().uuidString
    @Persisted var title = ""
    @Persisted var createdAt = Date()
    
    @Persisted var selectedFrame: Frame? = nil
    
    override static func primaryKey() -> String? {
      return "id"
    }
}
