//
//  FormTextFieldCell.swift
//  SwiftForms
//
//  Created by Miguel Ángel Ortuño Ortuño on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

public class FormTextFieldCell: FormBaseCell {

    /// MARK: Cell views
    
    public let titleLabel = UILabel()
    public let textField = UITextField()
    
    public required init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        if let fontDefault = self as? FormFontDefaults {
            titleLabel.font = fontDefault.titleLabelFont
            textField.font = fontDefault.textFieldFont
        } else {
            titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
            textField.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        }
        
        textField.textAlignment = .Right
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
        
        titleLabel.setContentHuggingPriority(500, forAxis: .Horizontal)
        titleLabel.setContentCompressionResistancePriority(1000, forAxis: .Horizontal)
        
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Height, relatedBy: .Equal, toItem: contentView, attribute: .Height, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: textField, attribute: .Height, relatedBy: .Equal, toItem: contentView, attribute: .Height, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: textField, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        
        textField.addTarget(self, action: #selector(editingChanged(_:)), forControlEvents: .EditingChanged)
    }
    
    public override func update() {
        super.update()
        
        if let showToolbar = rowDescriptor.configuration.showsInputToolbar
            where textField.inputAccessoryView == .None && showToolbar == true {
                textField.inputAccessoryView = inputAccesoryView()
        }
    
        titleLabel.text = rowDescriptor.title
        textField.text = rowDescriptor.value as? String
        textField.placeholder = rowDescriptor.configuration.placeholder
        
        textField.secureTextEntry = false
        textField.clearButtonMode = .WhileEditing
        
        switch rowDescriptor.rowType {
        case .Text:
            textField.autocorrectionType = .Default
            textField.autocapitalizationType = .Sentences
            textField.keyboardType = .Default
        case .Number:
            textField.keyboardType = .NumberPad
        case .NumbersAndPunctuation:
            textField.keyboardType = .NumbersAndPunctuation
        case .Decimal:
            textField.keyboardType = .DecimalPad
        case .Name:
            textField.autocorrectionType = .No
            textField.autocapitalizationType = .Words
            textField.keyboardType = .Default
        case .Phone:
            textField.keyboardType = .PhonePad
        case .NamePhone:
            textField.autocorrectionType = .No
            textField.autocapitalizationType = .Words
            textField.keyboardType = .NamePhonePad
        case .URL:
            textField.autocorrectionType = .No
            textField.autocapitalizationType = .None
            textField.keyboardType = .URL
        case .Twitter:
            textField.autocorrectionType = .No
            textField.autocapitalizationType = .None
            textField.keyboardType = .Twitter
        case .Email:
            textField.autocorrectionType = .No
            textField.autocapitalizationType = .None
            textField.keyboardType = .EmailAddress
        case .ASCIICapable:
            textField.autocorrectionType = .No
            textField.autocapitalizationType = .None
            textField.keyboardType = .ASCIICapable
        case .Password:
            textField.secureTextEntry = true
            textField.clearsOnBeginEditing = false
        default:
            break
        }
    }
    
    public override func constraintsViews() -> [String : UIView] {
        var views = ["titleLabel" : titleLabel, "textField" : textField]
        if let _ = imageView?.image {
            views["imageView"] = imageView
        }
        return views
    }
    
    public override func defaultVisualConstraints() -> [String] {
        switch (self.imageView?.image, self.titleLabel.text) {
        case (.Some, .Some(let t)) where !t.isEmpty:
            return ["H:[imageView]-[titleLabel]-[textField]-16-|"]
        case (.Some, .None):
            return ["H:[imageView]-[textField]-16-|"]
        case (.None, .Some(let t)) where !t.isEmpty:
            return ["H:|-16-[titleLabel]-[textField]-16-|"]
        default:
            return ["H:|-16-[textField]-16-|"]
        }
    }
    
    public override func firstResponderElement() -> UIResponder? {
        return textField
    }
    
    public override class func formRowCanBecomeFirstResponder() -> Bool {
        return true
    }
    
    
    internal func editingChanged(sender: UITextField) {
        let trimmedText = sender.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        rowDescriptor.value = trimmedText.characters.count > 0 ? trimmedText : nil
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
