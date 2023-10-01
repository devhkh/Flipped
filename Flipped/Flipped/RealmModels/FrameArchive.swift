//
//  FrameArchive.swift
//  Flipped
//
//  Created by mc309 on 9/30/23.
//

import UIKit
import RealmSwift

class FrameArchive: Object {
    @Persisted var id: String = UUID.init().uuidString
    
    @Persisted var frameId: String = ""
    @Persisted var createdAt = Date()
    @Persisted var jsonData: String = ""
 
    override static func primaryKey() -> String? {
      return "id"
    }
}
