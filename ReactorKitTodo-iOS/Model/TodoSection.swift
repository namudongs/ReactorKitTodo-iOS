//
//  TodoSection.swift
//  ReactorKitTodo-iOS
//
//  Created by namdghyun on 10/4/24.
//

import RxDataSources

struct TodoSection {
    var items: [Todo]
}

extension TodoSection: SectionModelType {
    init(original: TodoSection, items: [Todo]) {
        self = original
        self.items = items
    }
}
