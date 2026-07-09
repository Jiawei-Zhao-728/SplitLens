//
//  Person.swift
//  SplitLens
//
//  Created by Jiawei Zhao on 7/6/26.
//

import Foundation

struct Person: Identifiable {
    let id: UUID
    var name: String
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}
