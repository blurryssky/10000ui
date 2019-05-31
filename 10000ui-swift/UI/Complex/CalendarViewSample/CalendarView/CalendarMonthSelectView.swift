//
//  CalendarMonthSelectView.swift
//  10000ui-swift
//
//  Created by 张亚东 on 20/07/2017.
//  Copyright © 2017 张亚东. All rights reserved.
//

import UIKit

private struct UIConstants {
    static let buttonWidth: CGFloat = 90
}

class CalendarMonthSelectView: UIView {
    
    lazy var monthLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "\(Date().componentFor(.month))" + "月"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var previousMonthButton: UIButton = {
        let pButton: UIButton = UIButton()
        pButton.setTitleColor(UIColor.black, for: .normal)
        pButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        pButton.setImage(#imageLiteral(resourceName: "calendar_arrow_left"), for: .normal)
        pButton.addTarget(self, action: #selector(handlePreviousMonthButton(_:)), for: .touchUpInside)
        return pButton
    }()
    
    lazy var nextMonthButton: UIButton = {
        let nButton: UIButton = UIButton()
        nButton.setTitleColor(UIColor.black, for: .normal)
        nButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        nButton.setImage(#imageLiteral(resourceName: "calendar_arrow_right"), for: .normal)
        nButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)
        nButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIConstants.buttonWidth - 50 - 5)
        
        nButton.addTarget(self, action: #selector(handleNextMonthButton(_:)), for: .touchUpInside)
        return nButton
    }()
    
    var preference: CalendarPreference! {
        didSet {
            monthLabel.textColor = preference.tintColor
            updateFrame()
        }
    }
    
    var previousMonthButtonClosure: (()->Void)?
    var nextMonthButtonClosure: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateFrame()
    }
}

extension CalendarMonthSelectView {
    
    func update(month: CalendarMonth) {
        let displayingMonth = month.date.componentFor(.month)
        monthLabel.text = "\(displayingMonth)月"
        
        previousMonthButton.isHidden = displayingMonth == preference.monthSelectRange.lowerBound
        nextMonthButton.isHidden = displayingMonth == preference.monthSelectRange.upperBound
        
        previousMonthButton.setTitle("\(displayingMonth - 1)月", for: .normal)
        nextMonthButton.setTitle("\(displayingMonth + 1)月", for: .normal)
    }
}

fileprivate extension CalendarMonthSelectView {
    
    func setupSubviews() {
        addSubview(monthLabel)
        addSubview(previousMonthButton)
        addSubview(nextMonthButton)
    }
    
    func updateFrame() {
        monthLabel.frame = CGRect(origin: .zero, size: .init(width: bs.width, height: preference.monthSelectRowHeight))
        previousMonthButton.frame = CGRect(origin: .zero, size: .init(width: UIConstants.buttonWidth, height: preference.monthSelectRowHeight))
        nextMonthButton.frame = CGRect(origin: .init(x: bs.width - UIConstants.buttonWidth, y: 0), size: previousMonthButton.bs.size)
    }
    
    @objc func handlePreviousMonthButton(_ button: UIButton) {
        previousMonthButtonClosure?()
    }
    
    @objc func handleNextMonthButton(_ button: UIButton) {
        nextMonthButtonClosure?()
    }
}
