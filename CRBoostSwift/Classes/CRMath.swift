//
//  CRMath.swift
//  Pods
//
//  Created by Eric Wu on 2019/6/19.
//

import AVFoundation
import UIKit

public typealias AlertAction = (_ action: UIAlertAction) -> Void
@discardableResult
public func CRRadian2degrees(radian: Double) -> Double {
    return (radian) * 180.0 / Double.pi
}

@discardableResult
public func CRDegrees2radian(degree: Double) -> Double {
    return Double.pi * degree / 180.0
}

@discardableResult
public func CRRadianOfTransform(transform: CGAffineTransform) -> CGFloat {
    return atan2(transform.b, transform.a)
}

@discardableResult
public func CRHorizontalLength(p1: CGPoint, p2: CGPoint) -> CGFloat {
    return abs(p1.x - p2.x)
}

@discardableResult
public func CRVerticalLength(p1: CGPoint, p2: CGPoint) -> CGFloat {
    return abs(p1.y - p2.y)
}

@discardableResult
public func CRCenterX(p1: CGPoint, p2: CGPoint) -> CGFloat {
    return (p1.x + p2.x) / 2
}

@discardableResult
public func CRCenterY(p1: CGPoint, p2: CGPoint) -> CGFloat {
    return (p1.y + p2.y) / 2
}

@discardableResult
public func CRArcAngle(start: CGPoint, end: CGPoint) -> CGFloat {
    let originPoint = CGPoint(x: end.x - start.x, y: start.y - end.y)
    var radians = atan2(originPoint.y, originPoint.x)
    radians = radians < 0.0 ? (CGFloat(Double.pi * 2) + radians) : radians
    print("arc radians is \(radians)")
    return CGFloat(Double.pi * 2) - radians
}

@discardableResult
public func CRDistanceCompare(start: CGPoint, end: CGPoint) -> CGFloat {
    let originX = end.x - start.x
    let originY = end.y - start.y

    return (originX * originX + originY * originY)
}

@discardableResult
public func CRDistance(start: CGPoint, end: CGPoint) -> CGFloat {
    return sqrt(CRDistanceCompare(start: start, end: end))
}

@discardableResult
public func CRCenterPoint(start: CGPoint, end: CGPoint) -> CGPoint {
    return CGPoint(x: (end.x + start.x) / 2, y: (end.y + start.y) / 2)
}

// MARK: - graphics

@discardableResult
public func CRPointPlus(p1: CGPoint, p2: CGPoint) -> CGPoint {
    return CGPoint(x: p1.x + p2.x, y: p1.y + p2.y)
}

@discardableResult
public func CRPointOffset(p1: CGPoint, x: CGFloat, y: CGFloat) -> CGPoint {
    return CGPoint(x: p1.x + x, y: p1.y + y)
}

@discardableResult
public func CRPointSubtract(p1: CGPoint, p2: CGPoint) -> CGPoint {
    return CGPoint(x: p1.x - p2.x, y: p1.y - p2.y)
}

@discardableResult
public func CRPointSacle(point: CGPoint, factor: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * factor, y: point.y * factor)
}

@discardableResult
public func CRFrameCenter(rect: CGRect) -> CGPoint {
    return CGPoint(x: rect.midX, y: rect.midY)
}

@discardableResult
public func CRBoundCenter(rect: CGRect) -> CGPoint {
    return CGPoint(x: rect.width / 2, y: rect.height / 2)
}

@discardableResult
public func CRLocationInRect(rect: CGRect, location: CGPoint) -> CGPoint {
    return CGPoint(x: location.x - rect.minX, y: location.y - rect.minY)
}

@discardableResult
public func CRLocationRatio(bounds: CGRect, location: CGPoint) -> CGPoint {
    let location2 = CRLocationInRect(rect: bounds, location: location)
    return CGPoint(x: location2.x / bounds.width, y: location2.y / bounds.height)
}

@discardableResult
public func CRSize2Point(size: CGSize) -> CGPoint {
    return CGPoint(x: size.width, y: size.height)
}

//==================rect==================
@discardableResult
public func CRCenteredFrame(frame: CGRect, center: CGPoint) -> CGRect {
    var frame2 = frame

    frame2.origin = CGPoint(x: center.x - frame.width / 2, y: center.y - frame.height / 2)
    return frame2
}

@discardableResult
public func CRRectAddedHeight(rect: CGRect, height: CGFloat) -> CGRect {
    let rect2 = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height + height)
    return rect2
}

@discardableResult
public func CRRectUpdatedHeight(rect: CGRect, height: CGFloat) -> CGRect {
    let rect2 = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: height)
    return rect2
}

//=====================area==========================
@discardableResult
public func CRSizeArea(size: CGSize) -> CGFloat {
    return size.width * size.height
}

@discardableResult
public func CRSizeArea(frame: CGRect) -> CGFloat {
    return CRSizeArea(size: frame.size)
}

//==================size: a new one==================
@discardableResult
public func CRSizeEnlarged(size: CGSize, width: CGFloat, height: CGFloat) -> CGSize {
    return CGSize(width: size.width + width, height: size.height + height)
}

@discardableResult
public func CRSizeZoomed(size: CGSize, factor: CGFloat) -> CGSize {
    return CGSize(width: size.width * factor, height: size.height * factor)
}

// MARK: - device

@discardableResult
public func CRScreenBounds(landscape: Bool) -> CGRect {
    var rect = UIScreen.main.bounds
    if landscape && rect.width < rect.height {
        let height = rect.height
        rect.size.height = rect.width
        rect.size.width = height
    }
    return rect
}

@discardableResult
public func CRScreenIsLandscape() -> Bool {
    return UIDevice.current.orientation.isLandscape
    // UIDeviceOrientationIsLandscape(CRCurrentDevice.orientation);
}

@discardableResult
public func CRScreenSize() -> CGSize {
    let rect = CRScreenBounds(landscape: CRScreenIsLandscape())
    return rect.size
}

@discardableResult
public func CRScreenRect() -> CGRect {
    return CRScreenBounds(landscape: CRScreenIsLandscape())
}

@discardableResult
public func CRIsIphoneX() -> Bool {
    return (CRScreenSize().equalTo(CGSize(width: 375, height: 812)) || // X  or Xs
        CRScreenSize().equalTo(CGSize(width: 812, height: 375)) || // X  or Xs
        CRScreenSize().equalTo(CGSize(width: 414, height: 896)) || // iPhone Xs Max | Xr
        CRScreenSize().equalTo(CGSize(width: 896, height: 414)) // iPhone Xs Max | Xr
    )
}

@discardableResult
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

@discardableResult
public func CRRootViewController() -> UIViewController {
    return CRMainWindow().rootViewController!
}

@discardableResult
public func CRRootView() -> UIView {
    return CRRootViewController().view
}

@discardableResult
public func CRRootTabBar() -> UITabBarController? {
    return CRRootViewController() as? UITabBarController
}

@discardableResult
public func CRRootNaviation() -> UINavigationController? {
    return CRRootViewController() as? UINavigationController
}

@discardableResult
public func CRNaviationHeight() -> CGFloat {
    return UIApplication.shared.statusBarFrame.height + 44
}

@discardableResult
public func CRSafeAreaInsets() -> UIEdgeInsets {
    var insets = UIEdgeInsets.zero
    if #available(iOS 11.0, *) {
        insets = CRMainWindow().safeAreaInsets
    } else {
    }
    return insets
}

@discardableResult
public func CRBottomAdditionalHeight() -> CGFloat {
    return CRSafeAreaInsets().bottom
}

@discardableResult
public func CRTabBarHeight(controller: UIViewController) -> CGFloat {
    var height: CGFloat = 0
    if controller.tabBarController != nil && !(controller.tabBarController!.tabBar.isHidden) {
        height = controller.tabBarController!.tabBar.bounds.height
    }
    height += CRSafeAreaInsets().bottom
    return height
}

@discardableResult
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

@discardableResult
public func CRTopViewController(controller: UIViewController = CRRootViewController()) -> UIViewController? {
    if controller.presentedViewController != nil {
        return CRTopViewController(controller: controller.presentedViewController!)
    } else if controller.isKind(of: UITabBarController.self) {
        let tabBar = controller as! UITabBarController
        return CRTopViewController(controller: tabBar.selectedViewController!)
    } else if controller.isKind(of: UINavigationController.self) {
        let navigation = controller as! UINavigationController
        return CRTopViewController(controller: navigation.visibleViewController!)
    } else {
        for childCtrl in controller.children {
            if childCtrl.view.window != nil {
                return childCtrl
            }
        }
        return controller
    }
}

@discardableResult
public func CRTopMostController() -> UIViewController {
    var topviewController = CRRootViewController()
    while topviewController.presentedViewController != nil {
        topviewController = topviewController.presentedViewController!
    }
    return topviewController
}

@discardableResult
public func CRKeyboardHide() -> Bool {
    return CRMainWindow().endEditing(true)
}

@discardableResult
public func CRSystemVolume() -> Float {
    return AVAudioSession.sharedInstance().outputVolume
}

// MARK: - file

@discardableResult
public func CRFileSize(path: String) -> UInt64 {
    if let attributes = try? FileManager.default.attributesOfItem(atPath: path) {
        return attributes[FileAttributeKey.size] as! UInt64
    }
    return 0
}

@discardableResult
public func CRFileModifyDate(path: String) -> Date? {
    if let attributes = try? FileManager.default.attributesOfItem(atPath: path) {
        return attributes[FileAttributeKey.modificationDate] as? Date
    }
    return nil
}

@discardableResult
public func CRBundlePath(fileName: String) -> String {
    let path = Bundle.main.resourcePath! as NSString
    return path.appendingPathComponent(fileName)
}

@discardableResult
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

@discardableResult
public func CRPresentAlert(title: String?, msg: String, handler: AlertAction? = nil, canel: String, action: String...) -> UIAlertController {
    let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    if !canel.isEmpty {
        let alertAction = UIAlertAction(title: canel, style: .cancel, handler: handler)
        alert.addAction(alertAction)
    }
    action.forEach { item in
        if !item.isEmpty {
            let alertAction = UIAlertAction(title: item, style: .default, handler: handler)
            alert.addAction(alertAction)
        }
    }
    CRTopViewController()?.present(alert, animated: true, completion: nil)
    return alert
}

@discardableResult
public func CRPresentActionSheet(title: String? = nil, msg: String? = nil, handler: AlertAction? = nil, canel: String = "取消", actions: String...) -> UIAlertController {
    let alert = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
    if !canel.isEmpty {
        let alertAction = UIAlertAction(title: canel, style: .cancel, handler: handler)
        alert.addAction(alertAction)
    }
    actions.forEach { item in
        if !item.isEmpty {
            let alertAction = UIAlertAction(title: item, style: .default, handler: handler)
            alert.addAction(alertAction)
        }
    }
    CRTopViewController()?.present(alert, animated: true, completion: nil)
    return alert
}


@discardableResult
public func CRPresentAlert(title: String?, msg: String) -> UIAlertController {
    return CRPresentAlert(title: title, msg: msg, handler: nil, canel: NSLocalizedString("OK", comment: ""))
}

@discardableResult
public func CRControllerWithStoryboard(name: String, identifier: String) -> Any {
    return UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: identifier)
}

// MARK: - foundation

// Bitwise
@discardableResult
public func CRBitwiseHas(base: Int, bit: Int) -> Bool {
    return (base & bit) == bit
}

@discardableResult
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

@discardableResult
public func CRJSONFromPath(path: String) -> Any? {
    if let jsonData = NSData(contentsOfFile: path) {
        if let json = try? JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments) { return json }
    }
    return nil
}

@discardableResult
public func CRJSONFromString(string: String?) -> Any? {
    if let text = string {
        if let jsonData = text.data(using: .utf8) {
            if let json = try? JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments) { return json }
        }
    }
    return nil
}

@discardableResult
public func CRJSONToString(_ obj: Any) -> String? {
    if let data = try? JSONSerialization.data(withJSONObject: obj, options: []) {
        if let json = String(data: data, encoding: .utf8) {
            return json
        }
    }
    return nil
}

@discardableResult
public func CRTimestamp() -> Int64 {
    let timeInterval = Date().timeIntervalSince1970 * 1000
    return Int64(timeInterval)
}

@discardableResult
public func CRJSONIsArray(json: Any?) -> Bool {
    return json is [Any]
}

@discardableResult
public func CRJSONIsDictionary(json: Any?) -> Bool {
    return json is Dictionary<String, Any>
}

@discardableResult
public func CRJSONFromQuery(query: String) -> [String: String]? {
    if CRIsNullOrEmpty(text: query) {
        return nil
    }
    var cmp = URLComponents(string: query)
    if CRIsNullOrEmpty(text: cmp?.query) {
        cmp?.query = query
    }
    var json = [String: String]()
    guard let queryItems = cmp?.queryItems else { return nil }

    for item in queryItems {
        if !CRIsNullOrEmpty(text: item.name) && !CRIsNullOrEmpty(text: item.value) {
            json[item.name] = item.value
        }
    }
    return json.count > 0 ? json : nil
}

@discardableResult
public func CRQueryFromJSON(json: [String: String]?) -> String? {
    guard json != nil && json!.count > 0 else {
        return nil
    }
    var queryList = [String]()
    json!.forEach { (key: String, value: Any) in
        let query = String("\(key)=\(value)")
        queryList.append(query)
    }
    return queryList.joined(separator: "&")
}

// MARK: - match

@discardableResult
public func CRMatches(pattern: String, text: String?) -> [NSTextCheckingResult]? {
    guard let string = text else { return nil }
    if string.count <= 0 {
        return nil
    }
    if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
        return regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
    }
    return nil
}

@discardableResult
public func CRMatch(pattern: String, text: String?) -> NSTextCheckingResult? {
    return CRMatches(pattern: pattern, text: text)?.first
}

@discardableResult
public func CRIsMatch(pattern: String, text: String?) -> Bool {
    if CRIsNullOrEmpty(text: text) {
        return false
    }
    if CRMatch(pattern: pattern, text: text) == nil {
        return false
    }
    return true
}

@discardableResult
public func CRIsEmail(text: String?) -> Bool {
    let pattern = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$"
    return CRIsMatch(pattern: pattern, text: text)
}

/**
 * 判断字符串是否符合手机号码格式
 * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
 * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
 * 电信号段: 133,149,153,170,173,177,180,181,189
 * @param text 待检测的字符串
 * @return 待检测的字符串
 */
@discardableResult
public func CRIsPhoneNumber(text: String?) -> Bool {
    let pattern = "^[1][3-9][0-9]{9}$"
    return CRIsMatch(pattern: pattern, text: text)
}

@discardableResult
public func CRIsInteger(text: String?) -> Bool {
    let pattern = "^\\d+$"
    return CRIsMatch(pattern: pattern, text: text)
}

@discardableResult
public func CRIsURL(text: String?) -> Bool {
    // (https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]
    let pattern = "(https?)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]"
    return CRIsMatch(pattern: pattern, text: text)
}

@discardableResult
public func CRIsNullOrEmpty(text: String?) -> Bool {
    if (text as Any) is NSNull {
        return true
    }
    if let string: String = text {
        guard !string.isEmpty && string != "(null)" && string != "<null>" else {
            return true
        }
    } else { return true }
    return false
}

public func CRCallPhoneNumber(phone: String?) {
    if CRIsNullOrEmpty(text: phone) {
        return
    }
    let str = "tel:\(phone!)"
    if let url = URL(string: str) {
        let callWebview = UIWebView()
        callWebview.loadRequest(URLRequest(url: url))
        CRRootView().addSubview(callWebview)
    }
}
