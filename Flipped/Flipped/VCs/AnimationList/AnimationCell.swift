//
//  AnimationCell.swift
//  Flipped
//
//  Created by mc309 on 9/30/23.
//

import UIKit
import SnapKit

class AnimationCell: UICollectionViewCell, ReusableView {
    lazy var labelBackView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    lazy var label: UILabel = {
        let v = UILabel()
        v.backgroundColor = .blue
        v.font = UIFont.systemFont(ofSize: 14)
        v.textAlignment = .left
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(labelBackView)
        labelBackView.addSubview(label)
        
        labelBackView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(label).offset(10)
            make.height.equalTo(22)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(labelBackView)
            make.left.equalTo(labelBackView).offset(10)
            make.right.equalTo(labelBackView).offset(-10)
            make.bottom.equalTo(labelBackView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
