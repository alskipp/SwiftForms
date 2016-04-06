//
//  FormSwitchCell.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 21/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

public class FormSwitchCell: FormTitleCell {
    
    /// MARK: Cell views
    
    public let switchView = UISwitch()
    
    public required init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        switchView.addTarget(self, action: #selector(valueChanged(_:)), forControlEvents: .ValueChanged)
        accessoryView = switchView
    }
    
    public override func update() {
        super.update()
        
        titleLabel.text = rowDescriptor.title
        
        if let onOff = rowDescriptor.value as? Bool {
            switchView.on = onOff
        } else {
            switchView.on = false
            rowDescriptor.value = false
        }
    }
    
    internal func valueChanged(_: UISwitch) {
        if switchView.on != rowDescriptor.value {
            rowDescriptor.value = switchView.on
        }
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
