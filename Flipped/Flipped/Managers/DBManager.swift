//
//  DBManager.swift
//  Flipped
//
//  Created by mc309 on 9/30/23.
//

import UIKit
import RealmSwift

class DBManager: NSObject {

    static let SI = DBManager()
    var realm: Realm!
    
    override init() {
        super.init()
    }
    
    func initialize() {
        let realmConfig = Realm.Configuration(schemaVersion: 1,
                                              migrationBlock: { (migration, oldSchemeVersion) in
                switch oldSchemeVersion {
                case 0:
                    break
                default:
                    break
                }
        }, deleteRealmIfMigrationNeeded: true)
        do {
            realm = try Realm(configuration: realmConfig)
        } catch {
            print(error)
        }
    }
}

extension Results {
    func toArray() -> [Element] {
      return compactMap {
        $0
      }
    }
 }

