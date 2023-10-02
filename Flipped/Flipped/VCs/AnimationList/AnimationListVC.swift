//
//  ViewController.swift
//  Flipped
//
//  Created by mc309 on 9/30/23.
//

import UIKit
import SnapKit
import RealmSwift

let kAnimationListItemSize = CGSize(width: floor((k320 - (24+12+12+24))/3), height: 180)

class AnimationListVC: UIViewController {

    let model: AnimationListModel = AnimationListModel()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.itemSize = kAnimationListItemSize
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.register(AnimationCell.self, forCellWithReuseIdentifier: AnimationCell.reuseIdentifier)
        v.backgroundColor = .white
        v.delegate = self
        v.dataSource = self
        return v
    }()
    
    lazy var addButton: UIButton = {
        let v = UIButton(type: .contactAdd)
        return v
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        model.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        title = "Animation List"
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: addButton)]
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
        model.prepare()
    }
    
    @objc func addButtonPressed() {
        model.addAnimation()
    }
}

extension AnimationListVC: AnimationListModelDelegate {

    func refreshAnimations(results: Results<Animation>, del: [Int], ins: [Int], mod: [Int]) {
        collectionView.reloadData()
    }
    
}

extension AnimationListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let animation = model.animations[indexPath.row]
        print(animation.id)
        let animationDetailVC: AnimationDetailVC = AnimationDetailVC(animation: animation)
        let animationDetailNavi = UINavigationController(rootViewController: animationDetailVC)
        animationDetailNavi.modalPresentationStyle = .fullScreen
        present(animationDetailNavi, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAt indexPath: IndexPath) -> CGSize {
       return kAnimationListItemSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.animations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as AnimationCell
        cell.backgroundColor = .black
        return cell
    }
}

