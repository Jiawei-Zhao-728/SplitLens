//
//  ReceiptItem.swift
//  SplitLens
//
//  Created by Jiawei Zhao on 7/6/26.
//

import Foundation

struct ReceiptItem: Identifiable {
    let id: UUID
    var name: String
    var price: Decimal
    var sharedBy: Set<UUID>
    var category: ItemCategory
    
    init(id: UUID = UUID(), name: String, price: Decimal, category: ItemCategory = .food, sharedBy: Set<UUID> = []) {
        self.id = id
        self.name = name
        self.price = price
        self.sharedBy = sharedBy
        self.category = category
        

    }
    
    
}

