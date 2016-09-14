//
//  FormSliderCell.swift
//  SwiftFormsApplication
//
//  Created by Miguel Angel Ortuno Ortuno on 23/5/15.
//  Copyright (c) 2015 Miguel Angel Ortuno Ortuno. All rights reserved.
//

open class FormSliderCell: FormTitleCell {
    
    /// MARK: Cell views
    
    open let sliderView = UISlider()
    
    public required init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(sliderView)
        
        titleLabel.setContentHuggingPriority(500, for: .horizontal)
        
        contentView.addConstraint(NSLayoutConstraint(item: sliderView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        sliderView.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
    }
    
    open override func update() {
        super.update()
        let config = rowDescriptor.configuration

        if let mx = config.maximumValue { sliderView.maximumValue = Float(mx) }
        if let mn = config.minimumValue { sliderView.minimumValue = Float(mn) }
        if let c = config.continuous { sliderView.isContinuous = c }
        
        titleLabel.text = rowDescriptor.title
        
        if let value = rowDescriptor.value as? Float {
            sliderView.value = value
        } else {
            sliderView.value = sliderView.minimumValue
            rowDescriptor.value = sliderView.minimumValue as NSObject?
        }
    }
    
    open override func constraintsViews() -> [String : UIView] {
        return ["titleLabel" : titleLabel, "sliderView" : sliderView]
    }
    
    open override func defaultVisualConstraints() -> [String] {
        return [
            "V:|[titleLabel]|",
            "H:|-16-[titleLabel]-16-[sliderView]-16-|"
        ]
    }
        
    internal func valueChanged(_: UISlider) {
        rowDescriptor.value = sliderView.value as NSObject?
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
