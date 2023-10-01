//
//  AnimationDetailVC.swift
//  Flipped
//
//  Created by mc309 on 9/30/23.
//

import UIKit
import RealmSwift

class AnimationDetailVC: UIViewController {

    let model: AnimationDetailModel = AnimationDetailModel()
    
    var animation: Animation
    init(animation: Animation) {
        self.animation = animation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
