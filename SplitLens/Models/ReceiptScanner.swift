//
//  ReceiptScanner.swift
//  SplitLens
//
//  Created by Jiawei Zhao on 7/24/26.
//

import Vision
import UIKit

struct RecognizedText {
    let string: String
    let box: CGRect        // 归一化坐标,原点在左下角,y 越大越靠上
}

enum ReceiptScanner {
    static func recognize(in image: UIImage) async -> [RecognizedText] {
        guard let cgImage = image.cgImage else { return [] }

        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
            let observations = request.results ?? []
            return observations.compactMap { obs in
                guard let text = obs.topCandidates(1).first?.string else { return nil }
                return RecognizedText(string: text, box: obs.boundingBox)
            }
        } catch {
            print("OCR failed: \(error)")
            return []
        }
    }
}
