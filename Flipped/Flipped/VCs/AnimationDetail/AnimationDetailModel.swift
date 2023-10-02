//
//  AnimationDetailModel.swift
//  Flipped
//
//  Created by mc309 on 9/30/23.
//

import UIKit
import RealmSwift

protocol AnimationDetailModelDelegate: AnyObject {
    func refreshFrames(results: Results<Frame>, del: [Int], ins: [Int], mod: [Int])
}

class AnimationDetailModel: NSObject {
    
    deinit {
        print("deinit - " + theClassName)
        frameToken.invalidate()
    }
    
    weak open var delegate: AnimationDetailModelDelegate?
    
    let realm = DBManager.SI.realm!
    
    lazy var frames: Results<Frame> = {
        let query = String(format: "animationId = '%@'", animation.id)
        let results = realm.objects(Frame.self).filter(query).sorted(byKeyPath: "createdAt")
        return results
    }()
    
    //MARK: Realm NotificationToken
    lazy var frameToken: NotificationToken = {
        return frames.observe { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .update(let results, let del, let ins, let mod):
                self.delegate?.refreshFrames(results: results, del: del, ins: ins, mod: mod)
                
            default:
                break
            }
        }
    }()
    
    var selectedFrame: Frame? = nil
    
    var animation: Animation
    init(animation: Animation) {
        self.animation = animation
        print(animation.id)
        super.init()
    }
    
    func prepare() {
        _ = frameToken
        
        if frames.count == 0 {
            addFrame()
            selectedFrame = frames.first
        }
    }
    
    func addFrame() {
        let newFrame = Frame()
        newFrame.animationId = animation.id
        try! self.realm.write() {
            self.realm.add(newFrame)
        }
    }
    
    func addLine(selectedFrame: Frame, data: Data) {
        let newLine = Line()
        newLine.animationId = animation.id
        newLine.frameId = selectedFrame.id
        newLine.drawingData = data
        try! self.realm.write() {
            self.realm.add(newLine)
        }
    }
}
