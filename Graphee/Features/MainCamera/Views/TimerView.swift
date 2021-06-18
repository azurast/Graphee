//
//  TimerView.swift
//  Graphee
//
//  Created by Luis Genesius on 15/06/21.
//

import UIKit

class TimerView: UIView {

    private var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 90, weight: .heavy)
        addSubview(label)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    public func changeLabelText(number: String) {
        label.text = number
    }
    
}
