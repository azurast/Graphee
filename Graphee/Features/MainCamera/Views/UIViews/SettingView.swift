//
//  SettingView.swift
//  Graphee
//
//  Created by Luis Genesius on 15/06/21.
//

import Foundation
import UIKit
import AVFoundation

protocol SettingViewDelegate: AnyObject {
    func setTorchImageActivate()
    func setTimerImageActivate()
    func setRatioActivate()
}

class SettingView: UIView {
    
    weak var delegate: SettingViewDelegate?

    private var topHorizontalLine: UIView!
    private var middleHorizontalLine: UIView!
    private var bottomHorizontalLine: UIView!
    
    private var torchButton: UIButton!

    private var timer3SecButton: UIButton!
    private var timer10SecButton: UIButton!
    
    private var ratio11Button: UIButton!
    private var ratio43Button: UIButton!
    private var ratio169Button: UIButton!
    
    private var gridButton: UIButton!
    private var goldenRatioButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
        
    }

    private func customInit() {
        
        let rowHeight = frame.height / 3
        
        initLine(rowHeight: rowHeight)
        initTorchButtons(rowHeight: rowHeight)
        initTimerButtons(rowHeight: rowHeight)
        initRatioButtons(rowHeight: rowHeight)
    }
    
    private func initLine(rowHeight: CGFloat) {
        topHorizontalLine = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 1))
        topHorizontalLine.backgroundColor = .white
        addSubview(topHorizontalLine)
        
        middleHorizontalLine = UIView(frame: CGRect(x: 0, y: rowHeight, width: frame.width, height: 1))
        middleHorizontalLine.backgroundColor = .white
        addSubview(middleHorizontalLine)
        
        bottomHorizontalLine = UIView(frame: CGRect(x: 0, y: frame.height - rowHeight, width: frame.width, height: 1))
        bottomHorizontalLine.backgroundColor = .white
        addSubview(bottomHorizontalLine)
        
    }
    
    private func initRatioButtons(rowHeight: CGFloat) {
        ratio11Button = UIButton(frame: CGRect(x: (frame.width / 2) / 2 - ((rowHeight / 2) / 2) - ((rowHeight / 2) / 2), y: frame.height - (rowHeight / 2) - ((rowHeight / 2) / 2), width: rowHeight / 2, height: rowHeight / 2))
        ratio11Button.setBackgroundImage(UIImage(systemName: "aspectratio"), for: .normal)
        ratio11Button.backgroundColor = .magenta
        ratio11Button.addTarget(self, action: #selector(ratioButtonSelector(sender:)), for: .touchUpInside)
        addSubview(ratio11Button)
        
        ratio43Button = UIButton(frame: CGRect(x: frame.width / 2 - ((rowHeight / 2) / 2), y: frame.height - (rowHeight / 2) - ((rowHeight / 2) / 2), width: rowHeight / 2, height: rowHeight / 2))
        ratio43Button.setBackgroundImage(UIImage(systemName: "aspectratio"), for: .normal)
        ratio43Button.backgroundColor = .orange
        ratio43Button.addTarget(self, action: #selector(ratioButtonSelector(sender:)), for: .touchUpInside)
        addSubview(ratio43Button)
        
        ratio169Button = UIButton(frame: CGRect(x: frame.width - ((frame.width / 2) / 2 - ((rowHeight / 2) / 2) + ((rowHeight / 2) / 2)), y: frame.height - (rowHeight / 2) - ((rowHeight / 2) / 2), width: rowHeight / 2, height: rowHeight / 2))
        ratio169Button.setBackgroundImage(UIImage(systemName: "aspectratio"), for: .normal)
        ratio169Button.backgroundColor = .purple
        ratio169Button.addTarget(self, action: #selector(ratioButtonSelector(sender:)), for: .touchUpInside)
        addSubview(ratio169Button)
    }
    
    private func initTimerButtons(rowHeight: CGFloat) {
        timer3SecButton = UIButton(frame: CGRect(x: (frame.width / 2) / 2 - (rowHeight / 2) / 2, y: frame.height - rowHeight - (rowHeight / 2) - ((rowHeight / 2) / 2), width: rowHeight / 2, height: rowHeight / 2))
        timer3SecButton.setBackgroundImage(UIImage(systemName: "timer"), for: .normal)
        
        if SettingHelper.shared.isTimer3SecActivated() {
            timer3SecButton.backgroundColor = .green
        }
        else {
            timer3SecButton.backgroundColor = .red
        }
        
        timer3SecButton.addTarget(self, action: #selector(timerButtonSelector(sender:)), for: .touchUpInside)
        addSubview(timer3SecButton)
        
        timer10SecButton = UIButton(frame: CGRect(x: frame.width - (frame.width / 2) / 2 - (rowHeight / 2) / 2, y: frame.height - rowHeight - (rowHeight / 2) - ((rowHeight / 2) / 2), width: rowHeight / 2, height: rowHeight / 2))
        timer10SecButton.setBackgroundImage(UIImage(systemName: "timer"), for: .normal)
        
        if SettingHelper.shared.isTimer10SecActivated() {
            timer10SecButton.backgroundColor = .green
        }
        else {
            timer10SecButton.backgroundColor = .red
        }
        
        timer10SecButton.addTarget(self, action: #selector(timerButtonSelector(sender:)), for: .touchUpInside)
        addSubview(timer10SecButton)
        
    }
    
    private func initTorchButtons(rowHeight: CGFloat) {
        torchButton = UIButton(frame: CGRect(x: frame.width / 2 - ((rowHeight / 2) / 2), y: frame.height - rowHeight * 2 - (rowHeight / 2) - ((rowHeight / 2) / 2), width: rowHeight / 2, height: rowHeight / 2))
        torchButton.setBackgroundImage(UIImage(systemName: "lightbulb"), for: .normal)
        
        if SettingHelper.shared.isTorchActivated() {
            torchButton.backgroundColor = .green
        }
        else {
            torchButton.backgroundColor = .red
        }
    
        torchButton.addTarget(self, action: #selector(torchButtonSelector(sender:)), for: .touchUpInside)
        addSubview(torchButton)
        
    }
    
    @objc private func torchButtonSelector(sender: UIButton) {
        SettingHelper.shared.setTorchOff()
        
        if SettingHelper.shared.isTorchActivated() {
            torchButton.backgroundColor = .green
            delegate?.setTorchImageActivate()
        }
        else {
            torchButton.backgroundColor = .red
            delegate?.setTorchImageActivate()
        }
        
    }
    
    @objc private func timerButtonSelector(sender: UIButton) {
        if sender == timer3SecButton {
            if SettingHelper.shared.setTimer3SecOn() {
                timer3SecButton.backgroundColor = .green
                timer10SecButton.backgroundColor = .red
            }
            else {
                timer3SecButton.backgroundColor = .red
                timer10SecButton.backgroundColor = .red
            }
            
            delegate?.setTimerImageActivate()
        }
        else if sender == timer10SecButton {
            if SettingHelper.shared.setTimer10SecOn() {
                timer10SecButton.backgroundColor = .green
                timer3SecButton.backgroundColor = .red
            }
            else {
                timer10SecButton.backgroundColor = .red
                timer3SecButton.backgroundColor = .red
            }
            
            delegate?.setTimerImageActivate()
        }
    }
    
    @objc private func ratioButtonSelector(sender: UIButton) {
        if sender == ratio11Button {
            if SettingHelper.shared.setRatio11() {
                delegate?.setRatioActivate()
            }
        }
        else if sender == ratio43Button {
            if SettingHelper.shared.setRatio43() {
                delegate?.setRatioActivate()
            }
        }
        else if sender == ratio169Button {
            if SettingHelper.shared.setRatio169() {
                delegate?.setRatioActivate()
            }
        }
    }
    
}
