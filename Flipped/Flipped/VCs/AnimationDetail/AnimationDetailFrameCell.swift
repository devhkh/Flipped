//
//  AnimationDetailFrameCell.swift
//  Flipped
//
//  Created by mc309 on 10/1/23.
//

import UIKit

class AnimationDetailFrameCell: UICollectionViewCell, ReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cornerRadius = 8
        backgroundColor = .black
        
        let selectedView = UIView()
        let selectedBackView = UIView()
        selectedView.addSubview(selectedBackView)
        selectedBackView.snp.makeConstraints { (make) in
            make.edges.equalTo(selectedView)
        }
        selectedBackView.backgroundColor = .clear
        selectedBackView.borderColor = .red
        selectedBackView.alpha = 0.6
        selectedBackView.borderWidth = 2
        selectedBackView.cornerRadius = 8
        selectedBackgroundView = selectedView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
