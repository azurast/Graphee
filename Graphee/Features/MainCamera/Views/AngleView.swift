//
//  AngleView.swift
//  Graphee
//
//  Created by Luis Genesius on 15/06/21.
//

import UIKit

class AngleView: UIView {
    
    private var leftVerticalLine: UIView!
    private var rightVerticalLine: UIView!
    private var highAngleHorizontalLine: UIView!
    private var leftLowAngleHorizontalLine: UIView!
    private var rightLowAngleHorizontalLine: UIView!
    private var middleGyroHorizontalLine: UIView!
    
    private var mainAngleHorizontalLine: UIView!
    
    private var originTransform: CGAffineTransform?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customInit() {
        let columnWidth = frame.width / 3
        
        leftVerticalLine = UIView(frame: CGRect(x: columnWidth, y: 0, width: 1, height: frame.height))
        leftVerticalLine.backgroundColor = .darkGray
        addSubview(leftVerticalLine)
        
        rightVerticalLine = UIView(frame: CGRect(x: frame.width - columnWidth, y: 0, width: 1, height: frame.height))
        rightVerticalLine.backgroundColor = .darkGray
        addSubview(rightVerticalLine)
        
        let rowHeight = frame.height / 3
        
        highAngleHorizontalLine = UIView(frame: CGRect(x: 0, y: rowHeight, width: frame.width, height: 1))
        highAngleHorizontalLine.backgroundColor = .darkGray
        addSubview(highAngleHorizontalLine)
        
        leftLowAngleHorizontalLine = UIView(frame: CGRect(x: 0, y: frame.height - rowHeight, width: columnWidth, height: 1))
        leftLowAngleHorizontalLine.backgroundColor = .darkGray
        addSubview(leftLowAngleHorizontalLine)
        
        rightLowAngleHorizontalLine = UIView(frame: CGRect(x: frame.width - columnWidth, y: frame.height - rowHeight, width: columnWidth, height: 1))
        rightLowAngleHorizontalLine.backgroundColor = .darkGray
        addSubview(rightLowAngleHorizontalLine)
        
        
        let middleGyroWidth = frame.width - (columnWidth * 2) - 2
        middleGyroHorizontalLine = UIView(frame: CGRect(x: columnWidth + 1, y: frame.height - rowHeight, width: middleGyroWidth, height: 3))
        middleGyroHorizontalLine.backgroundColor = .yellow
        addSubview(middleGyroHorizontalLine)
        
        mainAngleHorizontalLine = UIView(frame: CGRect(x: 0, y: frame.height / 2, width: frame.width, height: 3))
        mainAngleHorizontalLine.backgroundColor = .yellow
        addSubview(mainAngleHorizontalLine)
        
        originTransform = middleGyroHorizontalLine.transform
    }
    
    public func updateMainHorizontalLine(gravityZ: Double, completion: @escaping (String, UIColor) -> (Void)) {
        let onePoint = (frame.height / 2) / 99
        
        mainAngleHorizontalLine.frame.origin.y = CGFloat(((Double(frame.height) / 2.0) - gravityZ * Double(onePoint)))
        
        if mainAngleHorizontalLine.frame.origin.y < highAngleHorizontalLine.frame.origin.y {
            completion("Phone in High Angle", .lightGray)
        } else if mainAngleHorizontalLine.frame.origin.y > leftLowAngleHorizontalLine.frame.origin.y {
            completion("Phone in Low Angle", .lightGray)
        } else {
            completion("Perfect Leveling", .yellow)
        }
    }
    
    public func updateGyroHorizontalLine(angle: CGFloat) {
        guard let transform = originTransform else { return }
        
        middleGyroHorizontalLine.rotate(angle: angle, transform: transform)
    }
}
