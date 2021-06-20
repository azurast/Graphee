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
        ratio11Button = UIButton(frame: CGRect(x: (frame.width / 2) / 2 - ((64) / 2) - ((64) / 2), y: frame.height - (rowHeight / 2) - (64 / 2), width: 64, height: 64))
        ratio11Button.setBackgroundImage(UIImage(named: "ratio11"), for: .normal)
        ratio11Button.addTarget(self, action: #selector(ratioButtonSelector(sender:)), for: .touchUpInside)
        addSubview(ratio11Button)
        
        ratio43Button = UIButton(frame: CGRect(x: frame.width / 2 - ((64) / 2), y: frame.height - (rowHeight / 2) - ((64) / 2), width: 64, height: 64))
        ratio43Button.setBackgroundImage(UIImage(named: "ratio43"), for: .normal)
        ratio43Button.addTarget(self, action: #selector(ratioButtonSelector(sender:)), for: .touchUpInside)
        addSubview(ratio43Button)
        
        ratio169Button = UIButton(frame: CGRect(x: frame.width - ((frame.width / 2) / 2 - ((64) / 2) + ((64) / 2)), y: frame.height - (rowHeight / 2) - ((64) / 2), width: 64, height: 64))
        ratio169Button.setBackgroundImage(UIImage(named: "ratio169"), for: .normal)
        ratio169Button.addTarget(self, action: #selector(ratioButtonSelector(sender:)), for: .touchUpInside)
        addSubview(ratio169Button)
        
        if SettingHelper.shared.isRatio11Activated() {
            ratio11Button.setBackgroundImage(UIImage(named: "ratio11_selected"), for: .normal)
        } else if SettingHelper.shared.isRatio43Activated() {
            ratio43Button.setBackgroundImage(UIImage(named: "ratio43_selected"), for: .normal)
        } else if SettingHelper.shared.isRatio169Activated() {
            ratio169Button.setBackgroundImage(UIImage(named: "ratio169_selected"), for: .normal)
        }
    }
    
    private func initTimerButtons(rowHeight: CGFloat) {
        timer3SecButton = UIButton(frame: CGRect(x: (frame.width / 2) / 2 - (64) / 2, y: frame.height - rowHeight - (rowHeight / 2) - ((64) / 2), width: 64, height: 64))
        timer3SecButton.setBackgroundImage(UIImage(named: "timer3"), for: .normal)
        
        if SettingHelper.shared.isTimer3SecActivated() {
            timer3SecButton.setBackgroundImage(UIImage(named: "timer3_selected"), for: .normal)
        }
        else {
            timer3SecButton.setBackgroundImage(UIImage(named: "timer3"), for: .normal)
        }
        
        timer3SecButton.addTarget(self, action: #selector(timerButtonSelector(sender:)), for: .touchUpInside)
        addSubview(timer3SecButton)
        
        timer10SecButton = UIButton(frame: CGRect(x: frame.width - (frame.width / 2) / 2 - (64) / 2, y: frame.height - rowHeight - (rowHeight / 2) - ((64) / 2), width: 64, height: 64))
        timer10SecButton.setBackgroundImage(UIImage(named: "timer10"), for: .normal)
        
        if SettingHelper.shared.isTimer10SecActivated() {
            timer10SecButton.setBackgroundImage(UIImage(named: "timer10_selected"), for: .normal)
        }
        else {
            timer10SecButton.setBackgroundImage(UIImage(named: "timer10"), for: .normal)
        }
        
        timer10SecButton.addTarget(self, action: #selector(timerButtonSelector(sender:)), for: .touchUpInside)
        addSubview(timer10SecButton)
        
    }
    
    private func initTorchButtons(rowHeight: CGFloat) {
        torchButton = UIButton(frame: CGRect(x: frame.width / 2 - ((64) / 2), y: frame.height - rowHeight * 2 - (rowHeight / 2) - ((64) / 2), width: 64, height: 64))
        
        if SettingHelper.shared.isTorchActivated() {
            torchButton.tintColor = .yellow
            torchButton.setBackgroundImage(UIImage(systemName: "bolt.fill"), for: .normal)
        } else {
            torchButton.tintColor = .white
            torchButton.setBackgroundImage(UIImage(systemName: "bolt"), for: .normal)
        }

        torchButton.addTarget(self, action: #selector(torchButtonSelector(sender:)), for: .touchUpInside)
        addSubview(torchButton)
        
    }
    
    @objc private func torchButtonSelector(sender: UIButton) {
        SettingHelper.shared.setTorchOff()
        
        if SettingHelper.shared.isTorchActivated() {
            torchButton.tintColor = .yellow
            torchButton.setBackgroundImage(UIImage(systemName: "bolt.fill"), for: .normal)
            delegate?.setTorchImageActivate()
        }
        else {
            torchButton.tintColor = .white
            torchButton.setBackgroundImage(UIImage(systemName: "bolt"), for: .normal)
            delegate?.setTorchImageActivate()
        }
        
    }
    
    @objc private func timerButtonSelector(sender: UIButton) {
        
        if sender == timer3SecButton {
            if SettingHelper.shared.setTimer3SecOn() {
                timer3SecButton.setBackgroundImage(UIImage(named: "timer3_selected"), for: .normal)
                timer10SecButton.setBackgroundImage(UIImage(named: "timer10"), for: .normal)
            }
            else {
                timer3SecButton.setBackgroundImage(UIImage(named: "timer3"), for: .normal)
                timer10SecButton.setBackgroundImage(UIImage(named: "timer10"), for: .normal)
            }
            
            delegate?.setTimerImageActivate()
        }
        else if sender == timer10SecButton {
            if SettingHelper.shared.setTimer10SecOn() {
                timer3SecButton.setBackgroundImage(UIImage(named: "timer3"), for: .normal)
                timer10SecButton.setBackgroundImage(UIImage(named: "timer10_selected"), for: .normal)
            }
            else {
                timer3SecButton.setBackgroundImage(UIImage(named: "timer3"), for: .normal)
                timer10SecButton.setBackgroundImage(UIImage(named: "timer10"), for: .normal)
            }
            
            delegate?.setTimerImageActivate()
        }
    }
    
    @objc private func ratioButtonSelector(sender: UIButton) {
        ratio11Button.setBackgroundImage(UIImage(named: "ratio11"), for: .normal)
        ratio43Button.setBackgroundImage(UIImage(named: "ratio43"), for: .normal)
        ratio169Button.setBackgroundImage(UIImage(named: "ratio169"), for: .normal)
        
        if sender == ratio11Button {
            ratio11Button.setBackgroundImage(UIImage(named: "ratio11_selected"), for: .normal)
            if SettingHelper.shared.setRatio11() {
                delegate?.setRatioActivate()
            }
        }
        else if sender == ratio43Button {
            ratio43Button.setBackgroundImage(UIImage(named: "ratio43_selected"), for: .normal)
            if SettingHelper.shared.setRatio43() {
                delegate?.setRatioActivate()
            }
        }
        else if sender == ratio169Button {
            ratio169Button.setBackgroundImage(UIImage(named: "ratio169_selected"), for: .normal)
            if SettingHelper.shared.setRatio169() {
                delegate?.setRatioActivate()
            }
        }
    }
    
}
