//
//  UIExtension.swift
//  Flipped
//
//  Created by mc309 on 9/30/23.
//

import UIKit

let k320: CGFloat = UIScreen.main.bounds.size.width
let k480: CGFloat = UIScreen.main.bounds.size.height

protocol ReusableView: AnyObject {}
extension ReusableView where Self: UIView {
  static var reuseIdentifier: String { return String(describing: self) }
}

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

extension NSObject {
  var theClassName: String {
    return NSStringFromClass(type(of: self))
  }
}

extension UIView {
    @objc func setShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.8
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.masksToBounds = false
    }
    
    @objc func setShadow(x: CGFloat, y: CGFloat, blur: CGFloat, color: UIColor) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = blur
        self.layer.shadowOffset = CGSize(width: x, height: y)
        self.layer.masksToBounds = false
    }
    
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            if newValue > 0.0 {
                self.clipsToBounds = true
            }
            else {
                self.clipsToBounds = false
            }
        }
    }
    
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    var borderColor: UIColor? {
        get {
            if let color = self.layer.borderColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
        set {
            if let color = newValue {
                self.layer.borderColor = color.cgColor
            }
            else {
                self.layer.borderColor = nil
            }
        }
    }
    
    func addBlur(style: UIBlurEffect.Style, _ alpha: CGFloat = 0.5) {
        let effect = UIBlurEffect(style: style)
        let effectView = UIVisualEffectView(effect: effect)
        
        effectView.frame = self.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effectView.alpha = alpha
        
        self.addSubview(effectView)
    }
}
