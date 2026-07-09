//
//  Bill.swift
//  SplitLens
//
//  Created by Jiawei Zhao on 7/6/26.
//

import Foundation

struct Bill: Identifiable {
    
    let id: UUID
    var name: String
    var people: [Person]
    var items: [ReceiptItem]
    var taxAmount: Decimal
    var tipPercentage: Decimal
    
    init(id: UUID = UUID(), name: String = "", people: [Person] = [], items: [ReceiptItem] = [], taxAmount: Decimal = 0, tipPercentage: Decimal = 0) {
        self.id = id
        self.name = name
        self.people = people
        self.items = items
        self.taxAmount = taxAmount
        self.tipPercentage = tipPercentage
    }

}

extension Bill{
    
//    sum of all item prices before tax and tip:
    var subtotal: Decimal {
        items.reduce(0) {
            sum, item in sum + item.price
        }
    }
    
    var tipAmount: Decimal {
        subtotal * tipPercentage / 100
    }
    
    func itemsTotal(for personID: UUID) -> Decimal{
        var total: Decimal = 0
        
        for item in items {

            let sharers = item.sharedBy.isEmpty
            ? Set(people.map(\.id))
            : item.sharedBy
            
            if sharers.contains(personID) {
                let share = item.price / Decimal(sharers.count)
                total += share
            }
                    
        }
        
        return total
    }
    
    func total (for personID: UUID) -> Decimal {
//        1. this person's itemsTotal
            let foodTotal = itemsTotal(for:personID)
//        2. if subtotal is 0. return 0 (empty bill - avoid dividing by zero)
            guard subtotal > 0 else {return 0}
//        3. propoortion = their itemTotal / subtotal
            let proportion = foodTotal / subtotal
//        4. return itemsTotal + proportion * (taxAmount + tipAmount)
            return foodTotal + proportion * (taxAmount + tipAmount)
    }
    
     
    
}
