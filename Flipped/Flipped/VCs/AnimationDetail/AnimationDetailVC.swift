//
//  AnimationDetailVC.swift
//  Flipped
//
//  Created by mc309 on 9/30/23.
//

import UIKit
import RealmSwift
import PencilKit

let kAnimationDetailFrameItemSize = CGSize(width: 50, height: 50)

class AnimationDetailVC: UIViewController {

    lazy var contentView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    lazy var canvasView: PKCanvasView = {
        let v: PKCanvasView = PKCanvasView()
        v.drawingPolicy = .anyInput
        v.tool = PKInkingTool(.pen, color: .black, width: 15)
        v.backgroundColor = .gray
        v.delegate = self
        return v
    }()
    
    lazy var bottomView: AnimationDetailBottomView = AnimationDetailBottomView()
       
    lazy var toolPicker: PKToolPicker = PKToolPicker()
    
    lazy var closeButton: UIButton = {
        let v = UIButton(type: .close)
        return v
    }()
    
    lazy var makeAnimationButton: UIButton = {
        let v = UIButton()
        v.setTitle("Make", for: .normal)
        v.setTitleColor(.systemBlue, for: .normal)
        return v
    }()
    
    var isLoadingDrawing: Bool = false
    
    var animation: Animation
    let model: AnimationDetailModel
    init(animation: Animation) {
        self.animation = animation
        self.model = AnimationDetailModel(animation: animation)
        super.init(nibName: nil, bundle: nil)
        
        self.model.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: makeAnimationButton)]
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: closeButton)]
        
        view.addSubview(contentView)
        contentView.addSubview(canvasView)
        contentView.addSubview(bottomView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        canvasView.snp.makeConstraints { make in
            make.top.left.right.equalTo(contentView)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(70)
        }
        
        model.prepare()
        
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        makeAnimationButton.addTarget(self, action: #selector(makeAnimationButtonPressed), for: .touchUpInside)
        
        bottomView.frameCollectionView.dataSource = self
        bottomView.frameCollectionView.delegate = self
        bottomView.addFrameButton.addTarget(self, action: #selector(addFrameButtonPressed), for: .touchUpInside)
    }
    
    @objc func closeButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc func makeAnimationButtonPressed() {
        let images: [UIImage] = model.makeImagesFromFrames(canvasView: canvasView)
        let makeAnimationVC: MakeAnimationVC = MakeAnimationVC(images: images)
        present(makeAnimationVC, animated: true)
    }
    
    @objc func addFrameButtonPressed() {
        // clear
        canvasView.drawing = PKDrawing()
        
        model.addFrame()
    }
    
    func selectFrameCollectionView(index: Int) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.bottomView.frameCollectionView.selectItem(at: IndexPath(row: index, section: 0),
                                                      animated: false,
                                                      scrollPosition: .left)
        }
    }
}

extension AnimationDetailVC: PKCanvasViewDelegate {
    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        if isLoadingDrawing == false {
            if let selectedFrame = model.selectedFrame {
                if canvasView.drawing.strokes.count > 0 {
                    model.addLine(selectedFrame: selectedFrame, data: canvasView.drawing.dataRepresentation())
                }
            }
        }
    }
}

extension AnimationDetailVC: AnimationDetailModelDelegate {
    func selectFrame(frame: Frame) {
        let index = model.getIndex(frame: frame)
        selectDrawing(index: index)
        selectFrameCollectionView(index: index)
    }
    
    func refreshFrames(results: Results<Frame>, del: [Int], ins: [Int], mod: [Int]) {
        bottomView.frameCollectionView.reloadData()
        if let index = ins.last {
            selectFrameCollectionView(index: index)
        }
    }
}


extension AnimationDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectDrawing(index: indexPath.row)
    }
    
    func selectDrawing(index: Int) {
        isLoadingDrawing = true
        let frame = model.frames[index]
        model.selectedFrame = frame
        
        // clear
        canvasView.drawing = PKDrawing()
        
        var allDrawing: PKDrawing = PKDrawing()
        for lineData in model.getLines(selectedFrame: frame) {
            allDrawing.append(lineData.drawing)
        }
        canvasView.drawing = allDrawing
        isLoadingDrawing = false
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAt indexPath: IndexPath) -> CGSize {
       return kAnimationDetailFrameItemSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.frames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as AnimationDetailFrameCell
        cell.backgroundColor = .black
        return cell
    }
    
}
