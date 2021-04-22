//
//  NoteViewController.swift
//  FocusStart
//
//  Created by Ilya Salatyuk on 3/18/21.
//

import UIKit

class NoteViewController: UIViewController, Storyboarded {
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Note", bundle: nil)
        // swiftlint:disable force_cast
        return storyboard.instantiateInitialViewController() as! Self
        // swiftlint:enable force_cast
    }

    var note: Note?
    
    @IBOutlet var textView: UITextView!
    var fontView: FontView!
    var currentAttributes = [TypeFont]()
    var lastRange: NSRange!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Edit"
        configureToolBar()
        configureFontView()
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.allowsEditingTextAttributes = true
        
        guard let note = note else {
            fontView.setupFont(fontName: textView.font!.fontName)
            fontView.setupFontSize(with: textView.font!.pointSize)
            return
        }
        textView.text = note.text
        textView.attributedText = note.attributedText
        guard let data = note.textMods, let textMods = TextMods.toTextMods(data: data) else {
            return
        }
        fontView.setupFont(fontName: textMods.fontName)
        let attributes = textView.typingAttributes
        if let font = attributes[.font] as? UIFont {
            var traits = font.fontDescriptor.symbolicTraits
            if textMods.isBold == true {
                traits.insert(.traitBold)
            }
            if textMods.isItalic == true {
                traits.insert(.traitItalic)
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if textView.text == "" {
            return
        }
        var textMods: TextMods?
        let isUnderline = textView.typingAttributes[.underlineStyle] != nil
        let isStrikethrough = textView.typingAttributes[.strikethroughStyle] != nil
        if let font = textView.typingAttributes[.font] as? UIFont {
            let fontName = textView.font!.fontName
            let traits = font.fontDescriptor.symbolicTraits
            let isBold = traits.contains(.traitBold) == true
            let isItalic = traits.contains(.traitItalic) == true
            let size = font.pointSize
            textMods = TextMods(fontName: fontName,
                                size: size,
                                isBold: isBold,
                                isItalic: isItalic,
                                isUnderline: isUnderline,
                                isStrikethrough: isStrikethrough)
        }
        
        guard let note = note else {
            NotesManager.shared.newNote(text: textView.text,
                                        attributedText: textView.attributedText,
                                        textMods: textMods)
            return
        }
        
        if let data = TextMods.toData(textMods: textMods!) {
            note.textMods = data
        }
        note.text = textView.text
        note.attributedText = textView.attributedText
        NotesManager.shared.noteUpdated()
    }

    private func configureFontView() {
        guard let fontView = UINib.createInstance(nibName: "FontView") as? FontView else {
            return
        }
        self.fontView = fontView
        fontView.delegate = self
    }

    private func configureToolBar() {
        let spaceRight = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let fontItem = UIBarButtonItem(image: UIImage(systemName: "character"),
                                       style: .plain, target: self, action: #selector(fontButtonPressed(_:)))
        fontItem.tintColor = UIColor.label

        let bar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 35)))
        bar.items = [fontItem, spaceRight]
        bar.sizeToFit()
        textView.inputAccessoryView = bar
    }

    @objc private func fontButtonPressed(_ sender: UIBarButtonItem) {
        textView.autocorrectionType = .no
        textView.inputView = fontView
        textView.reloadInputViews()
    }
    
    private func switchAttribute(type: TypeFont, currentFont: UIFont?) {
        let attributedString = textView.attributedText!
        let range = textView.selectedRange
        var result: NSMutableAttributedString
        
        switch type {
        case .bold:
            result = TextEditor.switchSymbolicTraits(to: attributedString,
                                                  for: range,
                                                  symbolicTraits: [.traitBold], currentFont: currentFont)
            
        case .italic:
            result = TextEditor.switchSymbolicTraits(to: attributedString,
                                                  for: range,
                                                  symbolicTraits: [.traitItalic], currentFont: currentFont)
        case .underline:
            result = TextEditor.switchUnderline(to: attributedString, for: range)
        case .strikethrough:
            result = TextEditor.switchStrikethrough(to: attributedString, for: range)

        }
        textView.attributedText = result
        textView.selectedRange = range
    }
}

extension NoteViewController: FontViewDelegate {
    func typeFontDidChange(to type: TypeFont, isSelected: Bool) {
        if textView.selectedRange.length == 0 {
            var attributes = textView.typingAttributes
            switch type {
            case .bold:
                attributes = TextEditor.switchAttributes(to: attributes,
                                                         symbolicTraits: [.traitBold])
            case .italic:
                attributes = TextEditor.switchAttributes(to: attributes,
                                                         symbolicTraits: [.traitItalic])
            case .underline:
                attributes = TextEditor.switchUnderline(to: attributes)
            case .strikethrough:
                attributes = TextEditor.switchStrikethrough(to: attributes)
            }
            textView.typingAttributes = attributes
        } else {
            switchAttribute(type: type, currentFont: textView.font)
        }
    }
    
    func closePressed() {
        textView.inputView = nil
        textView.reloadInputViews()
        textView.autocorrectionType = .yes
    }

    func sizeDidChange(to value: CGFloat) {
        if textView.selectedRange.length == 0 {
            textView.typingAttributes = TextEditor.changeSize(to: textView.typingAttributes, size: value)
        } else {
            let range = textView.selectedRange
            textView.attributedText = TextEditor.changeSize(to: textView.attributedText,
                                                            for: range,
                                                            size: value)
            textView.selectedRange = range
        }
    }

    func fontPressed(to font: String) {
        let pickerFont = UIFontPickerViewController()
        pickerFont.delegate = self
        present(pickerFont, animated: true, completion: nil)
    }
}

extension NoteViewController: UIFontPickerViewControllerDelegate {
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        let font = UIFont(descriptor: viewController.selectedFontDescriptor!,
                          size: textView.font!.pointSize)
        textView.font = font
        fontView.setupFont(fontName: font.fontName)
    }
}

extension NoteViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        let range = textView.selectedRange
        var attributes: [NSAttributedString.Key: Any]
        var traits: UIFontDescriptor.SymbolicTraits
        if range.length == 0 {
            attributes = textView.typingAttributes
            guard let font = attributes[.font] as? UIFont else {
                return
            }
            traits = font.fontDescriptor.symbolicTraits
            fontView.setupFontSize(with: font.pointSize)
        } else {
            let attributedText = textView.attributedText!
            traits = TextEditor.getFont(attributedString: attributedText, for: range)!.fontDescriptor.symbolicTraits
            attributes = TextEditor.getAllAttributes(to: attributedText, for: range)
            if let font = attributes[.font] as? UIFont {
                fontView.setupFontSize(with: font.pointSize)
            }
        }
        fontView.changeStateButton(fontView.boldButton, isSelected: traits.contains(.traitBold) == true)
        fontView.changeStateButton(fontView.italicButton, isSelected: traits.contains(.traitItalic) == true)
        fontView.changeStateButton(fontView.underlineButton, isSelected: attributes[.underlineStyle] != nil)
        fontView.changeStateButton(fontView.strikethroughButton, isSelected: attributes[.strikethroughStyle] != nil)
        
    }
}
