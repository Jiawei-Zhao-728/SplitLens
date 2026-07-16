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
    
    var grandTotal : Decimal {
        subtotal + taxAmount + tipAmount
    }
    
    
    
    func sharerNames(for item: ReceiptItem) -> String {
        let allPeopleIDs = Set(people.map(\.id))
        let sharerIDs = item.sharedBy.isEmpty ? allPeopleIDs : item.sharedBy
        
        if sharerIDs == allPeopleIDs {
            return "Everyone"
        }
        
        let names = people
            .filter { sharerIDs.contains($0.id) }
            .map(\.name)
        
        return names.isEmpty ? "Unassigned" : names.joined(separator: ", ")
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
    
    mutating func addPerson(named name: String) {
        guard !name.isEmpty else { return }
        people.append(Person(name: name))
    }
    
    mutating func removePeople(atOffsets offsets: IndexSet) {
        let removedIDs = Set(offsets.map { people[$0].id })
        
        for index in offsets.sorted(by: >) {
            people.remove(at: index)
        }
        
        for i in items.indices {
            items[i].sharedBy.subtract(removedIDs)
        }
    }
    
    mutating func removeItem(atOffset offsets: IndexSet) {
        for index in offsets.sorted(by: >) {
            items.remove(at: index)
        }
    }
    
    
    
}
