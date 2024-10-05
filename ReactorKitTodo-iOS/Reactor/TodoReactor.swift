//
//  TodoReactor.swift
//  ReactorKitTodo-iOS
//
//  Created by namdghyun on 10/4/24.
//

import UIKit
import ReactorKit

class TodoReactor: Reactor {
    // MARK: - Properties
    var initialState = State()
    private let dataService: RealmDataService
    
    // MARK: - Initialization
    init(dataService: RealmDataService) {
        self.dataService = dataService
    }
    
    // MARK: - Enums
    enum Action {
        case add(Todo)
        case remove(Todo)
        case loadTodos
    }
    
    enum Mutation {
        case addTodo(Todo)
        case removeTodo(Todo)
        case setTodos([Todo])
    }
    
    struct State {
        var todos: [Todo] = []
    }
    
    // MARK: - Methods
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .add(todo):
            dataService.create(todo: todo)
            return Observable.just(.addTodo(todo))
        case let .remove(todo):
            dataService.delete(todo: todo)
            return Observable.just(.removeTodo(todo))
        case .loadTodos:
            let todos = dataService.getAllTodos()
            return Observable.just(.setTodos(todos))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .addTodo(todo):
            newState.todos.append(todo)
        case let .removeTodo(todo):
            newState.todos.removeAll { $0.id == todo.id }
        case let .setTodos(todos):
            newState.todos = todos
        }
        return newState
    }
}
