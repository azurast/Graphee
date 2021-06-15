//
//  SettingHelper.swift
//  Graphee
//
//  Created by Luis Genesius on 15/06/21.
//

import Foundation
import UIKit

public class SettingHelper {
    public static let shared = SettingHelper()
    
    private let userDefaults = UserDefaults.standard
    
    private let firstTimeKey = "First Time Key"

    public let torchOff = "Torch Off"
    
    public let timerOff = "Timer Off"
    public let timer3Sec = "Timer 3 Second"
    public let timer10Sec = "Timer 10 Second"
    
    public let ratio11 = "Ratio 1:1"
    public let ratio43 = "Ratio 4:3"
    public let ratio169 = "Ratio 16:9"
    
    public func setFirstTimeAction() {
        if userDefaults.bool(forKey: firstTimeKey) == false {
            userDefaults.setValue(true, forKey: torchOff)
            userDefaults.setValue(true, forKey: ratio43)
            
            userDefaults.setValue(false, forKey: timer3Sec)
            userDefaults.setValue(false, forKey: timer10Sec)
            
            userDefaults.setValue(true, forKey: firstTimeKey)
        }
    }
    
}

// MARK: - Set Torch Function
extension SettingHelper {
    public func setTorchOff() {
        if userDefaults.bool(forKey: torchOff) == false {
            userDefaults.setValue(true, forKey: torchOff)
        } else {
            userDefaults.setValue(false, forKey: torchOff)
        }
    }
    
    public func activateTorch() {
        if userDefaults.bool(forKey: torchOff) == false {
            TorchHelper.shared.toggleTorch(on: true)
        }
    }
    
    public func deactivateTorch() {
        if userDefaults.bool(forKey: torchOff) == true {
            TorchHelper.shared.toggleTorch(on: false)
        }
    }
    
    public func isTorchActivated() -> Bool {
        if userDefaults.bool(forKey: torchOff) == false {
            return true
        }
        else {
            return false
        }
    }
}

// MARK: - Set Timer Function
extension SettingHelper {
    
    public func setTimer3SecOn() -> Bool {
        if userDefaults.bool(forKey: timer3Sec) == false {
            userDefaults.setValue(true, forKey: timer3Sec)
            userDefaults.setValue(false, forKey: timer10Sec)
            
            return true
        }
        else {
            userDefaults.setValue(false, forKey: timer3Sec)
            userDefaults.setValue(false, forKey: timer10Sec)
            
            return false
        }
        
    }
    
    public func setTimer10SecOn() -> Bool {
        if userDefaults.bool(forKey: timer10Sec) == false {
            userDefaults.setValue(true, forKey: timer10Sec)
            userDefaults.setValue(false, forKey: timer3Sec)
            
            return true
        }
        else {
            userDefaults.setValue(false, forKey: timer10Sec)
            userDefaults.setValue(false, forKey: timer3Sec)
            
            return false
        }
        
    }
    
    public func isTimer3SecActivated() -> Bool {
        return userDefaults.bool(forKey: timer3Sec)
    }
    
    public func isTimer10SecActivated() -> Bool {
        return userDefaults.bool(forKey: timer10Sec)
    }
}

// MARK: - Set Ratio Function
extension SettingHelper {
    public func setRatio11() -> Bool {
        if userDefaults.bool(forKey: ratio11) == false {
            userDefaults.setValue(true, forKey: ratio11)
            userDefaults.setValue(false, forKey: ratio43)
            userDefaults.setValue(false, forKey: ratio169)
            
            return true
        }
        
        return false
    }
    
    public func setRatio43() -> Bool {
        if userDefaults.bool(forKey: ratio43) == false {
            userDefaults.setValue(true, forKey: ratio43)
            userDefaults.setValue(false, forKey: ratio11)
            userDefaults.setValue(false, forKey: ratio169)
            
            return true
        }
        
        return false
    }
    
    public func setRatio169() -> Bool {
        if userDefaults.bool(forKey: ratio169) == false {
            userDefaults.setValue(true, forKey: ratio169)
            userDefaults.setValue(false, forKey: ratio11)
            userDefaults.setValue(false, forKey: ratio43)
            
            return true
        }
        
        return false
    }
    
    public func isRatio11Activated() -> Bool {
        return userDefaults.bool(forKey: ratio11)
    }
    
    public func isRatio43Activated() -> Bool {
        return userDefaults.bool(forKey: ratio43)
    }
    
    public func isRatio169Activated() -> Bool {
        return userDefaults.bool(forKey: ratio169)
    }
}
