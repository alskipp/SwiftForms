//
//  FormSegmentedControlCell.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 21/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

open class FormSegmentedControlCell: FormBaseCell {
    
    /// MARK: Cell views
    
    open let titleLabel = UILabel()
    open let segmentedControl = UISegmentedControl()
    
    public required init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.setContentCompressionResistancePriority(500, for: .horizontal)
        segmentedControl.setContentCompressionResistancePriority(500, for: .horizontal)
        
        titleLabel.font = (self as? FormFontDefaults).map {
            $0.titleLabelFont
            } ?? UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(segmentedControl)
        
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: segmentedControl, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        segmentedControl.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
    }

    open override func update() {
        super.update()

        titleLabel.text = rowDescriptor.title
        updateSegmentedControl()

        if let value = rowDescriptor.value,
           let options = rowDescriptor.configuration.options,
           let idx = options.index(of: value) {
            segmentedControl.selectedSegmentIndex = idx
        }
    }
    
    open override func constraintsViews() -> [String : UIView] {
        return ["titleLabel" : titleLabel, "segmentedControl" : segmentedControl]
    }
    
    open override func defaultVisualConstraints() -> [String] {
        if let text = titleLabel.text, !text.isEmpty {
            return ["H:|-16-[titleLabel]-16-[segmentedControl]-16-|"]
        }
        else {
            return ["H:|-16-[segmentedControl]-16-|"]
        }
    }
    
    /// MARK: Actions
    
    internal func valueChanged(_ sender: UISegmentedControl) {
        let options = rowDescriptor.configuration.options
        let optionValue = options?[sender.selectedSegmentIndex]
        rowDescriptor.value = optionValue
    }
    
    /// MARK: Private
    
    fileprivate func updateSegmentedControl() {
        segmentedControl.removeAllSegments()
        if let options = rowDescriptor.configuration.options {
            for (idx, optionValue) in options.enumerated() {
                segmentedControl.insertSegment(withTitle: rowDescriptor.titleForOptionValue(optionValue), at: idx, animated: false)
            }
        }
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
