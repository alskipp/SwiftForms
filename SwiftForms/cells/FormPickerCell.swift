//
//  FormPickerCell.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 22/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

open class FormPickerCell: FormValueCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    /// MARK: Properties
    
    fileprivate let picker = UIPickerView()
    fileprivate let hiddenTextField = UITextField(frame: CGRect.zero)
    
    public required init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .none
        
        picker.delegate = self
        picker.dataSource = self
        hiddenTextField.inputView = picker
        
        contentView.addSubview(hiddenTextField)
    }
    
    open override func update() {
        super.update()
        
        titleLabel.text = rowDescriptor.title
        
        if let value = rowDescriptor.value {
            valueLabel.text = rowDescriptor.titleForOptionValue(value)
            if let options = rowDescriptor.configuration.options,
               let index = options.index(of: value) {
                picker.selectRow(index, inComponent: 0, animated: false)
            }
        }
    }

    open override class func formViewController(_ formViewController: FormViewController, didSelectRow selectedRow: FormBaseCell) {
        if let row = selectedRow as? FormPickerCell {
            if let optionValue = selectedRow.rowDescriptor.value {
                row.valueLabel.text = selectedRow.rowDescriptor.titleForOptionValue(optionValue)
            } else if let optionValue = selectedRow.rowDescriptor.configuration.options?.first {
                selectedRow.rowDescriptor.value = optionValue
                row.valueLabel.text = selectedRow.rowDescriptor.titleForOptionValue(optionValue)
            }
            row.hiddenTextField.becomeFirstResponder()
        }
    }

    /// MARK: UIPickerViewDelegate
    
    open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rowDescriptor.titleForOptionAtIndex(row)
    }
    
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let optionValue = rowDescriptor.configuration.options?[row] {
            rowDescriptor.value = optionValue
            valueLabel.text = rowDescriptor.titleForOptionValue(optionValue)
        }
    }
    
    /// MARK: UIPickerViewDataSource
    
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rowDescriptor.configuration.options?.count ?? 0
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
