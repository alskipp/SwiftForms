//
//  FormTextFieldCell.swift
//  SwiftForms
//
//  Created by Miguel Ángel Ortuño Ortuño on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

open class FormTextFieldCell: FormBaseCell {

    /// MARK: Cell views
    
    open let titleLabel = UILabel()
    open let textField = UITextField()
    
    public required init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        if let fontDefault = self as? FormFontDefaults {
            titleLabel.font = fontDefault.titleLabelFont
            textField.font = fontDefault.textFieldFont
        } else {
            titleLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
            textField.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        }
        
        textField.textAlignment = .right
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        
        titleLabel.setContentHuggingPriority(500, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(1000, for: .horizontal)
        
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: textField, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        textField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
    }
    
    open override func update() {
        super.update()
        
        if let showToolbar = rowDescriptor.configuration.showsInputToolbar,
            textField.inputAccessoryView == .none && showToolbar == true {
                textField.inputAccessoryView = inputAccesoryView()
        }
    
        titleLabel.text = rowDescriptor.title
        textField.text = rowDescriptor.value as? String
        textField.placeholder = rowDescriptor.configuration.placeholder
        
        textField.isSecureTextEntry = false
        textField.clearButtonMode = .whileEditing
        
        switch rowDescriptor.rowType {
        case .text:
            textField.autocorrectionType = .default
            textField.autocapitalizationType = .sentences
            textField.keyboardType = .default
        case .number:
            textField.keyboardType = .numberPad
        case .numbersAndPunctuation:
            textField.keyboardType = .numbersAndPunctuation
        case .decimal:
            textField.keyboardType = .decimalPad
        case .name:
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .words
            textField.keyboardType = .default
        case .phone:
            textField.keyboardType = .phonePad
        case .namePhone:
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .words
            textField.keyboardType = .namePhonePad
        case .url:
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
            textField.keyboardType = .URL
        case .twitter:
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
            textField.keyboardType = .twitter
        case .email:
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
            textField.keyboardType = .emailAddress
        case .asciiCapable:
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
            textField.keyboardType = .asciiCapable
        case .password:
            textField.isSecureTextEntry = true
            textField.clearsOnBeginEditing = false
        default:
            break
        }
    }
    
    open override func constraintsViews() -> [String : UIView] {
        var views = ["titleLabel" : titleLabel, "textField" : textField]
        if let _ = imageView?.image {
            views["imageView"] = imageView
        }
        return views
    }
    
    open override func defaultVisualConstraints() -> [String] {
        switch (self.imageView?.image, self.titleLabel.text) {
        case (.some, .some(let t)) where !t.isEmpty:
            return ["H:[imageView]-[titleLabel]-[textField]-16-|"]
        case (.some, .none):
            return ["H:[imageView]-[textField]-16-|"]
        case (.none, .some(let t)) where !t.isEmpty:
            return ["H:|-16-[titleLabel]-[textField]-16-|"]
        default:
            return ["H:|-16-[textField]-16-|"]
        }
    }
    
    open override func firstResponderElement() -> UIResponder? {
        return textField
    }
    
    open override class func formRowCanBecomeFirstResponder() -> Bool {
        return true
    }
    
    
    internal func editingChanged(_ sender: UITextField) {
        let trimmedText = sender.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        rowDescriptor.value = trimmedText.characters.count > 0 ? (trimmedText as NSObject) : .none
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
