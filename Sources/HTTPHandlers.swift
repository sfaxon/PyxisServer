//
//  HTTPHandlers.swift
//  PyxisEchoC
//
//  Created by Seth Faxon on 6/28/15.
//  Copyright © 2015 SlashAndBurn. All rights reserved.
//

import Foundation

//public class HttpHandlers {
//    
//    public class func directory(dir: String) -> ( HttpRequest -> HttpResponse ) {
//        return { request in
//            let dirNSString = dir as NSString
//            if let localPath = request.capturedUrlGroups.first {
//                let tPath = dirNSString.stringByExpandingTildeInPath as NSString
//                let filesPath = tPath.stringByAppendingPathComponent(localPath)
//                if let fileBody = NSData(contentsOfFile: filesPath) {
//                    return SimpleResponse.RAW(200, NSString(data: fileBody, encoding: NSUTF8StringEncoding)! as String)
//                }
//            }
//            return SimpleResponse.NotFound(.HTML("<h1>File not found (404)</h1>"))
//        }
//    }
//    
//    public class func directoryBrowser(dir: String) -> ( HttpRequest -> HttpResponse ) {
//        return { request in
//            let dirNSString = dir as NSString
//            if let pathFromUrl = request.capturedUrlGroups.first {
//                let tPath = dirNSString.stringByExpandingTildeInPath as NSString
//                let filePath = tPath.stringByAppendingPathComponent(pathFromUrl)
//                let fileManager = NSFileManager.defaultManager()
//                var isDir: ObjCBool = false;
//                if ( fileManager.fileExistsAtPath(filePath, isDirectory: &isDir) ) {
//                    if ( isDir ) {
//                        do {
//                            let files = try fileManager.contentsOfDirectoryAtPath(filePath)
//                            var response = "<h3>\(filePath)</h3></br><table>"
//                            
//                            response += files.map( { "<tr><td><a href=\"\(request.url)/\($0)\">\($0)</a></td></tr>"} ).joinWithSeparator("\n")
//                            response += "</table>"
//                            return SimpleResponse.OK(.HTML(response))
//                        } catch  {
//                            return SimpleResponse.NotFound(.HTML("<h1>File not found (404)</h1>"))
//                        }
//                    } else {
//                        if let fileBody = NSData(contentsOfFile: filePath) {
//                            return SimpleResponse.RAW(200, NSString(data: fileBody, encoding: NSUTF8StringEncoding)! as String)
//                        }
//                    }
//                }
//            }
//            return SimpleResponse.NotFound(.HTML("<h1>File not found (404)</h1>"))
//        }
//    }
//}
