//
//  Utility.swift
//  CRBoostSwift
//
//  Created by SGMWH on 2019/6/19.
//

import UIKit

public class Utility {
    // MARK: - directory

    @discardableResult
    public class func documentDirectory() -> String {
        let listDocument = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return listDocument.last!
    }

    @discardableResult
    public class func libraryDirectory() -> String {
        let listLibrary = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        return listLibrary.last!
    }

    @discardableResult
    public class func cachesDirectory() -> String {
        let listCaches = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        return listCaches.last!
    }

    @discardableResult
    public class func tempDirectory() -> String {
        let tempPath = NSTemporaryDirectory()
        ensureExistsOfDirectory(dirPath: tempPath)
        return tempPath
    }

    @discardableResult
    public class func ensureExistsOfDirectory(dirPath: String) -> Bool {
        var isDir = ObjCBool(false)
        if !FileManager.default.fileExists(atPath: dirPath, isDirectory: &isDir) || !isDir.boolValue {
            do {
                try FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("createDirectory error :\(error.localizedDescription)")
            }
        }
        return true
    }

    @discardableResult
    public class func ensureExistsOfFile(path: String) -> Bool {
        var isDir = ObjCBool(false)
        if FileManager.default.fileExists(atPath: path, isDirectory: &isDir) && !isDir.boolValue {
            return true
        }
        let dir = (path as NSString).deletingLastPathComponent
        ensureExistsOfDirectory(dirPath: dir)
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            print("createDirectory error :\(error.localizedDescription)")
            return false
        }
    }

    // MARK: - path

    @discardableResult
    public class func bundlePath() -> String! {
        return Bundle.main.resourcePath
    }

    @discardableResult
    public class func pathOfBundleFile(path: String) -> String {
        let fillPath = bundlePath() as NSString
        return fillPath.appendingPathComponent(path)
    }

    // MARK: - GCD

    public class func performeBackgroundTask(backgroundBlock: (() -> Void)?, beforeMainTask: (() -> Void)?) {
        DispatchQueue.global(qos: .userInitiated).async {
            backgroundBlock?()
            DispatchQueue.main.async {
                beforeMainTask?()
            }
        }
    }

    public class func main(task: @escaping CRVoidBlock) {
        if Thread.isMainThread {
            task()
        } else {
            DispatchQueue.main.async {
                task()
            }
        }
    }

    // MARK: - View

    public class func presentView(view: UIView, animated: Bool) {
        let root = CRRootView()
        view.alpha = 0.001
        root.addSubview(view)
        let duration = animated ? 0.3 : 0
        UIView.animate(withDuration: duration, delay: 0, options: [], animations: {
            view.alpha = 1
        }, completion: nil)
    }

    // MARK: - storyboard

    public class func controllerInStoryboard(storyboard: String, identifier: String) -> UIViewController {
        let ontroller = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier)
        return ontroller
    }

    // MARK: - goUrl

    public class func goStringUrl(_ str: String?) {
        guard var trimStr = str else { return }
        trimStr = trimStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        goURL(URL(string: trimStr))
    }

    public class func goURL(_ url: URL?) {
        guard let trimUrl = url else { return }
        if UIApplication.shared.canOpenURL(trimUrl) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(trimUrl, options: [:]) { _ in
                }
            } else {
                UIApplication.shared.openURL(trimUrl)
            }
        }
    }
}
