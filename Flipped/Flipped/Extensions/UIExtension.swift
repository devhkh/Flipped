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
