//
//  AnimationDetailModel.swift
//  Flipped
//
//  Created by mc309 on 9/30/23.
//

import UIKit
import RealmSwift
import PencilKit

protocol AnimationDetailModelDelegate: AnyObject {
    func selectFrame(frame: Frame)
    func refreshFrames(results: Results<Frame>, del: [Int], ins: [Int], mod: [Int])
}

struct LineData {
    var line: Line
    var drawing: PKDrawing
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
        } else {
            selectedFrame = frames.first
        }
        
        if let selectedFrame = self.selectedFrame {
            delegate?.selectFrame(frame: selectedFrame)
        }
    }
    
    func addFrame() {
        let newFrame = Frame()
        newFrame.animationId = animation.id
        try! self.realm.write() {
            self.realm.add(newFrame)
        }
        delegate?.selectFrame(frame: newFrame)
    }
    
    func addLine(selectedFrame: Frame, data: Data) {
        let lineId = UUID.init().uuidString
        let newLine = Line()
        newLine.id = lineId
        newLine.animationId = animation.id
        newLine.frameId = selectedFrame.id

        do {
            try self.realm.write() {
                self.realm.add(newLine)
            }
            try saveDrawingFile(name: lineId, data: data)
        } catch {
            print("Error saving drawing: \(error)")
        }
    }
    
    func saveDrawingFile(name: String, data: Data) throws {
        do {
            let documentsUrl = try FileManager.default.url(for: .documentDirectory, 
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: true)
            let drawingUrl = documentsUrl.appendingPathComponent("drawing")
            try FileManager.default.createDirectory(at: drawingUrl, withIntermediateDirectories: true, attributes: nil)
            
            let fileURL = drawingUrl.appending(component: name)
            try data.write(to: fileURL)
            
            print("Drawing saved to \(fileURL)")
        } catch {
            print("Error saving drawing: \(error)")
        }
    }
    
    func getLines(selectedFrame: Frame) -> [LineData] {
        let query = String(format: "animationId = '%@' and frameId = '%@'", animation.id, selectedFrame.id)
        let lines = realm.objects(Line.self).filter(query).sorted(byKeyPath: "createdAt")
        var lineDataList: [LineData] = []
        for line in lines {
            let drawingData: PKDrawing? = getDrawingFile(name: line.id)
            if let drawingData = drawingData {
                let lineData = LineData(line: line, drawing: drawingData)
                lineDataList.append(lineData)
            }
        }
        return lineDataList
    }
    
    func getDrawingFile(name: String) -> PKDrawing? {
        do {
            let documentsURL = try FileManager.default.url(for: .documentDirectory, 
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: true)
            let fileURL = documentsURL.appending(path: "drawing").appending(component: name)
            let data = try Data(contentsOf: fileURL)
            let drawingData = try PKDrawing(data: data)
            return drawingData
        } catch {
            return nil
        }
    }
    
    func getIndex(frame: Frame) -> Int {
        let query = String(format: "animationId = '%@'", animation.id)
        let fames = realm.objects(Frame.self).filter(query).sorted(byKeyPath: "createdAt")
        if let index = fames.index(of: frame) {
            return index
        }
        return 0
    }
    
    func makeImagesFromFrames(canvasView: PKCanvasView) -> [UIImage] {
        let query = String(format: "animationId = '%@'", animation.id)
        let fames = realm.objects(Frame.self).filter(query).sorted(byKeyPath: "createdAt")
        
        var images: [UIImage] = []
        for frame in frames {
            var allDrawing: PKDrawing = PKDrawing()
            for lineData in getLines(selectedFrame: frame) {
                allDrawing.append(lineData.drawing)
            }
            let image = allDrawing.image(from: canvasView.bounds, scale: CGFloat(1.0))
            images.append(image)
        }
        return images
    }
}

