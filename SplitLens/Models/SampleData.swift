//
//  SampleData.swift
//  SplitLens
//
//  Created by Jiawei Zhao on 7/6/26.
//

import Foundation


extension Bill {
    static var sample: Bill {
        let jackie = Person(name: "Jackie")
        let murfy = Person(name: "Murfy")
        let elena = Person(name: "Elena")

        return Bill(
            name: "Sip and Guzzle",
            people: [jackie, murfy, elena],
            items: [
                ReceiptItem(name: "Yuzu Mugirita", price: 22, category: .drink, sharedBy: [elena.id]),
                ReceiptItem(name: "Lychee Martini", price: 21, category: .drink, sharedBy: [murfy.id]),
                ReceiptItem(name: "Japanese Highball", price: 18, category: .drink, sharedBy: [jackie.id]),
                ReceiptItem(name: "Wagyu Old Fashioned", price: 23, category: .drink, sharedBy: [jackie.id]),
                ReceiptItem(name: "Truffle Fries", price: 14, category: .food, sharedBy: [jackie.id, murfy.id, elena.id]),
                ReceiptItem(name: "Chicken Karaage", price: 16, category: .food)
            ],
            taxAmount: Decimal(string: "7.46")!,
            tipPercentage: Decimal(string: "21.77")!
        )
    }
}
