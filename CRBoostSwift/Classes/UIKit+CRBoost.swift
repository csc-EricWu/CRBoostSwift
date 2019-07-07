//
//  UIKit+CRBoost.swift
//  CRBoostSwift
//
//  Created by Eric Wu on 2019/7/7.
//

import UIKit

extension UIBarButtonItem {
    @discardableResult
    public func barButton(image: UIImage, selectedImage: UIImage?, target: Any?, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.imageView?.contentMode = .scaleAspectFit
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setImage(image, for: .normal)
        button.setImage(selectedImage, for: .selected)

        button.addTarget(self, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
}

extension UIButton {
    public func verticalImageAndTitle(spacing: CGFloat) {
        let imageSize = imageView?.frame.size ?? CGSize.zero
        var titleSize = titleLabel?.frame.size ?? CGSize.zero
        let textSize = titleLabel?.text?.sizeWithFont(font: titleLabel?.font, maxSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ?? CGSize.zero
        let frameSize = CGSize(width: CGFloat(ceilf(Float(textSize.width))), height: CGFloat(ceilf(Float(textSize.height))))

        if titleSize.width + 0.5 < frameSize.width {
            titleSize.width = frameSize.width
        }
        let totalHeight = imageSize.height + titleSize.height + spacing
        imageEdgeInsets = UIEdgeInsets(top: -(totalHeight - imageSize.height), left: 0, bottom: 0, right: -titleSize.width)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(totalHeight - titleSize.height), right: 0)
    }
}

extension UITableViewCell {
    public func setaccessoryView(view: UIView, insets: UIEdgeInsets) {
        let accessoryWrapperView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width + insets.left + insets.right, height: view.frame.height + insets.top + insets.bottom))
        accessoryWrapperView.addSubview(view)
        view.frame = CGRect(x: insets.left, y: insets.top, width: view.frame.width, height: view.frame.height)
        accessoryView = accessoryWrapperView
    }
}

extension UIWebView {
}

extension UIView {
    private struct CRboostKeys {
        static var gradientLayer = "kGradientLayerKey"
    }

    // MARK: - property

    public var left: CGFloat {
        get { return frame.midX }
        set { frame.origin.x = newValue }
    }

    public var top: CGFloat {
        get { return frame.minY }
        set { frame.origin.y = newValue }
    }

    public var right: CGFloat {
        get { return frame.maxX }
        set { frame.origin.x = newValue - frame.width }
    }

    public var bottom: CGFloat {
        get { return frame.maxY }
        set { frame.origin.y = newValue - frame.height }
    }

    public var width: CGFloat {
        get { return frame.width }
        set { frame.size.width = newValue }
    }

    public var height: CGFloat {
        get { return frame.height }
        set { frame.size.height = newValue }
    }

    public var origin: CGPoint {
        get { return frame.origin }
        set { frame.origin = newValue }
    }

    public var size: CGSize {
        get { return frame.size }
        set { frame.size = newValue }
    }

    public var bottomLeftPoint: CGPoint {
        get { return CGPoint(x: left, y: bottom) }
        set { origin = CGPoint(x: newValue.x, y: newValue.y - height) }
    }

    public var topRightPoint: CGPoint {
        get { return CGPoint(x: right, y: top) }
        set { origin = CGPoint(x: newValue.x - width, y: newValue.y) }
    }

    public var bottomRightPoint: CGPoint {
        get { return CGPoint(x: right, y: bottom) }
        set { origin = CGPoint(x: newValue.x - width, y: newValue.y - height) }
    }

    public var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }

    public var gradientLayer: CAGradientLayer? {
        get {
            return objc_getAssociatedObject(self, &CRboostKeys.gradientLayer) as? CAGradientLayer
        }
        set {
            objc_setAssociatedObject(self, &CRboostKeys.gradientLayer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // MARK: - geometry

    public func centerHorizontally() {
        guard superview != nil else {
            return
        }
        left = (superview!.width - width) / 2
    }

    public func centerVertically() {
        guard superview != nil else {
            return
        }
        top = (superview!.height - height) / 2
    }

    public func centerInSuperview() {
        guard superview != nil else {
            return
        }
        center = CRBoundCenter(rect: superview!.frame)
    }

    // MARK: - method

    public func setLayerShadow(color: UIColor, offset: CGSize, radius: CGFloat) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

    @discardableResult
    public class func loadFramNib<T>(nibName: String) -> T where T: UIView {
        let nib = Bundle.main.loadNibNamed(nibName, owner: self, options: [:])
        let view = nib![0]
        return view as! T
    }

    @discardableResult
    public func topLayerSubview(_ tag: Int) -> UIView? {
        return subviews.first { (view) -> Bool in
            view.tag == tag
        }
    }

    @discardableResult
    public func ancestorViewOf<T>(_ kind: T) -> UIView? where T: UIView {
        var parentView = superview
        while parentView != nil && (!(parentView!.isKind(of: T.self))) {
            parentView = parentView?.superview
        }
        return parentView
    }

    @discardableResult
    public func childrenViewOfKind<T>(_ kind: T) -> UIView? where T: UIView {
        for view in subviews {
            if view.isKind(of: T.self) {
                return view
            } else {
                if let subView = view.childrenViewOfKind(kind) {
                    return subView
                }
            }
        }
        return nil
    }
    @discardableResult
    public func viewController<T>() -> T? where T: UIViewController {
        var view: UIView? = self
        while view != nil {
            if let nextResponder = view?.next, nextResponder.isKind(of: UIViewController.self) {
                return nextResponder as? T
            }
            view = view?.superview
        }
        return nil
    }
    // MARK: - snapshot
    @discardableResult
    public func snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, self.isOpaque, 0)
        if let ctx =  UIGraphicsGetCurrentContext() {
            self.layer.render(in: ctx)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    @discardableResult
    public func snapshotImageAfterScreenUpdates(afterUpdates: Bool) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, self.isOpaque, 0)
        self.drawHierarchy(in: bounds, afterScreenUpdates: afterUpdates)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    // MARK: - animation

    public func pulsateOnce() {
        let scaleUp = CABasicAnimation(keyPath: "transform")
        scaleUp.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        scaleUp.duration = 0.25
        scaleUp.repeatCount = 1
        scaleUp.autoreverses = true
        scaleUp.isRemovedOnCompletion = true
        scaleUp.toValue = transform.scaledBy(x: 1.2, y: 1.2)
        layer.add(scaleUp, forKey: "pulsate")
    }

    // MARK: - transition

    public func transitToSubview(view: UIView, option: UIView.AnimationOptions, duration: CGFloat) {
        UIView.transition(with: view, duration: TimeInterval(duration), options: option, animations: {
            self.addSubview(view)
        }, completion: nil)
    }

    // MARK: - gradient

    public func setGradientBackground(startColor: UIColor, toColor: UIColor) {
        if let gradient = self.gradientLayer, gradient.superlayer != nil {
            gradient.removeFromSuperlayer()
        }

        let gradient = CAGradientLayer()
        gradient.colors = [startColor.cgColor, toColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.locations = [0, 1.0]
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }

    // MARK: - gesture

    @discardableResult
    public func addTapRecognizer(target: Any?, action: Selector?) -> UITapGestureRecognizer {
        gestureRecognizers?.forEach({ gesture in
            if gesture.isKind(of: UITapGestureRecognizer.self) {
                self.removeGestureRecognizer(gesture)
            }
        })
        isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(tapRecognizer)
        return tapRecognizer
    }

    @discardableResult
    public func addPanRecognizer(target: Any?, action: Selector?) -> UIPanGestureRecognizer {
        gestureRecognizers?.forEach({ gesture in
            if gesture.isKind(of: UIPanGestureRecognizer.self) {
                self.removeGestureRecognizer(gesture)
            }
        })
        isUserInteractionEnabled = true
        let gesture = UIPanGestureRecognizer(target: target, action: action)
        addGestureRecognizer(gesture)
        gesture.minimumNumberOfTouches = 1
        gesture.maximumNumberOfTouches = 1
        return gesture
    }

    @discardableResult
    public func addGestureRecognizer<T>(target: Any?, action: Selector?, config: ((T) -> Void)?) -> T where T: UIGestureRecognizer {
        gestureRecognizers?.forEach({ gesture in
            if gesture.isKind(of: T.self) {
                self.removeGestureRecognizer(gesture)
            }
        })
        isUserInteractionEnabled = true
        let gesture = T(target: target, action: action)
        addGestureRecognizer(gesture)
        config?(gesture)
        return gesture
    }
}

extension CALayer {
    // MARK: - snapshot
    @discardableResult
    public func snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0)
        if let ctx =  UIGraphicsGetCurrentContext() {
            render(in: ctx)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
