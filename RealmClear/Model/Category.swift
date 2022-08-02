//
//  Category.swift
//  RealmClear
//
//  Created by Joe Vargas on 8/1/22.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
