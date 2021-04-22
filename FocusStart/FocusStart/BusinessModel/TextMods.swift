//
//  TextMods.swift
//  FocusStart
//
//  Created by Ilya Salatyuk on 3/19/21.
//

import UIKit

struct TextMods: Codable {
    var fontName: String
    var size: CGFloat
    var isBold: Bool
    var isItalic: Bool
    var isUnderline: Bool
    var isStrikethrough: Bool
    
    static func toData(textMods: Self) -> Data? {
        guard let data = try? JSONEncoder().encode(textMods) else {
            return nil
        }
        
        return data
    }
    
    static func toTextMods(data: Data) -> Self? {
        guard let textMods = try? JSONDecoder().decode(Self.self, from: data) else {
            return nil
        }
        
        return textMods
    }
}
