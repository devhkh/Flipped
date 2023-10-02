//
//  AnimationListModel.swift
//  Flipped
//
//  Created by mc309 on 9/30/23.
//

import UIKit
import RealmSwift

protocol AnimationListModelDelegate: AnyObject {
    func refreshAnimations(results: Results<Animation>, del: [Int], ins: [Int], mod: [Int])
}

class AnimationListModel: NSObject {
    
    deinit {
        print("deinit - " + theClassName)
        animationToken.invalidate()
    }
    
    weak open var delegate: AnimationListModelDelegate?
    
    let realm = DBManager.SI.realm!

    lazy var animations: Results<Animation> = {
        let results = realm.objects(Animation.self).sorted(byKeyPath: "createdAt")
        return results
    }()
    
    //MARK: Realm NotificationToken
    lazy var animationToken: NotificationToken = {
        return animations.observe { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .update(let results, let del, let ins, let mod): 
                self.delegate?.refreshAnimations(results: results, del: del, ins: ins, mod: mod)
                
            default:
                break
            }
        }
    }()
    
    func prepare() {
        _ = animationToken
    }
    
    func addAnimation() {
        let newAnimation = Animation()
        newAnimation.title = "example"
        try! self.realm.write() {
            self.realm.add(newAnimation)
        }
    }
    
}
