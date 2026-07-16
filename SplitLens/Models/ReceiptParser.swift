//
//  ReceiptParser.swift
//  SplitLens
//
//  Created by Jiawei Zhao on 7/24/26.
//

import CoreGraphics
import Foundation

enum ReceiptParser {
    // 出现这些词的行不是菜品,过滤掉
    static let noiseKeywords = ["subtotal", "tax", "tip", "total", "visa",
                                "cash", "change", "balance", "auth", "approval", "guest", "check",
                                "card", "device", "payment", "application", "input", "transaction", "order"]

    /// 从 "$22.00" 这种字符串里抠出 22.00;不含价格返回 nil
    static func price(from string: String) -> Decimal? {
        // 匹配可选 $ 后面的数字.两位小数
        let pattern = #"\$?\s*(\d+\.\d{2})"#
        guard let match = string.range(of: pattern, options: .regularExpression) else {
            return nil
        }
        let cleaned = string[match]
            .replacingOccurrences(of: "$", with: "")
            .trimmingCharacters(in: .whitespaces)
        return Decimal(string: cleaned)
    }

    static func parse(_ texts: [RecognizedText]) -> [ReceiptItem] {
        var items: [ReceiptItem] = []

        // 1. 分成"价格块"和"名字块"
        let priceTexts = texts.filter { price(from: $0.string) != nil }
        let nameTexts = texts.filter { price(from: $0.string) == nil }

        // 2. 对每个价格,找同一行(midY 接近)、在它左边(midX 更小)的名字
        let rowTolerance: CGFloat = 0.02

        for priceText in priceTexts {
            let lower = priceText.string.lowercased()
            if noiseKeywords.contains(where: { lower.contains($0) }) { continue }

            guard let itemPrice = price(from: priceText.string) else { continue }

            let candidates = nameTexts.filter { name in
                abs(name.box.midY - priceText.box.midY) < rowTolerance
                    && name.box.midX < priceText.box.midX
            }

            guard let best = candidates.min(by: {
                abs($0.box.midY - priceText.box.midY) < abs($1.box.midY - priceText.box.midY)
            }) else { continue }

            let name = best.string.trimmingCharacters(in: .whitespaces)
            if noiseKeywords.contains(where: { name.lowercased().contains($0) }) { continue }

            items.append(ReceiptItem(name: name, price: itemPrice))
        }

        return items
    }
}
