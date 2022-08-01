//
//  Item.swift
//  RealmClear
//
//  Created by Joe Vargas on 8/1/22.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
