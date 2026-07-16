//
//  ItemDetailView.swift
//  SplitLens
//
//  Created by Jiawei Zhao on 7/16/26.
//

import SwiftUI


struct ItemDetailView: View {
    @Binding var item: ReceiptItem
    let people: [Person]
    
    var body: some View {
        List {
            Section ("Shared by") {
                ForEach(people) { person in
                    HStack {
                        Text(person.name)
                        Spacer()
                        if item.sharedBy.isEmpty || item.sharedBy.contains(person.id) {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        item.toggleSharer(person.id, among: Set(people.map(\.id)))
                    }
                }
            }
        }
        .navigationTitle(item.name)
    }
}
