//
//  PDFHelper.swift
//  CheapEats
//
//  Created by Emre on 22.02.2025.
//

import UIKit
import PDFKit

class PDFHelper {
    static func createPdfFromView(view: UIView) -> NSMutableData? {
        let pdfData = NSMutableData()
        let originalBounds = view.bounds
        let contentSize = view.frame.size
        UIGraphicsBeginPDFContextToData(pdfData, CGRect(origin: .zero, size: contentSize), nil)
        var currentPageOffset: CGFloat = 0
        while currentPageOffset < contentSize.height {
            UIGraphicsBeginPDFPageWithInfo(CGRect(origin: .zero, size: contentSize), nil)
            view.bounds = CGRect(x: 0, y: currentPageOffset, width: view.bounds.width, height: view.bounds.height)
            if let pdfContext = UIGraphicsGetCurrentContext() {
                view.layer.render(in: pdfContext)
            } else {
                UIGraphicsEndPDFContext()
                return nil
            }
            currentPageOffset += view.bounds.height
        }
        UIGraphicsEndPDFContext()
        view.bounds = originalBounds
        
        return pdfData
    }
    
    static func savePdf(data: NSMutableData, fileName: String, completion: @escaping (URL?) -> Void) {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            data.write(to: fileURL, atomically: true)
            completion(fileURL)
        } else {
            completion(nil)
        }
    }
}
