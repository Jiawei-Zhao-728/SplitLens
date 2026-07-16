//
//  PersonDetailView.swift
//  SplitLens
//
//  Created by Jiawei Zhao on 7/16/26.
//

import SwiftUI

struct PersonDetailView: View {
    let person: Person
    let bill: Bill
    
    var body: some View {
        List {
            Section("Total") {
                HStack {
                    Text("Amount owed")
                    Spacer()
                    Text(bill.total(for: person.id), format: .currency(code: "USD"))
                        .fontWeight(.semibold)
                }
            }
            
            Section("Items") {
                ForEach(bill.items) { item in
                    if let share = share(for: item) {
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text(share, format: .currency(code: "USD"))
                        }
                    }
                }
            }
        }
        .navigationTitle(person.name)
    }
    
    private func share(for item: ReceiptItem) -> Decimal? {
        let sharers = item.sharedBy.isEmpty
        ? Set(bill.people.map(\.id))
        : item.sharedBy
        
        guard sharers.contains(person.id) else { return nil }
        
        return item.price / Decimal(sharers.count)
    }
}
