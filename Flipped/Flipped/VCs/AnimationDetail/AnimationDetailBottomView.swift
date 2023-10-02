//
//  AnimationDetailBottomView.swift
//  Flipped
//
//  Created by mc309 on 10/1/23.
//

import UIKit

class AnimationDetailBottomView: UIView {

    lazy var frameCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = kAnimationDetailFrameItemSize
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.register(AnimationDetailFrameCell.self, forCellWithReuseIdentifier: AnimationDetailFrameCell.reuseIdentifier)
        v.backgroundColor = .white
        return v
    }()
    
    lazy var addFrameButton: UIButton = {
        let v = UIButton(type: .contactAdd)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(frameCollectionView)
        addSubview(addFrameButton)
        
        frameCollectionView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(16)
            make.right.equalTo(addFrameButton.snp.left).offset(-8)
            make.centerY.equalTo(self)
            make.height.equalTo(60)
        }
        
        addFrameButton.snp.makeConstraints { make in
            make.right.equalTo(self).offset(-16)
            make.centerY.equalTo(self)
            make.size.equalTo(44)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
