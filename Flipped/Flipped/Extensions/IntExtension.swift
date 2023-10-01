//
//  IntExtension.swift
//  Flipped
//
//  Created by mc309 on 9/30/23.
//

import UIKit

extension Int
{
    func toString() -> String
    {
        let myString = String(self)
        return myString
    }
    
    static func parse(from string: String) -> Int? {
        return Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
    
}
