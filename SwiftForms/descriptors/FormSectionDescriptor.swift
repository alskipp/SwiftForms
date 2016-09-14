//
//  FormSectionDescriptor.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import Foundation

open class FormSectionDescriptor: NSObject {
    
    open var headerTitle: String
    open var footerTitle: String
    open var rows: [FormRowDescriptor] = []
    
    public init(headerTitle: String = "", footerTitle: String = "") {
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
    }
    
    open func addRow(_ row: FormRowDescriptor) {
        rows.append(row)
    }
    
    open func removeRow(_ row: FormRowDescriptor) {
        if let index = rows.index(of: row) {
            rows.remove(at: index)
        }
    }
}

public func +(section: FormSectionDescriptor, row: FormRowDescriptor) -> FormSectionDescriptor {
    section.addRow(row)
    return section
}
