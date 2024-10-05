//
//  Todo.swift
//  ReactorKitTodo-iOS
//
//  Created by namdghyun on 10/4/24.
//

import Foundation
import RealmSwift

struct Todo: Identifiable, Equatable {
    let id: Int
    let title: String
    let isCompleted: Bool
    
    var identity: Int {
        return id
    }
}

class RealmTodo: Object {
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var isCompleted = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
