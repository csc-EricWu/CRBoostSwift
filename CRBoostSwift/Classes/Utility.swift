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

   public class func documentDirectory() ->String{
        let listDocument = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return listDocument.last!
    }
    @discardableResult

    public class func libraryDirectory() ->String{
        let listLibrary = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        return listLibrary.last!
    }
    @discardableResult

    public class func cachesDirectory() ->String{
        let listCaches = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        return listCaches.last!
    }
    @discardableResult

    public class func tempDirectory() ->String{
        let tempPath = NSTemporaryDirectory()
        ensureExistsOfDirectory(dirPath: tempPath)
        return tempPath
    }
    @discardableResult
    public class func ensureExistsOfDirectory(dirPath:String) ->Bool{
        var isDir = ObjCBool(false)
        if (!FileManager.default.fileExists(atPath: dirPath, isDirectory: &isDir) || !isDir.boolValue ) {
            do
            {
                try FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch
            {
                print("createDirectory error :\(error.localizedDescription)")
            }
        }
        return true
    }
    @discardableResult
    public class func ensureExistsOfFile(path:String) ->Bool{
        var isDir = ObjCBool(false)
        if FileManager.default.fileExists(atPath: path, isDirectory: &isDir) && !isDir.boolValue {
            return true
        }
        let dir = (path as NSString).deletingLastPathComponent
        ensureExistsOfDirectory(dirPath: dir)
        do
        {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return true
        }
        catch
        {
            print("createDirectory error :\(error.localizedDescription)")
            return false
        }
    }
    // MARK: - path
    class func bundlePath()->String!
    {
        return Bundle.main.resourcePath
    }
    @discardableResult
    public class func pathOfBundleFile(path:String) ->String{
        let fillPath = bundlePath() as NSString
        return fillPath.appendingPathComponent(path)
    }
    
    // MARK: - GCD
    public class func performeBackgroundTask(backgroundBlock: ()->Void?,beforeMainTask: ()->Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            if backgroundBlock != nil {
                backgroundBlock()
            }
            DispatchQueue.main.async {
                if beforeMainTask != nil {
                    beforeMainTask()
                }
            }
        }
    }


    
    // MARK: - View

    // MARK: - interaction

}
