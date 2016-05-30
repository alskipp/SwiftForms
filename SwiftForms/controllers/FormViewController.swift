//
//  FormViewController.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuño on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

public class FormViewController : UITableViewController {

    /// MARK: Types
    
    private struct Static {
        static var onceDefaultCellClass: dispatch_once_t = 0
        static var defaultCellClasses: [FormRowType : FormBaseCell.Type] = [:]
    }
    
    /// MARK: Properties
    
    public var form = FormDescriptor()
    
    /// MARK: Init
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    /// MARK: View life cycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = form.title
    }
    
    /// MARK: Public interface
    
    public func valueForTag(tag: String) -> AnyObject? {
        for section in form.sections {
            for row in section.rows {
                if row.tag == tag {
                    return row.value
                }
            }
        }
        return nil
    }
    
    public func setValue(value: NSObject, forTag tag: String) {
        for (sectionIndex, section) in form.sections.enumerate() {
            if let rowIndex = (section.rows.map { $0.tag }).indexOf(tag),
               let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowIndex, inSection: sectionIndex)) as? FormBaseCell {
                    section.rows[rowIndex].value = value
                    cell.update()
            }
        }
    }

    public func indexPathOfTag(tag: String) -> NSIndexPath? {
        for (sectionIndex, section) in form.sections.enumerate() {
            if let rowIndex = (section.rows.map { $0.tag }).indexOf(tag) {
                return NSIndexPath(forRow: rowIndex, inSection: sectionIndex)
            }
        }
        return .None
    }
    
    /// MARK: UITableViewDataSource
  
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return form.sections.count
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form.sections[section].rows.count
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let rowDescriptor = formRowDescriptorAtIndexPath(indexPath)
        
        let formBaseCellClass = formBaseCellClassFromRowDescriptor(rowDescriptor)
        
        let reuseIdentifier = NSStringFromClass(formBaseCellClass)
        
        var cell: FormBaseCell? = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as? FormBaseCell
        if cell == nil {
            cell = formBaseCellClass.init(style: .Default, reuseIdentifier: reuseIdentifier)
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
    
    public override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return form.sections[section].headerTitle
    }
    
    public override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return form.sections[section].footerTitle
    }
    
    /// MARK: UITableViewDelegate
    
    public override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let rowDescriptor = formRowDescriptorAtIndexPath(indexPath)
        return formBaseCellClassFromRowDescriptor(rowDescriptor).formRowCellHeight()
    }
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let rowDescriptor = formRowDescriptorAtIndexPath(indexPath)
        
        if let selectedRow = tableView.cellForRowAtIndexPath(indexPath) as? FormBaseCell {
            let formBaseCellClass = formBaseCellClassFromRowDescriptor(rowDescriptor)
            formBaseCellClass.formViewController(self, didSelectRow: selectedRow)
        }
        
        if let didSelectClosure = rowDescriptor.configuration.didSelectClosure {
            didSelectClosure()
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    private class func defaultCellClassForRowType(rowType: FormRowType) -> FormBaseCell.Type {
        dispatch_once(&Static.onceDefaultCellClass) {
            Static.defaultCellClasses[FormRowType.Text] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.Number] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.NumbersAndPunctuation] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.Decimal] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.Name] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.Phone] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.URL] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.Twitter] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.NamePhone] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.Email] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.ASCIICapable] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.Password] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.Button] = FormButtonCell.self
            Static.defaultCellClasses[FormRowType.BooleanSwitch] = FormSwitchCell.self
            Static.defaultCellClasses[FormRowType.BooleanCheck] = FormCheckCell.self
            Static.defaultCellClasses[FormRowType.SegmentedControl] = FormSegmentedControlCell.self
            Static.defaultCellClasses[FormRowType.Picker] = FormPickerCell.self
            Static.defaultCellClasses[FormRowType.Date] = FormDateCell.self
            Static.defaultCellClasses[FormRowType.Time] = FormDateCell.self
            Static.defaultCellClasses[FormRowType.DateAndTime] = FormDateCell.self
            Static.defaultCellClasses[FormRowType.Stepper] = FormStepperCell.self
            Static.defaultCellClasses[FormRowType.Slider] = FormSliderCell.self
            Static.defaultCellClasses[FormRowType.MultipleSelector] = FormSelectorCell.self
            Static.defaultCellClasses[FormRowType.MultilineText] = FormTextViewCell.self
        }
        return Static.defaultCellClasses[rowType]!
    }
    
    public func formRowDescriptorAtIndexPath(indexPath: NSIndexPath) -> FormRowDescriptor {
        let section = form.sections[indexPath.section]
        let rowDescriptor = section.rows[indexPath.row]
        return rowDescriptor
    }
    
    private func formBaseCellClassFromRowDescriptor(rowDescriptor: FormRowDescriptor) -> FormBaseCell.Type {
        let formBaseCellClass: FormBaseCell.Type
        
        if let cellClass = rowDescriptor.configuration.cellClass {
            formBaseCellClass = cellClass
        } else {
            formBaseCellClass = FormViewController.defaultCellClassForRowType(rowDescriptor.rowType)
        }
        
        return formBaseCellClass
    }
}
