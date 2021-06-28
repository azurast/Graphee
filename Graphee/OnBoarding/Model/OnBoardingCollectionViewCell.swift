//
//  OnBoardingCollectionViewCell.swift
//  Graphee
//
//  Created by Dzaki Izza on 25/06/21.
//

import UIKit

class OnBoardingCollectionViewCell: UICollectionViewCell {
        
        @IBOutlet weak var illustrastionImages: UIImageView!
        @IBOutlet weak var titleText: UILabel!
        @IBOutlet weak var descText: UILabel!
            
        func setup (_ slide : onBoardingSlides) {
            
            illustrastionImages.image = slide.imageIllustration
            titleText.text = slide.titleText
            descText.text = slide.descText

        }

    }


