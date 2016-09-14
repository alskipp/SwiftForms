//
//  FormViewController.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuño on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

open class FormViewController : UITableViewController {

    private static var __once: () = {
            Static.defaultCellClasses[FormRowType.text] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.number] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.numbersAndPunctuation] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.decimal] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.name] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.phone] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.url] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.twitter] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.namePhone] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.email] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.asciiCapable] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.password] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.button] = FormButtonCell.self
            Static.defaultCellClasses[FormRowType.booleanSwitch] = FormSwitchCell.self
            Static.defaultCellClasses[FormRowType.booleanCheck] = FormCheckCell.self
            Static.defaultCellClasses[FormRowType.segmentedControl] = FormSegmentedControlCell.self
            Static.defaultCellClasses[FormRowType.picker] = FormPickerCell.self
            Static.defaultCellClasses[FormRowType.date] = FormDateCell.self
            Static.defaultCellClasses[FormRowType.time] = FormDateCell.self
            Static.defaultCellClasses[FormRowType.dateAndTime] = FormDateCell.self
            Static.defaultCellClasses[FormRowType.stepper] = FormStepperCell.self
            Static.defaultCellClasses[FormRowType.slider] = FormSliderCell.self
            Static.defaultCellClasses[FormRowType.multipleSelector] = FormSelectorCell.self
            Static.defaultCellClasses[FormRowType.multilineText] = FormTextViewCell.self
        }()

    /// MARK: Types
    
    fileprivate struct Static {
        static var onceDefaultCellClass: Int = 0
        static var defaultCellClasses: [FormRowType : FormBaseCell.Type] = [:]
    }
    
    /// MARK: Properties
    
    open var form = FormDescriptor()

    /// MARK: View life cycle

    open override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = form.title
    }
    
    /// MARK: Public interface
    
    open func valueForTag(_ tag: String) -> AnyObject? {
        for section in form.sections {
            for row in section.rows {
                if row.tag == tag {
                    return row.value
                }
            }
        }
        return nil
    }
    
    open func setValue(_ value: NSObject, forTag tag: String) {
        for (sectionIndex, section) in form.sections.enumerated() {
            if let rowIndex = (section.rows.map { $0.tag }).index(of: tag),
               let cell = self.tableView.cellForRow(at: IndexPath(row: rowIndex, section: sectionIndex)) as? FormBaseCell {
                    section.rows[rowIndex].value = value
                    cell.update()
            }
        }
    }

    open func indexPathOfTag(_ tag: String) -> IndexPath? {
        for (sectionIndex, section) in form.sections.enumerated() {
            if let rowIndex = (section.rows.map { $0.tag }).index(of: tag) {
                return IndexPath(row: rowIndex, section: sectionIndex)
            }
        }
        return .none
    }
    
    /// MARK: UITableViewDataSource
  
    open override func numberOfSections(in tableView: UITableView) -> Int {
        return form.sections.count
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form.sections[section].rows.count
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowDescriptor = formRowDescriptorAtIndexPath(indexPath)
        
        let formBaseCellClass = formBaseCellClassFromRowDescriptor(rowDescriptor)
        
        let reuseIdentifier = NSStringFromClass(formBaseCellClass)
        
        var cell: FormBaseCell? = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? FormBaseCell
        if cell == nil {
            cell = formBaseCellClass.init(style: .default, reuseIdentifier: reuseIdentifier)
            cell?.formViewController = self
            cell?.configure()
        }
        
        cell?.rowDescriptor = rowDescriptor
        
        // apply cell custom design
        if let cellConfiguration = rowDescriptor.configuration.cellConfiguration {
            for (keyPath, value) in cellConfiguration {
                cell?.setValue(value, forKeyPath: keyPath)
            }
        }
        return cell!
    }
    
    open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return form.sections[section].headerTitle
    }
    
    open override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return form.sections[section].footerTitle
    }
    
    /// MARK: UITableViewDelegate
    
    open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowDescriptor = formRowDescriptorAtIndexPath(indexPath)
        return formBaseCellClassFromRowDescriptor(rowDescriptor).formRowCellHeight()
    }
    
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowDescriptor = formRowDescriptorAtIndexPath(indexPath)
        
        if let selectedRow = tableView.cellForRow(at: indexPath) as? FormBaseCell {
            let formBaseCellClass = formBaseCellClassFromRowDescriptor(rowDescriptor)
            formBaseCellClass.formViewController(self, didSelectRow: selectedRow)
        }
        
        if let didSelectClosure = rowDescriptor.configuration.didSelectClosure {
            didSelectClosure()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    fileprivate class func defaultCellClassForRowType(_ rowType: FormRowType) -> FormBaseCell.Type {
        _ = FormViewController.__once
        return Static.defaultCellClasses[rowType]!
    }
    
    open func formRowDescriptorAtIndexPath(_ indexPath: IndexPath) -> FormRowDescriptor {
        let section = form.sections[(indexPath as NSIndexPath).section]
        let rowDescriptor = section.rows[(indexPath as NSIndexPath).row]
        return rowDescriptor
    }
    
    fileprivate func formBaseCellClassFromRowDescriptor(_ rowDescriptor: FormRowDescriptor) -> FormBaseCell.Type {
        let formBaseCellClass: FormBaseCell.Type
        
        if let cellClass = rowDescriptor.configuration.cellClass {
            formBaseCellClass = cellClass
        } else {
            formBaseCellClass = FormViewController.defaultCellClassForRowType(rowDescriptor.rowType)
        }
        
        return formBaseCellClass
    }
}
