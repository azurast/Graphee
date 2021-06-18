//
//  FolderCollectionViewCell.swift
//  Graphee
//
//  Created by Luis Genesius on 15/06/21.
//

import UIKit

class FolderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var highlightView: UIView!
    @IBOutlet weak var selectedImageView: UIView!
    
    override var isHighlighted: Bool {
        didSet {
            highlightView.isHidden = !isHighlighted
        }
    }
    
    override var isSelected: Bool {
        didSet {
            highlightView.isHidden = !isSelected
            selectedImageView.isHidden = !isSelected
        }
    }
}
