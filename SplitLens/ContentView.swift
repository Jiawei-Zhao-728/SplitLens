//
//  ContentView.swift
//  SplitLens
//
//  Created by Jiawei Zhao on 7/6/26.
//

import SwiftUI

struct ContentView: View {
    @State private var bill = Bill.sample
    @State private var newPersonName = ""
    @State private var showingAdditem = false
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    ScanView()
                } label: {
                    Label("扫描小票", systemImage: "doc.text.viewfinder")
                }
                
                Section("People") {
                    ForEach(bill.people) { person in
                        NavigationLink {
                            PersonDetailView(person: person, bill: bill)
                        } label: {
                            
                            Text(person.name)
                            
                            
                        }
                        
                    }
                    .onDelete { indexSet in
                        bill.removePeople(atOffsets: indexSet)
                    }
                }
                
                Section("Add a person") {
                    HStack {
                        TextField("Name", text: $newPersonName)
                        Button("Add") {
                            bill.addPerson(named: newPersonName)
                            newPersonName = ""
                        }
                        .disabled(newPersonName.isEmpty)
                    }
                }
                
                Section("Items") {
                    ForEach($bill.items) { $item in
                        NavigationLink {
                            ItemDetailView(item: $item, people: bill.people)
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                    Text(bill.sharerNames(for: item))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(item.price, format: .currency(code: "USD"))
                            }
                        }
                        
                    }.onDelete{bill.removeItem(atOffset: $0)}
                    
                    Button {
                        showingAdditem = true
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                
                
                Section("Summary") {
                    HStack {
                        Text("Subtotal")
                        Spacer()
                        Text(bill.subtotal, format: .currency(code: "USD"))
                    }
                    HStack {
                        Text("Tax")
                        Spacer()
                        Text(bill.taxAmount, format: .currency(code: "USD"))
                    }
                    HStack {
                        Text("Tip (\(bill.tipPercentage, format: .number.precision(.fractionLength(0...2)))%)")
                        Spacer()
                        Text(bill.tipAmount, format: .currency(code: "USD"))
                    }
                    HStack {
                        Text("Total")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(bill.grandTotal, format: .currency(code: "USD"))
                            .fontWeight(.semibold)
                    }
                }
                
                Section("Bill") {
                    ForEach(bill.people) { person in
                        HStack {
                            Text(person.name)
                            Spacer()
                            Text(bill.total(for: person.id), format: .currency(code: "USD"))
                        }
                    }
                }
            }
            .navigationTitle(bill.name)
            .sheet(isPresented: $showingAdditem) {
                AddItemView (people: bill.people) { newItem in
                    bill.items.append(newItem)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
