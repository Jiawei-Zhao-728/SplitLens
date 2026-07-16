//
//  showingItemView.swift
//  SplitLens
//
//  Created by Jiawei Zhao on 7/23/26.
//

import SwiftUI

struct AddItemView: View {
    let people: [Person]
    let onAdd: (ReceiptItem) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var price: Decimal?
    @State private var everyone = true
    @State private var sharedBy: Set<UUID> = []
    
    private var allPeopleIDs: Set<UUID> {
        Set(people.map(\.id))
    }
    
    private var isSharedByValid: Bool {
        if everyone { return true }
        return !sharedBy.isEmpty && sharedBy != allPeopleIDs
    }
    
    private var canSave: Bool {
        !name.isEmpty && price != nil && isSharedByValid
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Item") {
                    TextField("Name", text: $name)
                    TextField("Price", value: $price, format: .currency(code: "USD"))
                        .keyboardType(.decimalPad)
                }
                
                Section("Shared by") {
                    Toggle("Everyone", isOn: $everyone)
                        .disabled(people.count <= 1)
                        .onChange(of: everyone) { _, isEveryone in
                            if isEveryone {
                                sharedBy = []
                            }
                        }
                    
                    if !everyone {
                        ForEach(people) { person in
                            HStack {
                                Text(person.name)
                                Spacer()
                                if sharedBy.contains(person.id) {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.blue)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                togglePerson(person.id)
                            }
                        }
                        
                        Text("Pick at least one person, but not everyone.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard let price else { return }
                        
                        let item = ReceiptItem(
                            name: name,
                            price: price,
                            sharedBy: everyone ? [] : sharedBy
                        )
                        onAdd(item)
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
    
    private func togglePerson(_ personID: UUID) {
        if sharedBy.contains(personID) {
            sharedBy.remove(personID)
        } else if sharedBy.count + 1 < people.count {
            sharedBy.insert(personID)
        }
    }
}
