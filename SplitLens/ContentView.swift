//
//  ContentView.swift
//  SplitLens
//
//  Created by Jiawei Zhao on 7/6/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        List {
            Section("People") {
                    ForEach(Bill.sample.people) { person in
                        // you: show the person's name
                        Text(person.name)
                    }
                }
                Section("Items") {
                    ForEach(Bill.sample.items) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            // you: the price, currency-formatted
                            Text(item.price, format: .currency(code: "USD"))
                        }
                    }
                }
        }
            }
}

#Preview {
    ContentView()
}
