//
//  MakeAnimationVC.swift
//  Flipped
//
//  Created by mc309 on 10/3/23.
//

import UIKit
import RealmSwift

class MakeAnimationVC: UIViewController {

    var images: [UIImage]
    init(images: [UIImage]) {
        self.images = images
        super.init(nibName: nil, bundle: nil)
    }
    
    lazy var imageView: UIImageView = {
        let v = UIImageView()
        v.animationImages = images
        v.backgroundColor = .white
        v.animationDuration = 1.0
        v.animationRepeatCount = 0
        return v
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageView.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        imageView.stopAnimating()
    }

}
