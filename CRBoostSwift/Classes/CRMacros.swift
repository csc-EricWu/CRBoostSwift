//
//  CRMacros.swift
//  BSBacktraceLogger
//
//  Created by Eric Wu on 2019/6/19.
//

import AdSupport
import Foundation

// MARK: - Hardware & OS

// MARK: - foundation

//==================object==================
public let CRNull = NSNull()

//==================date==================
public let CRCOMPS_DATE: [Calendar.Component] = [.year, .month, .day]
public let CRCOMPS_TIME: [Calendar.Component] = [.hour, .minute, .second]

// MARK: - Default

public let kBracketBigBegin = "{"
public let kBracketBigEnd = "}"
public let kSeparatorComma = ","
public let kSeparatorSlash = "/"
public let kSeparatorDot = "."
public let kSymbolQuestion = "?"
public let kSeparatorBitAnd = "&"
public let kSymbolEqual = "="
public let kWhitespace = " "
public let kEmptyString = ""
public let kSeparatorSolidDot = "●"

// range

public let JSON_RANGE_KEY = "range"

// color
public let JSON_COLOR_KEY = "color"
// style
public let JSON_STYLE_KEY = "style"
// size
public let JSON_SIZE_KEY = "size"
public let JSON_WIDTH_KEY = "width"
public let JSON_HEIGHT_KEY = "height"
public let JSON_NEW_KEY = "new"
public let JSON_OLD_KEY = "old"

// MARK: - class

// public func CRKindClass(obj: AnyObject, cla: Any) -> Bool {
//    return obj.isKind(of: type(of: cla))
// }

// public func CRMemberClass(obj: AnyObject, cla: AnyClass) -> Bool {
//    return obj.isMember(of: type(of: cla))
// }

// MARK: - notification

public func CRRegisterNotification(obs: Any, sel: Selector, nam: String) {
    CRRegisterNotification(obs: obs, sel: sel, nam: nam, obj: nil)
}

public func CRRegisterNotification(obs: Any, sel: Selector, nam: String, obj: AnyObject?) {
    NotificationCenter.default.addObserver(obs, selector: sel, name: Notification.Name(nam), object: obj)
}

public func CRUnregisterNotification(obs: Any) {
    NotificationCenter.default.removeObserver(obs)
}

public func CRUnregisterNotification(obs: Any, sel: Selector, nam: String) {
    CRRegisterNotification(obs: obs, sel: sel, nam: nam, obj: nil)
}

public func CRUnregisterNotification(obs: Any, sel: Selector, nam: String, obj: AnyObject?) {
    NotificationCenter.default.removeObserver(obs, name: NSNotification.Name(nam), object: obj)
}

public func CRPostNotification(name: String) {
    CRPostNotification(name: name, obj: nil)
}

public func CRPostNotification(name: String, obj: Any?) {
    CRPostNotification(name: name, obj: obj, info: nil)
}

public func CRPostNotification(name: String, obj: Any?, info: [AnyHashable: Any]?) {
    NotificationCenter.default.post(name: NSNotification.Name(name), object: obj, userInfo: info)
}

// MARK: - image

@discardableResult
public func CRImageFiled(name: String) -> UIImage? {
    return UIImage(contentsOfFile: name)
}

@discardableResult
public func CRImageViewNamed(name: String?) -> UIImageView? {
    return UIImageView(image: UIImage(named: name ?? ""))
}

@discardableResult
public func CRImageViewFiled(path: String) -> UIImageView? {
    return UIImageView(image: CRImageFiled(name: path))
}

// MARK: - device

public let IS_IPHONE5 = UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 640, height: 1136).equalTo(UIScreen.main.currentMode!.size) : false
public let IS_IPHONE6 = UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 750, height: 1334).equalTo(UIScreen.main.currentMode!.size) : false
public let IS_IPHONEPLUS = UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1242, height: 2208).equalTo(UIScreen.main.currentMode!.size) : false

public let IS_IPAD = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
public let kSystemVersion = Float(UIDevice.current.systemVersion)!
public let IS_IOS8 = (kSystemVersion >= Float(8.0) && kSystemVersion <= Float(9.0))
public let IS_IOS9 = (kSystemVersion >= Float(9.0) && kSystemVersion <= Float(10.0))
public let IS_IOS10 = (kSystemVersion >= Float(10.0) && kSystemVersion <= Float(11.0))
public let IS_IOS11 = (kSystemVersion >= Float(11.0) && kSystemVersion <= Float(12.0))
public let IS_IOS12 = (kSystemVersion >= Float(12.0) && kSystemVersion <= Float(13.0))
public let IS_IOS13 = (kSystemVersion >= Float(13.0) && kSystemVersion <= Float(14.0))

// application status
public let CRAPP_IN_BACKGROUND = UIApplication.shared.applicationState == UIApplication.State.background
public func CRDisableAppIdleTimer(flag: Bool) {
    UIApplication.shared.isIdleTimerDisabled = flag
}

//==================network==================
public func CRDisplayNetworkIndicator(flag: Bool) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = flag
}

// MARK: - system

public let CRAppBuild = Bundle.main.infoDictionary![kCFBundleVersionKey as String] as! String
public let CRAppVersionShort = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
public let CRAppName = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String

public let CRIdfa: String = {
    var idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
    if #available(iOS 10.0, *) { // ios10更新之后一旦开启了 设置->隐私->广告->限制广告跟踪之后  获取到的idfa将会是一串00000
        if !ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            if let idfv = CRIdfv {
                idfa = idfv // idfv 是一定可以获取到的
            }
        }
    }
    return idfa
}()

public let CRIdfv = UIDevice.current.identifierForVendor?.uuidString

// MARK: - App Default

public let CRSharedApp = UIApplication.shared
public let CRAppDelegate = CRSharedApp.delegate!

public let CRNotificationCenter = NotificationCenter.default
public let CRCurrentDevice = UIDevice.current
public let CRBundle = Bundle.main
public let CRMainScreen = UIScreen.main
public let CRCurrentLanguage = Locale.preferredLanguages.first
public let CRScreenScaleFactor = CRMainScreen.scale
public let CRFileMgr = FileManager.default
public let CRRunLoop = RunLoop.main
public let CRMainScreenW = CRMainScreen.bounds.width
public let CRMainScreenH = CRMainScreen.bounds.height
//==================user defaults==================
public let CRUserDefaults = UserDefaults.standard
@discardableResult
public func CRUserObj(key: String) -> Any? {
    return CRUserDefaults.object(forKey: key)
}

@discardableResult
public func CRUserBOOL(key: String) -> Bool {
    return CRUserDefaults.bool(forKey: key)
}

@discardableResult
public func CRUserString(key: String) -> String? {
    return CRUserDefaults.string(forKey: key)
}

@discardableResult
public func CRUserInteger(key: String) -> Int {
    return CRUserDefaults.integer(forKey: key)
}

public func CRUserSetObj(obj: Any?, key: String) {
    CRUserDefaults.set(obj, forKey: key)
}

public func CRUserSetBOOL(boo: Bool, key: String) {
    CRUserDefaults.set(boo, forKey: key)
}

public func CRUserSetInteger(inte: Int, key: String) {
    CRUserDefaults.set(inte, forKey: key)
}

public func CRUserRemoveObj(key: String) {
    CRUserDefaults.removeObject(forKey: key)
}

@discardableResult
public func CRUserIsExists(key: String) -> Bool {
    return CRUserDefaults.objectIsForced(forKey: key)
}

// MARK: - Archive

public func CRKeyedUnarchiver(path: String) {
    NSKeyedUnarchiver.unarchiveObject(withFile: path)
}

public func CRKeyedArchiver(obj: Any, path: String) {
    NSKeyedArchiver.archiveRootObject(obj, toFile: path)
}

// MARK: - GCD

//==================block==================
public func CRBackgroundTask(block: @escaping () -> Void) {
    DispatchQueue.global(qos: .background).async {
        block()
    }
}

public func CRMainThreadTask(block: @escaping () -> Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async {
            block()
        }
    }
}

/*
 {[weak self] () -> void in
 if public let strongSelf = self {
 strongSelf.doSomething1()
 }
 }
 {[weak self] () -> void in
 guard public let `self` = self else { return }
 self.doSomething()
 }
 */
public typealias CRVoidBlock = () -> Void
public typealias CRCompletionTask = CRVoidBlock

// MARK: - color

//==================color==================
@discardableResult
public func CRColorWithImagePattern(name: String) -> UIColor {
    return UIColor(patternImage: CRImageFiled(name: name) ?? UIImage())
}

// r, g, b range from 0 - 1.0
@discardableResult
public func CRRGBA(r: Float, g: Float, b: Float, a: Float = 1) -> UIColor {
    return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255), alpha: CGFloat(a))
}

// rgbValue is a Hex vaule without prefix 0x
@discardableResult
public func CRRGBA_X(rgb: Int, a: Float = 1) -> UIColor {
    return CRRGBA(r: Float((rgb & 0xFF0000) >> 16), g: Float((rgb & 0xFF00) >> 8), b: Float(rgb & 0xFF), a: a)
}

// MARK: - execution time

// MARK: - log

// #   define ULOG(fmt, ...)  { \
//    NSString *title = [NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__];  \
//    NSString *msg = [NSString stringWithFormat:fmt, ##__VA_ARGS__];  \
//    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];\
//    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];\
//    [alertCtrl addAction:alertAction];\
//    [CRTopViewController() presentViewController:alertCtrl animated:YES completion:nil];\
// }
