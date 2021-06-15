//
//  VeryTopView.swift
//  Graphee
//
//  Created by Luis Genesius on 15/06/21.
//

import Foundation
import UIKit

protocol VeryTopViewDelegate: AnyObject {
    func doneButtonTapped()
    func cancelButtonTapped()
}

class VeryTopView: UIView {
    
    public var delegate: VeryTopViewDelegate?
    
    private var torchImageView: UIImageView!
    private var timerImageView: UIImageView!
    
    private var cancelButton: UIButton!
    private var doneButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        createButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func createButton() {
        cancelButton = UIButton(frame: CGRect(x: 30, y: frame.height / 2 - 15, width: 60, height: 30))
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonSelector), for: .touchUpInside)
        addSubview(cancelButton)
        
        doneButton = UIButton(frame: CGRect(x: frame.width - 30 - 50, y: frame.height / 2 - 15, width: 50, height: 30))
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.yellow, for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonSelector), for: .touchUpInside)
        addSubview(doneButton)
        
    }
    
    public func createImage() {
        torchImageView = UIImageView(frame: CGRect(x: frame.width / 2 - (frame.height / 2) / 2 - (frame.height / 2), y: frame.height / 2 - (frame.height / 2) / 2, width: frame.height / 2, height: frame.height / 2))
        torchImageView!.image = UIImage(systemName: "lightbulb")
        torchImageView!.contentMode = .scaleAspectFill
        addSubview(torchImageView!)
        
        timerImageView = UIImageView(frame: CGRect(x: frame.width / 2 - (frame.height / 2) / 2 + (frame.height / 2), y: frame.height / 2 - (frame.height / 2) / 2, width: frame.height / 2, height: frame.height / 2))
        timerImageView!.image = UIImage(systemName: "timer")
        timerImageView!.contentMode = .scaleAspectFill
        addSubview(timerImageView!)
        
    }
    
    public func unhideDoneButton() {
        doneButton.isHidden = false
    }
    
    public func hideDoneButton() {
        doneButton.isHidden = false
    }
    
    @objc private func cancelButtonSelector() {
        delegate?.cancelButtonTapped()
    }
    
    @objc private func doneButtonSelector() {
        delegate?.doneButtonTapped()
    }
    
    public func changeTorchColorActivated() {
        torchImageView!.tintColor = .green
    }
    
    public func changeTorchColorDeactivated() {
        torchImageView!.tintColor = #colorLiteral(red: 0.1568627451, green: 0.1411764706, blue: 0.1411764706, alpha: 1)
    }
    
    public func changeTimerColorActivated() {
        timerImageView!.tintColor = .green
    }
    
    public func changeTimerColorDeactivated() {
        timerImageView!.tintColor = #colorLiteral(red: 0.1568627451, green: 0.1411764706, blue: 0.1411764706, alpha: 1)
    }
}
