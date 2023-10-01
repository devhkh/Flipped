//
//  Frame.swift
//  Flipped
//
//  Created by mc309 on 9/30/23.
//

import UIKit
import RealmSwift

class Frame: Object {
    @Persisted var id: String = UUID.init().uuidString
    
    @Persisted var animationId: String = ""
    @Persisted var data: Data = Data()
    @Persisted var createdAt = Date()
    
    override static func primaryKey() -> String? {
      return "id"
    }
}
