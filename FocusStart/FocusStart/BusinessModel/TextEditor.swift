//
//  TextEditor.swift
//  FocusStart
//
//  Created by Ilya Salatyuk on 3/18/21.
//

import UIKit

class TextEditor {
    
    static func changeSize(to attributedString: NSAttributedString,
                           for range: NSRange, size: CGFloat) -> NSMutableAttributedString {
        let mutableString = NSMutableAttributedString(attributedString: attributedString)
        guard let font = getFont(attributedString: attributedString, for: range) else {
            return mutableString
        }
        mutableString.addAttribute(.font, value: font.withSize(size), range: range)
        return mutableString
    }
    
    static func switchUnderline(to attributedString: NSAttributedString,
                                for range: NSRange) -> NSMutableAttributedString {
        let mutableString = NSMutableAttributedString(attributedString: attributedString)
        let allAttributes = getAllAttributes(to: attributedString, for: range)
        if allAttributes[NSAttributedString.Key.underlineStyle] != nil {
            mutableString.removeAttribute(.underlineStyle, range: range)
        } else {
            mutableString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        }
        return mutableString
    }
    
    static func switchStrikethrough(to attributedString: NSAttributedString,
                                    for range: NSRange) -> NSMutableAttributedString {
        let mutableString = NSMutableAttributedString(attributedString: attributedString)
        let allAttributes = getAllAttributes(to: attributedString, for: range)
        if allAttributes[NSAttributedString.Key.strikethroughStyle] != nil {
            mutableString.removeAttribute(.strikethroughStyle, range: range)
        } else {
            mutableString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        }
        return mutableString
    }
    
    static func switchSymbolicTraits(to attributedString: NSAttributedString,
                                     for range: NSRange,
                                     symbolicTraits: [UIFontDescriptor.SymbolicTraits],
                                     currentFont: UIFont?) -> NSMutableAttributedString {
        let mutableString = NSMutableAttributedString(attributedString: attributedString)
        guard let font = currentFont ?? getFont(attributedString: attributedString, for: range) else {
            return mutableString
        }
        let updatedFont = switchTraits(font: font, symbolicTraits: symbolicTraits)
        mutableString.addAttribute(.font, value: updatedFont, range: range)
        return mutableString
    }
    
    static func switchAttributes(to attributes: [NSAttributedString.Key: Any],
                                 symbolicTraits: [UIFontDescriptor.SymbolicTraits]) -> [NSAttributedString.Key: Any] {
        var newAttributes = attributes
        guard let font = attributes[.font] as? UIFont else {
            return attributes
        }
        newAttributes.updateValue(switchTraits(font: font, symbolicTraits: symbolicTraits), forKey: .font)
        return newAttributes
    }
    
    static func switchUnderline(to attributes: [NSAttributedString.Key: Any]) -> [NSAttributedString.Key: Any] {
        var newAttributes = attributes
        if newAttributes[.underlineStyle] != nil {
            newAttributes[.underlineStyle] = nil
        } else {
            newAttributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        return newAttributes
    }
    
    static func switchStrikethrough(to attributes: [NSAttributedString.Key: Any]) -> [NSAttributedString.Key: Any] {
        var newAttributes = attributes
        if newAttributes[.strikethroughStyle] != nil {
            newAttributes[.strikethroughStyle] = nil
        } else {
            newAttributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        }
        return newAttributes
    }

    static func changeSize(to attributes: [NSAttributedString.Key: Any],
                           size: CGFloat) -> [NSAttributedString.Key: Any] {
        var newAttributes = attributes
        guard let font = attributes[.font] as? UIFont else {
            return attributes
        }
        newAttributes.updateValue(font.withSize(size), forKey: .font)
        return newAttributes
    }
    
    private static func isSymbolicsTrait(font: UIFont, symbolicsTrait: UIFontDescriptor.SymbolicTraits) -> Bool {
        if font.fontDescriptor.symbolicTraits.contains(symbolicsTrait) {
            return true
        } else {
            return false
        }
    }

    private static func switchTraits(font: UIFont, symbolicTraits: [UIFontDescriptor.SymbolicTraits]) -> UIFont {
        var updatedDescriptor: UIFontDescriptor?
        let size = font.pointSize
        var currentSymbolicTraits = font.fontDescriptor.symbolicTraits
        for element in symbolicTraits {
            if isSymbolicsTrait(font: font, symbolicsTrait: element) {
                for element in symbolicTraits {
                    currentSymbolicTraits.remove(element)
                }
                updatedDescriptor = font.fontDescriptor.withSymbolicTraits(currentSymbolicTraits)
            } else {
                currentSymbolicTraits.insert(element)
                updatedDescriptor = font.fontDescriptor.withSymbolicTraits(currentSymbolicTraits)
            }
        }
        let newFont = UIFont(descriptor: updatedDescriptor ?? font.fontDescriptor, size: size)
        return newFont
    }
    
    static func getFont(attributedString: NSAttributedString, for range: NSRange) -> UIFont? {
        if range.length == 0 {
            return nil
        }
        
        let allAttributes = getAllAttributes(to: attributedString, for: range)
        let fontRawValue = NSAttributedString.Key.font.rawValue
        guard let font = allAttributes[NSAttributedString.Key(rawValue: fontRawValue)] as? UIFont else {
            return nil
        }
        return font
    }

    static func getAllAttributes(to attributedString: NSAttributedString,
                                         for range: NSRange) -> [NSAttributedString.Key: Any] {
        let attrSubstring = attributedString.attributedSubstring(from: range)
        return attrSubstring.attributes(at: 0, effectiveRange: nil)
    }
}
