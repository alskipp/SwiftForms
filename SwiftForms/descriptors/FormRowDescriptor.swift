//
//  FormRowDescriptor.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

public enum FormRowType {
    case unknown
    case text
    case url
    case number
    case numbersAndPunctuation
    case decimal
    case name
    case phone
    case namePhone
    case email
    case twitter
    case asciiCapable
    case password
    case button
    case booleanSwitch
    case booleanCheck
    case segmentedControl
    case picker
    case date
    case time
    case dateAndTime
    case stepper
    case slider
    case multipleSelector
    case multilineText
}

public typealias DidSelectClosure = (Void) -> Void
public typealias UpdateClosure = (FormRowDescriptor) -> Void
public typealias TitleFormatterClosure = (NSObject) -> String
public typealias VisualConstraintsClosure = (FormBaseCell) -> [String]

open class FormRowDescriptor: NSObject {

    /// MARK: Properties
    
    open var title: String
    open var rowType: FormRowType
    open var tag: String
    
    open var value: NSObject? {
        willSet {
            if let willUpdateBlock = self.configuration.willUpdateClosure {
                willUpdateBlock(self)
            }
        }
        didSet {
            if let didUpdateBlock = self.configuration.didUpdateClosure {
                didUpdateBlock(self)
            }
        }
    }
    
    open var configuration = RowConfiguration()
    
    /// MARK: Init

    public init(tag: String, rowType: FormRowType = .unknown, title: String = "", value: NSObject? = .none, placeholder: String? = .none, options: [NSObject]? = .none) {
        configuration.required = true
        configuration.allowsMultipleSelection = false
        configuration.showsInputToolbar = false
        configuration.placeholder = placeholder
        configuration.options = options
        
        self.tag = tag
        self.rowType = rowType
        self.title = title
        self.value = value
    }
    
    /// MARK: Public interface
    
    open func titleForOptionAtIndex(_ index: Int) -> String {
        if let options = configuration.options {
            return titleForOptionValue(options[index])
        }
        return ""
    }
    
    open func titleForOptionValue(_ optionValue: NSObject) -> String {
        if let titleFormatter = configuration.titleFormatterClosure {
            return titleFormatter(optionValue)
        }
        else if let opt = optionValue as? String {
            return opt
        }
        return "\(optionValue)"
    }
}

public struct RowConfiguration {
    public var required: Bool?
    
    public var cellClass: FormBaseCell.Type?
    public var checkmarkAccessoryView: UIView?
    public var cellConfiguration: [String: NSObject]?
    
    public var placeholder: String?
    
    public var willUpdateClosure: UpdateClosure?
    public var didUpdateClosure: UpdateClosure?
    
    public var maximumValue: Double?
    public var minimumValue: Double?
    public var steps: Double?
    
    public var continuous: Bool?
    
    public var didSelectClosure: DidSelectClosure?
    
    public var visualConstraintsClosure: VisualConstraintsClosure?
    
    public var options: [NSObject]?
    
    public var titleFormatterClosure: TitleFormatterClosure?
    
    public var selectorControllerClass: FormSelector?
    
    public var allowsMultipleSelection: Bool?
    
    public var showsInputToolbar: Bool?
    
    public var dateFormatter: DateFormatter?
}
