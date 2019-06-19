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
let CRNull = NSNull()

//==================date==================
let CRCOMPS_DATE: NSCalendar.Unit = [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day]
let CRCOMPS_TIME: NSCalendar.Unit = [NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second]

// MARK: - Default

let kBracketBigBegin = "{"
let kBracketBigEnd = "}"
let kSeparatorComma = ","
let kSeparatorSlash = "/"
let kSeparatorDot = "."
let kSymbolQuestion = "?"
let kSeparatorBitAnd = "&"
let kSymbolEqual = "="
let kWhitespace = " "
let kEmptyString = ""
let kSeparatorSolidDot = "●"

// range

let JSON_RANGE_KEY = "range"

// color
let JSON_COLOR_KEY = "color"
// style
let JSON_STYLE_KEY = "style"
// size
let JSON_SIZE_KEY = "size"
let JSON_WIDTH_KEY = "width"
let JSON_HEIGHT_KEY = "height"
let JSON_NEW_KEY = "new"
let JSON_OLD_KEY = "old"

// MARK: - class

func CRKindClass(obj: AnyObject, cla: AnyClass) -> Bool {
    return obj.isKind(of: cla.self)
}

func CRMemberClass(obj: AnyObject, cla: AnyClass) -> Bool {
    return obj.isMember(of: cla.self)
}

// MARK: - notification

func CRRegisterNotification(obs: Any, sel: Selector, nam: String) {
    CRRegisterNotification(obs: obs, sel: sel, nam: nam, obj: nil)
}

func CRRegisterNotification(obs: Any, sel: Selector, nam: String, obj: AnyObject?) {
    NotificationCenter.default.addObserver(obs, selector: sel, name: Notification.Name(nam), object: obj)
}

func CRUnregisterNotification(obs: Any) {
    NotificationCenter.default.removeObserver(obs)
}

func CRUnregisterNotification(obs: Any, sel: Selector, nam: String) {
    CRRegisterNotification(obs: obs, sel: sel, nam: nam, obj: nil)
}

func CRUnregisterNotification(obs: Any, sel: Selector, nam: String, obj: AnyObject?) {
    NotificationCenter.default.removeObserver(obs, name: NSNotification.Name(nam), object: obj)
}

func CRPostNotification(name: String) {
    CRPostNotification(name: name, obj: nil)
}

func CRPostNotification(name: String, obj: Any?) {
    CRPostNotification(name: name, obj: obj, info: nil)
}

func CRPostNotification(name: String, obj: Any?, info: [AnyHashable: Any]?) {
    NotificationCenter.default.post(name: NSNotification.Name(name), object: obj, userInfo: info)
}

// MARK: - image

func CRImageFiled(name: String) -> UIImage? {
    return UIImage(contentsOfFile: name)
}

func CRImageViewNamed(name: String?) -> UIImageView? {
    return UIImageView(image: UIImage(named: name ?? ""))
}

func CRImageViewFiled(path: String) -> UIImageView? {
    return UIImageView(image: CRImageFiled(name: path))
}

// MARK: - device

let IS_IPHONE5 = UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 640, height: 1136).equalTo(UIScreen.main.currentMode!.size) : false
let IS_IPHONE6 = UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 750, height: 1334).equalTo(UIScreen.main.currentMode!.size) : false
let IS_IPHONEPLUS = UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1242, height: 2208).equalTo(UIScreen.main.currentMode!.size) : false

let IS_IPAD = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
let kSystemVersion = Float(UIDevice.current.systemVersion)!
let IS_IOS8 = (kSystemVersion >= Float(8.0) && kSystemVersion <= Float(9.0))
let IS_IOS9 = (kSystemVersion >= Float(9.0) && kSystemVersion <= Float(10.0))
let IS_IOS10 = (kSystemVersion >= Float(10.0) && kSystemVersion <= Float(11.0))
let IS_IOS11 = (kSystemVersion >= Float(11.0) && kSystemVersion <= Float(12.0))
let IS_IOS12 = (kSystemVersion >= Float(12.0) && kSystemVersion <= Float(13.0))
let IS_IOS13 = (kSystemVersion >= Float(13.0) && kSystemVersion <= Float(14.0))

// application status
let CRAPP_IN_BACKGROUND = UIApplication.shared.applicationState == UIApplicationState.background
func CRDisableAppIdleTimer(flag: Bool) {
    UIApplication.shared.isIdleTimerDisabled = flag
}

//==================network==================
func CRDisplayNetworkIndicator(flag: Bool) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = flag
}

// MARK: - system

let CRAppBuild = Bundle.main.infoDictionary![kCFBundleVersionKey as String] as! String
let CRAppVersionShort = Bundle.main.infoDictionary!["CRAppVersionShort"] as! String
let CRAppName = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String

let CRIdfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
let CRIdfv = UIDevice.current.identifierForVendor?.uuidString

// MARK: - App Default

let CRSharedApp = UIApplication.shared
let CRAppDelegate = CRSharedApp.delegate!

let CRNotificationCenter = NotificationCenter.default
let CRCurrentDevice = UIDevice.current
let CRBundle = Bundle.main
let CRMainScreen = UIScreen.main
let CRCurrentLanguage = Locale.preferredLanguages.first
let CRScreenScaleFactor = CRMainScreen.scale
let CRFileMgr = FileManager.default
let CRRunLoop = RunLoop.main
let CRMainScreenW = CRMainScreen.bounds.width
let CRMainScreenH = CRMainScreen.bounds.height
//==================user defaults==================
let CRUserDefaults = UserDefaults.standard
func CRUserObj(key: String) -> Any? {
    return CRUserDefaults.object(forKey: key)
}

func CRUserBOOL(key: String) -> Bool {
    return CRUserDefaults.bool(forKey: key)
}

func CRUserObj(key: String) -> String? {
    return CRUserDefaults.string(forKey: key)
}

func CRUserInteger(key: String) -> Int {
    return CRUserDefaults.integer(forKey: key)
}

func CRUserSetObj(obj: Any?, key: String) {
    CRUserDefaults.set(obj, forKey: key)
}

func CRUserSetBOOL(boo: Bool, key: String) {
    CRUserDefaults.set(boo, forKey: key)
}

func CRUserSetInteger(inte: Int, key: String) {
    CRUserDefaults.set(inte, forKey: key)
}

func CRUserRemoveObj(key: String) {
    CRUserDefaults.removeObject(forKey: key)
}

func CRUserIsExists(key: String) -> Bool {
    return CRUserDefaults.objectIsForced(forKey: key)
}
// MARK: - Archive
