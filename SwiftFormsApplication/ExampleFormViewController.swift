
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
    public var titleLabelFont: UIFont { return UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline) }
    public var valueLabelFont: UIFont { return UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline) }
    public var textFieldFont: UIFont { return UIFont.preferredFont(forTextStyle: UIFontTextStyle.body) }
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submit(_:)))
    }
    
    /// MARK: Actions
    
    func submit(_: UIBarButtonItem!) {
        
        let message = self.form.formValues().description
        
        let alert: UIAlertView = UIAlertView(title: "Form output", message: message, delegate: nil, cancelButtonTitle: "OK")
        
        alert.show()
    }
    
    /// MARK: Private interface
    
    fileprivate func loadForm() {
        
        let form = FormDescriptor()
        
        form.title = "Example Form"
        
        let section1 = FormSectionDescriptor()
        + FormRowDescriptor(tag: Static.emailTag, rowType: .email, title: "Email", placeholder: "john@gmail.com")
        + FormRowDescriptor(tag: Static.passwordTag, rowType: .password, title: "Password", placeholder: "Enter password")
        
        let section2 = FormSectionDescriptor()
        + FormRowDescriptor(tag: Static.nameTag, rowType: .name, title: "First Name", placeholder: "e.g. Miguel Ángel")
        + FormRowDescriptor(tag: Static.lastNameTag, rowType: .name, title: "Last Name", placeholder: "e.g. Ortuño")
        + FormRowDescriptor(tag: Static.jobTag, rowType: .text, title: "Job", placeholder: "e.g. Mycologist")

        
        let section3 = FormSectionDescriptor()
        + FormRowDescriptor(tag: Static.URLTag, rowType: .url, title: "URL", placeholder: "e.g. gethooksapp.com")
        + FormRowDescriptor(tag: Static.phoneTag, rowType: .phone, title: "Phone", placeholder: "e.g. 0034666777999")
        
        
        let section4 = FormSectionDescriptor(headerTitle: "An example header title", footerTitle: "An example footer title")
        + FormRowDescriptor(tag: Static.enabled, rowType: .booleanSwitch, title: "Enable")
        + FormRowDescriptor(tag: Static.check, rowType: .booleanCheck, title: "Doable")
        + {
            let opts = [0 as NSObject, 1 as NSObject, 2 as NSObject, 3 as NSObject]
            let row = FormRowDescriptor(tag: Static.segmented, rowType: .segmentedControl, title: "Priority", options: opts)
            row.configuration.titleFormatterClosure = { value in
                let v = value as? Int
                switch(v) {
                case 0?: return "None"
                case 1?: return "!"
                case 2?: return "!!"
                case 3?: return "!!!"
                default: return "Wat!!!"
                }
            }
            row.configuration.cellConfiguration = ["segmentedControl.tintColor" : UIColor.red]
            return row
        }()
        
        
        let section5 = FormSectionDescriptor()
        + {
            let opts = ["F" as NSObject, "M" as NSObject, "U" as NSObject]
            let row = FormRowDescriptor(tag: Static.picker, rowType: .picker, title: "Gender", value: "M" as NSObject, options: opts)
            row.configuration.titleFormatterClosure = { value in
                let v = value as? String
                switch(v) {
                case "F"?: return "Female"
                case "M"?: return "Male"
                case "U"?: return "I'd rather not to say"
                default: return "Wat!!!"
                }
            }
            return row
        }()
        + FormRowDescriptor(tag: Static.birthday, rowType: .date, title: "Birthday")
        + {
            let row = FormRowDescriptor(tag: Static.categories, rowType: .multipleSelector, title: "Categories", options: [0 as NSObject, 1 as NSObject, 2 as NSObject, 3 as NSObject, 4 as NSObject])
            row.configuration.allowsMultipleSelection = true
            row.configuration.titleFormatterClosure = { value in
                let v = value as? Int
                switch(v) {
                case 0?: return "Restaurant"
                case 1?: return "Pub"
                case 2?: return "Shop"
                case 3?: return "Hotel"
                case 4?: return "Camping"
                default: return "Wat!!!"
                }
            }
            return row
        }()

        
        let section6 = FormSectionDescriptor(headerTitle: "Stepper & Slider")
        + {
            let row = FormRowDescriptor(tag: Static.stepper, rowType: .stepper, title: "Step count")
            row.configuration.maximumValue = 200.0
            row.configuration.minimumValue = 20.0
            row.configuration.steps = 2.0
            return row
        }()
        + FormRowDescriptor(tag: Static.slider, rowType: .slider, title: "Slider", value: 0.5 as NSObject?)
        
        
        let section7 = FormSectionDescriptor(headerTitle: "Multiline TextView")
        + FormRowDescriptor(tag: Static.textView, rowType: .multilineText, title: "Notes")

        
        let section8 = FormSectionDescriptor()
        + {
            let row = FormRowDescriptor(tag: Static.button, rowType: .button, title: "Dismiss")
            row.configuration.didSelectClosure = { self.view.endEditing(true) }
            return row
        }()

        
        form.sections = [section1, section2, section3, section4, section5, section6, section7, section8]
        self.form = form
    }
}
