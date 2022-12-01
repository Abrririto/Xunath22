//
//  AttributedStringGenerator.swift
//  Macro
//
//  Created by Paulo César on 03/10/22.
//

import Foundation
import SpriteKit

class AttributedStringGenerator {
    static let shared = AttributedStringGenerator()
    
    func createAttributedString(text: String) -> NSMutableAttributedString {
        let newString = NSMutableAttributedString(string: text)
        let attributions: [NSAttributedString.Key: Any] = [.font: NSFont(name: TypeFonts.alagard.rawValue, size: 30) ?? NSFont.labelFont(ofSize: 30),
                                                           .foregroundColor: NSColor.white,
                                                           .paragraphStyle: NSMutableParagraphStyle().alignment = .justified]
        let stringRange = NSMakeRange(0, newString.length)
        
        newString.beginEditing()
        newString.addAttributes(attributions, range: stringRange)
        newString.endEditing()
        
        return newString
    }
}

enum TypeFonts: String {
    case alagard = "Alagard"
    case arial = "Arial"
}
