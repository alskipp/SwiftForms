
//  ExampleFormViewController.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit
import SwiftForms

/*
To use a custom font by default for all form cells, conform `FormBaseCell` to `FormFontDefaults`:
*/
extension FormBaseCell: FormFontDefaults {
    public var titleLabelFont: UIFont { return UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline) }
    public var valueLabelFont: UIFont { return UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline) }
    public var textFieldFont: UIFont { return UIFont.preferredFontForTextStyle(UIFontTextStyleBody) }
}

class ExampleFormViewController: FormViewController {
    
    struct Static {
        static let nameTag = "name"
        static let passwordTag = "password"
        static let lastNameTag = "lastName"
        static let jobTag = "job"
        static let emailTag = "email"
        static let URLTag = "url"
        static let phoneTag = "phone"
        static let enabled = "enabled"
        static let check = "check"
        static let segmented = "segmented"
        static let picker = "picker"
        static let birthday = "birthday"
        static let categories = "categories"
        static let button = "button"
        static let stepper = "stepper"
        static let slider = "slider"
        static let textView = "textview"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .Plain, target: self, action: #selector(submit(_:)))
    }
    
    /// MARK: Actions
    
    func submit(_: UIBarButtonItem!) {
        
        let message = self.form.formValues().description
        
        let alert: UIAlertView = UIAlertView(title: "Form output", message: message, delegate: nil, cancelButtonTitle: "OK")
        
        alert.show()
    }
    
    /// MARK: Private interface
    
    private func loadForm() {
        
        let form = FormDescriptor()
        
        form.title = "Example Form"
        
        let section1 = FormSectionDescriptor()
        + FormRowDescriptor(tag: Static.emailTag, rowType: .Email, title: "Email", placeholder: "john@gmail.com")
        + FormRowDescriptor(tag: Static.passwordTag, rowType: .Password, title: "Password", placeholder: "Enter password")
        
        let section2 = FormSectionDescriptor()
        + FormRowDescriptor(tag: Static.nameTag, rowType: .Name, title: "First Name", placeholder: "e.g. Miguel Ángel")
        + FormRowDescriptor(tag: Static.lastNameTag, rowType: .Name, title: "Last Name", placeholder: "e.g. Ortuño")
        + FormRowDescriptor(tag: Static.jobTag, rowType: .Text, title: "Job", placeholder: "e.g. Mycologist")

        
        let section3 = FormSectionDescriptor()
        + FormRowDescriptor(tag: Static.URLTag, rowType: .URL, title: "URL", placeholder: "e.g. gethooksapp.com")
        + FormRowDescriptor(tag: Static.phoneTag, rowType: .Phone, title: "Phone", placeholder: "e.g. 0034666777999")
        
        
        let section4 = FormSectionDescriptor(headerTitle: "An example header title", footerTitle: "An example footer title")
        + FormRowDescriptor(tag: Static.enabled, rowType: .BooleanSwitch, title: "Enable")
        + FormRowDescriptor(tag: Static.check, rowType: .BooleanCheck, title: "Doable")
        + {
            let row = FormRowDescriptor(tag: Static.segmented, rowType: .SegmentedControl, title: "Priority", options: [0, 1, 2, 3])
            row.configuration.titleFormatterClosure = { value in
                switch( value ) {
                case 0: return "None"
                case 1: return "!"
                case 2: return "!!"
                case 3: return "!!!"
                default: return "Wat!!!"
                }
            }
            row.configuration.cellConfiguration = ["segmentedControl.tintColor" : UIColor.redColor()]
            return row
        }()
        
        
        let section5 = FormSectionDescriptor()
        + {
            let row = FormRowDescriptor(tag: Static.picker, rowType: .Picker, title: "Gender", options: ["F", "M", "U"], value: "M")
            row.configuration.titleFormatterClosure = { value in
                switch( value ) {
                case "F": return "Female"
                case "M": return "Male"
                case "U": return "I'd rather not to say"
                default: return "Wat!!!"
                }
            }
            return row
        }()
        + FormRowDescriptor(tag: Static.birthday, rowType: .Date, title: "Birthday")
        + {
            let row = FormRowDescriptor(tag: Static.categories, rowType: .MultipleSelector, title: "Categories", options: [0, 1, 2, 3, 4])
            row.configuration.allowsMultipleSelection = true
            row.configuration.titleFormatterClosure = { value in
                switch( value ) {
                case 0: return "Restaurant"
                case 1: return "Pub"
                case 2: return "Shop"
                case 3: return "Hotel"
                case 4: return "Camping"
                default: return "Wat!!!"
                }
            }
            return row
        }()

        
        let section6 = FormSectionDescriptor(headerTitle: "Stepper & Slider")
        + {
            let row = FormRowDescriptor(tag: Static.stepper, rowType: .Stepper, title: "Step count")
            row.configuration.maximumValue = 200.0
            row.configuration.minimumValue = 20.0
            row.configuration.steps = 2.0
            return row
        }()
        + FormRowDescriptor(tag: Static.slider, rowType: .Slider, title: "Slider", value: 0.5)
        
        
        let section7 = FormSectionDescriptor(headerTitle: "Multiline TextView")
        + FormRowDescriptor(tag: Static.textView, rowType: .MultilineText, title: "Notes")

        
        let section8 = FormSectionDescriptor()
        + {
            let row = FormRowDescriptor(tag: Static.button, rowType: .Button, title: "Dismiss")
            row.configuration.didSelectClosure = { self.view.endEditing(true) }
            return row
        }()

        
        form.sections = [section1, section2, section3, section4, section5, section6, section7, section8]
        self.form = form
    }
}
