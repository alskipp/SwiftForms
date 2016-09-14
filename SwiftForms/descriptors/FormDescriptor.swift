//
//  FormDescriptor.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import Foundation

open class FormDescriptor: NSObject {

    open var title = ""
    open var sections: [FormSectionDescriptor] = []
    
    open func addSection(_ section: FormSectionDescriptor) {
        sections.append(section)
    }
    
    open func removeSection(_ section: FormSectionDescriptor) {
        if let index = sections.index(of: section) {
            sections.remove(at: index)
        }
    }
    
    open func formValues() -> Dictionary<String, AnyObject> {

        var formValues: [String: AnyObject] = [:]

        for section in sections {
            for row in section.rows {
                if let val = row.value, row.rowType != .button {
                    formValues[row.tag] = val
                }
            }
        }
        return formValues
    }
    
    open func validateForm() -> FormRowDescriptor! {
        for section in sections {
            for row in section.rows {
                if let required = row.configuration.required {
                    if required && row.value == nil {
                        return row
                    }
                }
            }
        }
        return nil
    }
}
