//
//  ItemCategory.swift
//  SplitLens
//
//  Created by Jiawei Zhao on 7/6/26.
//

import Foundation

enum ItemCategory: String, CaseIterable, Identifiable {
    case food = "Food"
    case drink = "Drink"
    
    var id: String { rawValue }
}
