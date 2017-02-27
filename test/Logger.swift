//
//  Logger.swift
//  BackgroundTask
//
//  Created by Jackie Chung on 25/2/17.
//  Copyright © 2017 ReactiveXYZ. All rights reserved.
//

import Foundation


/// A really simple logger that writes data to a text file
class Logger {
    
    static var logFileName = "logs.txt"
    
    static let shared = Logger()

    init() {
        
        // prepare file
        self.createLogIfNotExist()
        
    }
    
    public func log(line: String, newLine: Bool = true) -> Void {
        
        let str = newLine ? line + "\n" : line
        
        let fileUrl = self.logUrl()
        
        do {
            
            let fileHandle = try FileHandle(forWritingTo: fileUrl)
            
            fileHandle.seekToEndOfFile()
            
            fileHandle.write(str.data(using: .utf8)!)
            
            fileHandle.closeFile()
            
        } catch let error {
            
            print(error)
            
        }
        
    }
    
    public func clear() -> Void {
        
        // delete old one
        self.deleteLogIfExist()
        
        // create a new one
        self.createLogIfNotExist()
    }
    
    public func logUrl() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        let documentDirectory = paths[0]
        
        let fileUrl = documentDirectory.appendingPathComponent(Logger.logFileName)
        
        return fileUrl
    }
    
    private func createLogIfNotExist() -> Void {
        
        let fileUrl = self.logUrl()
        
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            
            // create a file
            let str = ""
            
            do {
                
                try str.write(to: fileUrl, atomically: true, encoding: .utf8)
                
            } catch let error {
                
                print(error)
                
            }
            
        }
        
    }
    
    private func deleteLogIfExist() -> Void {
        
        let fileUrl = self.logUrl()
        
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            
            do {
                
                try FileManager.default.removeItem(at: fileUrl)
                
            } catch let error {
                
                print(error)
                
            }
            
        }
        
    }
    
    
    
}
