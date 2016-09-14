//
//  FormStepperCell.swift
//  SwiftFormsApplication
//
//  Created by Miguel Angel Ortuno Ortuno on 23/5/15.
//  Copyright (c) 2015 Miguel Angel Ortuno Ortuno. All rights reserved.
//

open class FormStepperCell: FormTitleCell {

    /// MARK: Cell views
    
    open let stepperView = UIStepper()
    open let countLabel = UILabel()
    
    public required init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stepperView.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.textAlignment = .right
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(stepperView)
        
        titleLabel.setContentHuggingPriority(500, for: .horizontal)
        
        contentView.addConstraint(NSLayoutConstraint(item: stepperView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        stepperView.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
    }
    
    open override func update() {
        super.update()
        let config = rowDescriptor.configuration
        
        if let mx = config.maximumValue { stepperView.maximumValue = mx }
        if let mn = config.minimumValue { stepperView.minimumValue = mn }
        if let s = config.steps { stepperView.stepValue = s }
        
        titleLabel.text = rowDescriptor.title
        
        if let value = rowDescriptor.value as? Double {
            stepperView.value = value
        } else {
            stepperView.value = stepperView.minimumValue
            rowDescriptor.value = stepperView.minimumValue as NSObject?
        }
        
        countLabel.text = rowDescriptor.value?.description
    }
    
    open override func constraintsViews() -> [String : UIView] {
        return ["titleLabel" : titleLabel, "countLabel" : countLabel, "stepperView" : stepperView]
    }
    
    open override func defaultVisualConstraints() -> [String] {
        return [
            "V:|[titleLabel]|",
            "V:|[countLabel]|",
            "H:|-16-[titleLabel][countLabel]-[stepperView]-16-|"
        ]
    }
    
    internal func valueChanged(_: UISwitch) {
        rowDescriptor.value = stepperView.value as NSObject?
        countLabel.text = rowDescriptor.value?.description
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
