//
//  Task.swift
//  BackgroundTask
//
//  Created by Jackie Chung on 25/2/17.
//  Copyright © 2017 ReactiveXYZ. All rights reserved.
//
import Foundation
import UserNotifications

class BaseTask {
    
    var interval: Int
    
    var span: Int
    
    private var numTasksRun: Int = 0
    
    private var timer: Timer = Timer()
    
    private var background: Background = Background()
    
    init(interval: Int, span: Int) {
        
        // inject dependency
        self.interval = interval
        self.span = span
        
    }
    
    public func getIntervalInMins() -> Int {
        
        return self.interval / 60
        
    }
    
    public func getSpanInHours() -> Int {
        
        return self.span / 3600
        
    }
    
    public func run() -> Void {
        
        // clear previous log
        Logger.shared.clear()
        
        // start background loop
        self.background.start()
        
        // schedule timer
        self.scheduleTimer()
        
    }
    
    public func stop() -> Void {
        
        // stop background loop
        self.background.stop()
        
        // invalidate timer
        self.timer.invalidate()
        
    }
    
    public func runTask() {
        
        fatalError("Please use the subclass run task!")
        
    }
    
    private func scheduleTimer() -> Void {
        
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.interval), target: self, selector: #selector(self.triggerTask), userInfo: nil, repeats: true);
        
    }
    
    @objc private func triggerTask() -> Void {
        
        self.stopIfNecessary()
    
        self.runTask()
        
        // log task
        Logger.shared.log(line: "Task run #\(self.numTasksRun)")
        
    }
    
    
    private func stopIfNecessary() -> Void {
        
        self.numTasksRun = self.numTasksRun + 1
        
        if self.numTasksRun * self.interval >= self.span {
            
            self.stop()
            
            // post a notification when finished
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "task:finished")))
            
            // show a local notification
            if #available(iOS 10.0, *) {
                
                // notification content
                let content = UNMutableNotificationContent()
                content.title = "Task Finished"
                content.body = "Click in to send the data"
                content.sound = UNNotificationSound.default()
                
                // send notification request
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest(identifier: "task:finished", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
        
    }
    
    
    
}
