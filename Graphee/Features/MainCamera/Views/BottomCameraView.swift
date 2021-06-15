//
//  BottomCameraView.swift
//  Graphee
//
//  Created by Luis Genesius on 15/06/21.
//

import UIKit

protocol DirectionButtonDelegate: AnyObject {
    func directionButtonTapped(direction: Direction)
}

protocol MainButtonDelegate: AnyObject {
    func mainButtonTapped()
    func settingButtonTapped()
    func referencePointButtonTapped()
}

protocol PreviewButtonDelegate: AnyObject {
    func previewRetakeButtonTapped()
    func previewDoneButtonTapped()
}

class BottomCameraView: UIView {

    weak var mainButtonDelegate: MainButtonDelegate?
    weak var directionButtonDelegate: DirectionButtonDelegate?
    weak var previewButtonDelegate: PreviewButtonDelegate?
    
    private var shutterButton: UIButton!
    private var settingButton: UIButton!
    private var referencePointButton: UIButton!
    
    private var retakeButton: UIButton!
    private var doneButton: UIButton!
    
    private var frontButton: UIButton!
    private var backButton: UIButton!
    private var rightButton: UIButton!
    private var leftButton: UIButton!
    private var detailButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    public func createMainButton() {
        initMainButton()
    }
    
    public func createPreviewButton() {
        initPreviewButton()
    }
    
    public func createDirectionButton() {
        initDirectionButton()
    }
    
    private func initMainButton() {
        shutterButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        shutterButton.layer.cornerRadius = 35
        shutterButton.layer.borderWidth = 10
        shutterButton.layer.borderColor = UIColor.white.cgColor
        shutterButton.addTarget(self, action: #selector(mainButtonSelector), for: .touchUpInside)
        addSubview(shutterButton)
        shutterButton.center = CGPoint(x: frame.size.width / 2, y: frame.size.height - 35)
        
        settingButton = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        settingButton.layer.cornerRadius = 17
        settingButton.layer.borderWidth = 10
        settingButton.addTarget(self, action: #selector(settingButtonSelector), for: .touchUpInside)
        settingButton.backgroundColor = .white
        addSubview(settingButton)
        settingButton.center = CGPoint(x: (frame.size.width / 2) / 2, y: frame.size.height - shutterButton.frame.size.height / 2)
        
        referencePointButton = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        referencePointButton.layer.cornerRadius = 17
        referencePointButton.layer.borderWidth = 10
        referencePointButton.addTarget(self, action: #selector(referencePointButtonSelector), for: .touchUpInside)
        referencePointButton.backgroundColor = .white
        addSubview(referencePointButton)
        referencePointButton.center = CGPoint(x: frame.width - (frame.size.width / 2) / 2, y: frame.size.height - shutterButton.frame.size.height / 2)
    }
    
    private func initPreviewButton() {
        retakeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        retakeButton.setTitle("Retake", for: .normal)
        retakeButton.setTitleColor(.white, for: .normal)
        retakeButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        addSubview(retakeButton)
        retakeButton.center = CGPoint(x: (frame.size.width / 2) / 2, y: frame.size.height / 2)
        retakeButton.addTarget(self, action: #selector(retakeButtonSelector), for: .touchUpInside)
        
        doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.yellow, for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        addSubview(doneButton)
        doneButton.center = CGPoint(x: frame.size.width - (frame.size.width / 2) / 2, y: frame.size.height / 2)
        doneButton.addTarget(self, action: #selector(doneButtonSelector), for: .touchUpInside)
    }
    
    private func initDirectionButton() {
        let spaceBetweenButton = (frame.width - (50 * 5)) / 6
        
        frontButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        frontButton.setTitle("Front", for: .normal)
        frontButton.addTarget(self, action: #selector(directionButtonSelector(sender:)), for: .touchUpInside)
        addSubview(frontButton)
        frontButton.center = CGPoint(x: spaceBetweenButton + (frontButton.frame.width / 2), y: 20)
        
        backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(directionButtonSelector(sender:)), for: .touchUpInside)
        addSubview(backButton)
        backButton.center = CGPoint(x: spaceBetweenButton * 2 + frontButton.frame.width + (backButton.frame.width / 2), y: 20)
        
        rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        rightButton.setTitle("Right", for: .normal)
        rightButton.addTarget(self, action: #selector(directionButtonSelector(sender:)), for: .touchUpInside)
        addSubview(rightButton)
        rightButton.center = CGPoint(x: spaceBetweenButton * 3 + frontButton.frame.width + backButton.frame.width + (rightButton.frame.width / 2), y: 20)
        
        leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        leftButton.setTitle("Left", for: .normal)
        leftButton.addTarget(self, action: #selector(directionButtonSelector(sender:)), for: .touchUpInside)
        addSubview(leftButton)
        leftButton.center = CGPoint(x: spaceBetweenButton * 4 + frontButton.frame.width + backButton.frame.width + leftButton.frame.width + (leftButton.frame.width / 2), y: 20)
        
        detailButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        detailButton.setTitle("Detail", for: .normal)
        detailButton.addTarget(self, action: #selector(directionButtonSelector(sender:)), for: .touchUpInside)
        addSubview(detailButton)
        detailButton.center = CGPoint(x: spaceBetweenButton * 5 + frontButton.frame.width + backButton.frame.width + leftButton.frame.width + rightButton.frame.width + (detailButton.frame.width / 2), y: 20)
        
        setButtonYellow()
    }
    
    public func setButtonYellow() {
        frontButton.setTitleColor(.white, for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        rightButton.setTitleColor(.white, for: .normal)
        leftButton.setTitleColor(.white, for: .normal)
        detailButton.setTitleColor(.white, for: .normal)
        
        switch CameraImages.shared.getNextDirectionInDirection() {
        case .front:
            frontButton.setTitleColor(.yellow, for: .normal)
        case .back:
            backButton.setTitleColor(.yellow, for: .normal)
        case .right:
            rightButton.setTitleColor(.yellow, for: .normal)
        case .left:
            leftButton.setTitleColor(.yellow, for: .normal)
        case .detail:
            detailButton.setTitleColor(.yellow, for: .normal)
        }
    }
    
    public func hideDoneButton() {
        doneButton.isHidden = true
    }
    
    @objc private func mainButtonSelector() {
        mainButtonDelegate?.mainButtonTapped()
    }
    
    @objc private func settingButtonSelector() {
        mainButtonDelegate?.settingButtonTapped()
    }
    
    @objc private func referencePointButtonSelector() {
        mainButtonDelegate?.referencePointButtonTapped()
    }
    
    @objc private func retakeButtonSelector() {
        previewButtonDelegate?.previewRetakeButtonTapped()
    }
    
    @objc private func doneButtonSelector() {
        previewButtonDelegate?.previewDoneButtonTapped()
    }
    
    @objc private func directionButtonSelector(sender: UIButton) {
        var direction: Direction
        
        frontButton.setTitleColor(.white, for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        rightButton.setTitleColor(.white, for: .normal)
        leftButton.setTitleColor(.white, for: .normal)
        detailButton.setTitleColor(.white, for: .normal)
        
        if sender == frontButton {
            direction = .front
            frontButton.setTitleColor(.yellow, for: .normal)

        } else if sender == backButton {
            direction = .back
            backButton.setTitleColor(.yellow, for: .normal)
            
        } else if sender == rightButton {
            direction = .right
            rightButton.setTitleColor(.yellow, for: .normal)
            
        } else if sender == leftButton {
            direction = .left
            leftButton.setTitleColor(.yellow, for: .normal)
            
        } else {
            direction = .detail
            detailButton.setTitleColor(.yellow, for: .normal)
            
        }
        
        directionButtonDelegate?.directionButtonTapped(direction: direction)
    }
    
}
