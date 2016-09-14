//
//  FormSwitchCell.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 21/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

open class FormSwitchCell: FormTitleCell {
    
    /// MARK: Cell views
    
    open let switchView = UISwitch()
    
    public required init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        switchView.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        accessoryView = switchView
    }
    
    open override func update() {
        super.update()
        
        titleLabel.text = rowDescriptor.title
        
        if let onOff = rowDescriptor.value as? Bool {
            switchView.isOn = onOff
        } else {
            switchView.isOn = false
            rowDescriptor.value = false as NSObject?
        }
    }
    
    internal func valueChanged(_: UISwitch) {
        if switchView.isOn != (rowDescriptor.value as? Bool) {
            rowDescriptor.value = switchView.isOn as NSObject?
        }
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
