//
//  GenrateQRCode.swift
// NewBase
//
//  Created by Mohamed Hadwa on 05/09/2024.
//

import UIKit
import CoreImage

class QRCodeGenerator {
    static func generateQRCode(from link: String) -> UIImage? {
        if let data = link.data(using: .utf8),
           let filter = CIFilter(name: "CIQRCodeGenerator") {
            
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("H", forKey: "inputCorrectionLevel") // Optional: You can set error correction level
            
            if let output = filter.outputImage {
                let context = CIContext()
                if let cgImage = context.createCGImage(output, from: output.extent) {
                    let qrCodeImage = UIImage(cgImage: cgImage)
                    return qrCodeImage
                }
            }
        }
        
        return nil
    }
}
