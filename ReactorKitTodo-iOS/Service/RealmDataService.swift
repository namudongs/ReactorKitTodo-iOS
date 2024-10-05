//
//  RealmDataService.swift
//  ReactorKitTodo-iOS
//
//  Created by namdghyun on 10/4/24.
//

import Foundation
import RealmSwift

class RealmDataService {
    private let realm: Realm
    
    init() {
        realm = try! Realm()
    }
    
    // Create
    func create(todo: Todo) {
        let realmTodo = RealmTodo()
        realmTodo.id = todo.id
        realmTodo.title = todo.title
        realmTodo.isCompleted = todo.isCompleted
        
        try! realm.write {
            realm.add(realmTodo, update: .modified)
        }
    }
    
    // Read
    func getAllTodos() -> [Todo] {
        let realmTodos = realm.objects(RealmTodo.self)
        return realmTodos.map { Todo(id: $0.id, title: $0.title, isCompleted: $0.isCompleted) }
    }
    
    func getTodo(byId id: Int) -> Todo? {
        guard let realmTodo = realm.object(ofType: RealmTodo.self, forPrimaryKey: id) else {
            return nil
        }
        return Todo(id: realmTodo.id, title: realmTodo.title, isCompleted: realmTodo.isCompleted)
    }
    
    // Update
    func update(todo: Todo) {
        guard let realmTodo = realm.object(ofType: RealmTodo.self, forPrimaryKey: todo.id) else {
            return
        }
        
        try! realm.write {
            realmTodo.title = todo.title
            realmTodo.isCompleted = todo.isCompleted
        }
    }
    
    // Delete
    func delete(todo: Todo) {
        guard let realmTodo = realm.object(ofType: RealmTodo.self, forPrimaryKey: todo.id) else {
            return
        }
        
        try! realm.write {
            realm.delete(realmTodo)
        }
    }
    
    // Delete All
    func deleteAllTodos() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}
