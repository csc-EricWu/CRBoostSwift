//
//  CRMath.swift
//  Pods
//
//  Created by Eric Wu on 2019/6/19.
//

import AVFoundation
import UIKit

public typealias AlertAction = (_ action: UIAlertAction) -> Void

public func CRRadian2degrees(radian: Double) -> Double {
    return (radian) * 180.0 / Double.pi
}

public func CRDegrees2radian(degree: Double) -> Double {
    return Double.pi * degree / 180.0
}

public func CRRadianOfTransform(transform: CGAffineTransform) -> CGFloat {
    return atan2(transform.b, transform.a)
}

public func CRHorizontalLength(p1: CGPoint, p2: CGPoint) -> CGFloat {
    return abs(p1.x - p2.x)
}

public func CRVerticalLength(p1: CGPoint, p2: CGPoint) -> CGFloat {
    return abs(p1.y - p2.y)
}

public func CRCenterX(p1: CGPoint, p2: CGPoint) -> CGFloat {
    return (p1.x + p2.x) / 2
}

public func CRCenterY(p1: CGPoint, p2: CGPoint) -> CGFloat {
    return (p1.y + p2.y) / 2
}

public func CRArcAngle(start: CGPoint, end: CGPoint) -> CGFloat {
    let originPoint = CGPoint(x: end.x - start.x, y: start.y - end.y)
    var radians = atan2(originPoint.y, originPoint.x)
    radians = radians < 0.0 ? (CGFloat(Double.pi * 2) + radians) : radians
    print("arc radians is \(radians)")
    return CGFloat(Double.pi * 2) - radians
}

public func CRDistanceCompare(start: CGPoint, end: CGPoint) -> CGFloat {
    let originX = end.x - start.x
    let originY = end.y - start.y

    return (originX * originX + originY * originY)
}

public func CRDistance(start: CGPoint, end: CGPoint) -> CGFloat {
    return sqrt(CRDistanceCompare(start: start, end: end))
}

public func CRDistance(start: CGPoint, end: CGPoint) -> CGPoint {
    return CGPoint(x: (end.x + start.x) / 2, y: (end.y + start.y) / 2)
}

// MARK: - graphics

public func CRPointPlus(p1: CGPoint, p2: CGPoint) -> CGPoint {
    return CGPoint(x: p1.x + p2.x, y: p1.y + p2.y)
}

public func CRPointOffset(p1: CGPoint, x: CGFloat, y: CGFloat) -> CGPoint {
    return CGPoint(x: p1.x + x, y: p1.y + y)
}

public func CRPointSubtract(p1: CGPoint, p2: CGPoint) -> CGPoint {
    return CGPoint(x: p1.x - p2.x, y: p1.y - p2.y)
}

public func CRPointSacle(point: CGPoint, factor: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * factor, y: point.y * factor)
}

public func CRFrameCenter(rect: CGRect) -> CGPoint {
    return CGPoint(x: rect.midX, y: rect.midY)
}

public func CRBoundCenter(rect: CGRect) -> CGPoint {
    return CGPoint(x: rect.width / 2, y: rect.height / 2)
}

public func CRLocationInRect(rect: CGRect, location: CGPoint) -> CGPoint {
    return CGPoint(x: location.x - rect.minX, y: location.y - rect.minY)
}

public func CRLocationRatio(bounds: CGRect, location: CGPoint) -> CGPoint {
    let location2 = CRLocationInRect(rect: bounds, location: location)
    return CGPoint(x: location2.x / bounds.width, y: location2.y / bounds.height)
}

public func CRSize2Point(size: CGSize) -> CGPoint {
    return CGPoint(x: size.width, y: size.height)
}

//==================rect==================
public func CRCenteredFrame(frame: CGRect, center: CGPoint) -> CGRect {
    var frame2 = frame

    frame2.origin = CGPoint(x: center.x - frame.width / 2, y: center.y - frame.height / 2)
    return frame2
}

public func CRRectAddedHeight(rect: CGRect, height: CGFloat) -> CGRect {
    let rect2 = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height + height)
    return rect2
}

public func CRRectUpdatedHeight(rect: CGRect, height: CGFloat) -> CGRect {
    let rect2 = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: height)
    return rect2
}

//=====================area==========================
public func CRSizeArea(size: CGSize) -> CGFloat {
    return size.width * size.height
}

public func CRSizeArea(frame: CGRect) -> CGFloat {
    return CRSizeArea(size: frame.size)
}

//==================size: a new one==================
public func CRSizeEnlarged(size: CGSize, width: CGFloat, height: CGFloat) -> CGSize {
    return CGSize(width: size.width + width, height: size.height + height)
}

public func CRSizeZoomed(size: CGSize, factor: CGFloat) -> CGSize {
    return CGSize(width: size.width * factor, height: size.height * factor)
}

// MARK: - device

public func CRScreenBounds(landscape: Bool) -> CGRect {
    var rect = UIScreen.main.bounds
    if landscape && rect.width < rect.height {
        let height = rect.height
        rect.size.height = rect.width
        rect.size.width = height
    }
    return rect
}

public func CRScreenIsLandscape() -> Bool {
    return UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)
    // UIDeviceOrientationIsLandscape(CRCurrentDevice.orientation);
}

public func CRScreenSize() -> CGSize {
    let rect = CRScreenBounds(landscape: CRScreenIsLandscape())
    return rect.size
}

public func CRScreenRect() -> CGRect {
    return CRScreenBounds(landscape: CRScreenIsLandscape())
}

public func CRIsIphoneX() -> Bool {
    return (CRScreenSize().equalTo(CGSize(width: 375, height: 812)) || // X  or Xs
        CRScreenSize().equalTo(CGSize(width: 812, height: 375)) || // X  or Xs
        CRScreenSize().equalTo(CGSize(width: 414, height: 896)) || // iPhone Xs Max | Xr
        CRScreenSize().equalTo(CGSize(width: 896, height: 414)) // iPhone Xs Max | Xr
    )
}

public func CRMainWindow() -> UIWindow {
    var mainWindow: UIWindow? = UIApplication.shared.delegate?.window ?? nil
    if mainWindow == nil {
        let arrWindow = UIApplication.shared.windows
        if arrWindow.count > 0 {
            mainWindow = arrWindow.first
        }
    }
    return mainWindow!
}

public func CRRootViewController() -> UIViewController {
    return CRMainWindow().rootViewController!
}

public func CRRootView() -> UIView {
    return CRRootViewController().view
}

public func CRRootTabBar() -> UITabBarController? {
    return CRRootViewController() as? UITabBarController
}

public func CRRootNaviation() -> UINavigationController? {
    return CRRootViewController() as? UINavigationController
}

public func CRNaviationHeight() -> CGFloat {
    return UIApplication.shared.statusBarFrame.height + 44
}

public func CRSafeAreaInsets() -> UIEdgeInsets {
    var insets = UIEdgeInsets.zero
    if #available(iOS 11.0, *) {
        insets = CRMainWindow().safeAreaInsets
    } else {
    }
    return insets
}

public func CRBottomAdditionalHeight() -> CGFloat {
    return CRSafeAreaInsets().bottom
}

public func CRTabBarHeight(controller: UIViewController) -> CGFloat {
    var height: CGFloat = 0
    if controller.tabBarController != nil && !(controller.tabBarController!.tabBar.isHidden) {
        height = controller.tabBarController!.tabBar.bounds.height
    }
    height += CRSafeAreaInsets().bottom
    return height
}

public func CRPopToViewController(navigation: UINavigationController?, controller: UIViewController?, animated: Bool) -> Bool {
    var found = false
    guard navigation != nil && controller != nil else {
        return found
    }
    if navigation!.isKind(of: UINavigationController.self) {
        for ctrl in navigation!.viewControllers {
            if ctrl.isKind(of: type(of: controller!)) {
                found = true
                navigation?.popToViewController(controller!, animated: animated)
                break
            }
        }
    }
    return found
}

public func CRTopViewController(controller: UIViewController = CRRootViewController()) -> UIViewController? {
    if controller.presentedViewController != nil {
        return CRTopViewController(controller: controller)
    } else if controller.isKind(of: UITabBarController.self) {
        let tabBar = controller as! UITabBarController
        return CRTopViewController(controller: tabBar.selectedViewController!)
    } else if controller.isKind(of: UINavigationController.self) {
        let navigation = controller as! UINavigationController
        return CRTopViewController(controller: navigation.visibleViewController!)
    } else {
        for childCtrl in controller.childViewControllers {
            if childCtrl.view.window != nil {
                return childCtrl
            }
        }
        return controller
    }
}

public func CRTopMostController() -> UIViewController {
    var topviewController = CRRootViewController()
    while topviewController.presentedViewController != nil {
        topviewController = topviewController.presentedViewController!
    }
    return topviewController
}

public func CRKeyboardHide() -> Bool {
    return CRMainWindow().endEditing(true)
}

public func CRSystemVolume() -> Float {
    return AVAudioSession.sharedInstance().outputVolume
}

// MARK: - file

public func CRFileSize(path: String) -> UInt64 {
    if let attributes = try? FileManager.default.attributesOfItem(atPath: path) {
        return attributes[FileAttributeKey.size] as! UInt64
    }
    return 0
}

public func CRFileModifyDate(path: String) -> Date? {
    if let attributes = try? FileManager.default.attributesOfItem(atPath: path) {
        return attributes[FileAttributeKey.modificationDate] as? Date
    }
    return nil
}

public func CRBundlePath(fileName: String) -> String {
    let path = Bundle.main.resourcePath! as NSString
    return path.appendingPathComponent(fileName)
}

public func CRFileExistsAtPath(path: String) -> Bool {
    return FileManager.default.fileExists(atPath: path)
}

// MARK: - UI

public func CRPresentView(view: UIView, animated: Bool) {
    if animated {
        view.alpha = 0.001
        CRRootView().addSubview(view)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            view.alpha = 1
        }, completion: nil)
    } else {
        CRRootView().addSubview(view)
    }
}

public func CRPresentAlert(title: String?, msg: String, handler: AlertAction? = nil, canel: String, action: String...) -> UIAlertController {
    let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    if !canel.isEmpty {
        let alertAction = UIAlertAction(title: canel, style: .cancel, handler: handler)
        alert.addAction(alertAction)
    }
    action.forEach { item in
        let alertAction = UIAlertAction(title: item, style: .default, handler: handler)
        alert.addAction(alertAction)
    }
    CRTopViewController()?.present(alert, animated: true, completion: nil)
    return alert
}

public func CRPresentAlert(title: String?, msg: String) -> UIAlertController {
    return CRPresentAlert(title: title, msg: msg, handler: nil, canel: NSLocalizedString("OK", comment: ""))
}

public func CRControllerWithStoryboard(name: String, identifier: String) -> Any {
    return UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: identifier)
}

// MARK: - foundation

// Bitwise

public func CRBitwiseHas(base: Int, bit: Int) -> Bool {
    return (base & bit) == bit
}

public func CRUUIDString() -> String {
    return NSUUID().uuidString
}

// MARK: - GCD

public func CRRunOnMainThread(task: @escaping CRVoidBlock) {
    if Thread.isMainThread {
        task()
    } else {
        DispatchQueue.main.async {
            task()
        }
    }
}

// MARK: - json

public func CRJSONFromPath(path: String) -> Any? {
    if let jsonData = NSData(contentsOfFile: path) {
        if let json = try? JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments)
        { return json }
    }
    return nil
}

public func CRJSONFromString(string: String?) -> Any? {
    if let text = string {
        if let jsonData = text.data(using: .utf8) {
            if let json = try? JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments)
            { return json }
        }
    }
    return nil
}

public func CRTimestamp() -> Int64 {
    let timeInterval = Date().timeIntervalSince1970 * 1000

    return Int64(timeInterval)
}

public func CRJSONIsArray(json: AnyObject?) -> Bool {
    return json is [Any]
}

public func CRJSONIsDictionary(json: AnyObject?) -> Bool {
    return json is Dictionary<String, Any>
}

public func CRIsNullOrEmpty(text: AnyObject?) -> Bool {
    if text is NSNull || text == nil || text!.isEmpty {
        return true
    }
    if let string: String = text as? String {
        if string == "(null)" || string == "<null>" {
            return true
        }
    }
    return false
}
