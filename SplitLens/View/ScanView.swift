//
//  ScanView.swift
//  SplitLens
//
//  Created by Jiawei Zhao on 7/24/26.
//

import SwiftUI
import PhotosUI

struct ScanView: View {
    @State private var pickedItem: PhotosPickerItem?
    @State private var items: [ReceiptItem] = []

    var body: some View {
        List {
            Section {
                PhotosPicker("选一张小票照片", selection: $pickedItem, matching: .images)
            }

            Section("识别结果") {
                if items.isEmpty {
                    Text("还没有识别结果，请先选一张照片")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(items) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text(item.price, format: .currency(code: "USD"))
                        }
                    }
                }
            }
        }
        .navigationTitle("扫描小票")
        .onChange(of: pickedItem) { _, newItem in
            Task {
                guard let newItem else {
                    items = []
                    return
                }

                guard let data = try? await newItem.loadTransferable(type: Data.self),
                      let image = UIImage(data: data) else {
                    items = []
                    return
                }

                let texts = await ReceiptScanner.recognize(in: image)
                items = ReceiptParser.parse(texts)
            }
        }
    }
}
