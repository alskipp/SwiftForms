//
//  FormStepperCell.swift
//  SwiftFormsApplication
//
//  Created by Miguel Angel Ortuno Ortuno on 23/5/15.
//  Copyright (c) 2015 Miguel Angel Ortuno Ortuno. All rights reserved.
//

public class FormStepperCell: FormTitleCell {

    /// MARK: Cell views
    
    public let stepperView = UIStepper()
    public let countLabel = UILabel()
    
    public required init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stepperView.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.textAlignment = .Right
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(stepperView)
        
        titleLabel.setContentHuggingPriority(500, forAxis: .Horizontal)
        
        contentView.addConstraint(NSLayoutConstraint(item: stepperView, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        
        stepperView.addTarget(self, action: #selector(valueChanged(_:)), forControlEvents: .ValueChanged)
    }
    
    public override func update() {
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
            rowDescriptor.value = stepperView.minimumValue
        }
        
        countLabel.text = rowDescriptor.value?.description
    }
    
    public override func constraintsViews() -> [String : UIView] {
        return ["titleLabel" : titleLabel, "countLabel" : countLabel, "stepperView" : stepperView]
    }
    
    public override func defaultVisualConstraints() -> [String] {
        return [
            "V:|[titleLabel]|",
            "V:|[countLabel]|",
            "H:|-16-[titleLabel][countLabel]-[stepperView]-16-|"
        ]
    }
    
    internal func valueChanged(_: UISwitch) {
        rowDescriptor.value = stepperView.value
        countLabel.text = rowDescriptor.value?.description
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
