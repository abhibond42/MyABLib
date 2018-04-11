//
//  LogTest.swift
//  MyABLib
//
//  Created by Ahirema1 on 11/04/18.
//  Copyright © 2018 tt. All rights reserved.
//

import Foundation


class LogTest {
    
    private static let fileSize: UInt64 = 1024 * 1024 // 1 MB
    private static var charsWritten: UInt64 = 0
    private static let fileName = "LogTest.log"
    private static var dateFormatter = DateFormatter()
    private static var fileHandle: FileHandle?
    private static var filePath = ""
    
    class func writeLog(msg: String) {
        //if Debug build logs enabled by defaut always
        #if DEBUG
        NSLog(  msg)
        printLog(msg: msg)
        #else
        //if it is Release build logs enabled based on api signature
        let debug = MoEngageUtil.sharedInstance.LogsEnabled
        if debug {
            NSLog(  msg)
            printLog(msg: msg)
        }
        #endif
    }
    
    class func getFilePath() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/" + fileName
    }
    
    private class func printLog(msg: String) {
        initialize()
        let date = dateFormatter.string(from: NSDate() as Date)
        let line = "\(date) \(msg)\n"
        let chars = UInt64(line.count)
        if (chars + charsWritten) >= fileSize {
            fileHandle?.seek(toFileOffset: 0)
            charsWritten = 0
        }
        charsWritten += chars
        fileHandle?.write(line.data(using: String.Encoding.utf8)!)
        
    }
    
    private class func initialize() {
        if nil == fileHandle {
            filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/" + fileName
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: filePath) {
                fileManager.createFile(atPath: filePath, contents: nil, attributes: nil)
            }
            fileHandle = FileHandle(forUpdatingAtPath: filePath)
            charsWritten = (fileHandle?.seekToEndOfFile())!
            dateFormatter.locale = NSLocale.system
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
    }
    
}
