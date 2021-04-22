//
//  FontView.swift
//  FocusStart
//
//  Created by Ilya Salatyuk on 3/18/21.
//

import UIKit

protocol FontViewDelegate: class {
    func sizeDidChange(to value: CGFloat)
    func fontPressed(to font: String)
    func typeFontDidChange(to type: TypeFont, isSelected: Bool)
    func closePressed()
}

enum TypeFont: Int {
    case bold
    case italic
    case underline
    case strikethrough
}

class FontView: UIInputView {
    private var height: CGFloat = 190

    @IBOutlet var sizeLabel: UILabel!
    @IBOutlet var currentSize: UILabel!
    @IBOutlet var sizeStepper: UIStepper!
    @IBOutlet var changeFontButton: UIButton!
    @IBOutlet var typeButtonsStack: UIStackView!
    @IBOutlet var boldButton: UIButton!
    @IBOutlet var italicButton: UIButton!
    @IBOutlet var underlineButton: UIButton!
    @IBOutlet var strikethroughButton: UIButton!
    
    weak var delegate: FontViewDelegate?
    private var bottomConstraint: NSLayoutConstraint!

    private var animator: UIViewPropertyAnimator?

    var isShow: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()

        sizeStepper.stepValue = 1
        for button in typeButtonsStack.subviews {
            button.layer.cornerRadius = button.bounds.height / 2
            button.layer.cornerCurve = .continuous
        }

        sizeStepper.layer.cornerRadius = sizeStepper.bounds.height / 2
        sizeStepper.layer.cornerCurve = .continuous
        sizeStepper.layer.masksToBounds = true

        changeFontButton.layer.cornerRadius = sizeStepper.bounds.height / 2
        changeFontButton.layer.cornerCurve = .continuous
    }

    override var allowsSelfSizing: Bool {
        get {
            return true
        }
        set { }
    }

    override var inputViewStyle: UIInputView.Style {
        get { return .default }
        set { }
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }

    @IBAction func sizeDidChange(_ sender: UIButton) {
        let value = sizeStepper.value
        currentSize.text = String(Int(value))
        delegate?.sizeDidChange(to: CGFloat(value))
    }

    @IBAction func fontDidChange(_ sender: UIButton) {
        delegate?.fontPressed(to: "")
    }

    @IBAction func boldPressed(_ sender: UIButton) {
        changeStateButton(sender, isSelected: !sender.isSelected)
        delegate?.typeFontDidChange(to: .bold, isSelected: sender.isSelected)
    }

    @IBAction func italicPressed(_ sender: UIButton) {
        changeStateButton(sender, isSelected: !sender.isSelected)
        delegate?.typeFontDidChange(to: .italic, isSelected: sender.isSelected)
    }

    @IBAction func underlinePressed(_ sender: UIButton) {
        changeStateButton(sender, isSelected: !sender.isSelected)
        delegate?.typeFontDidChange(to: .underline, isSelected: sender.isSelected)
    }

    @IBAction func strikethroughPressed(_ sender: UIButton) {
        changeStateButton(sender, isSelected: !sender.isSelected)
        delegate?.typeFontDidChange(to: .strikethrough, isSelected: sender.isSelected)
    }

    @IBAction func closePressed(_ sender: Any) {
        delegate?.closePressed()
    }

    func changeStateButton(_ button: UIButton, isSelected: Bool) {
        button.isSelected = isSelected
        if button.isSelected {
            button.backgroundColor = UIColor.systemBlue
        } else {
            button.backgroundColor = UIColor.systemGray6
        }
    }

    func setupFontSize(with size: CGFloat) {
        currentSize.text = String(Int(size))
        sizeStepper.value = Double(size)
    }

    func setupFont(fontName: String) {
        changeFontButton.setTitle(fontName, for: .normal)
    }
}
