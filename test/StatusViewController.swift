//
//  StatusViewController.swift
//  BackgroundTask
//
//  Created by Jackie Chung on 26/2/17.
//  Copyright © 2017 Yaro. All rights reserved.
//

import UIKit
import MessageUI

class StatusViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var stopTaskBtn: UIButton!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var batteryConsumptionLabel: UILabel!
    
    @IBOutlet weak var emailDataBtn: UIButton!
    
    public var currentTask: BaseTask? = nil
    
    public var currentTaskType: String? = ""
    
    private var hasFinished: Bool = false
    
    private var batteryConsumed: Float = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // enable battery monitoring
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        // decorate view
        self.decorate()
        
        // start task
        self.startTask()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    @IBAction func dismissOrStop(_ sender: Any) {
        
        if self.hasFinished {
            
            // dismiss view controller
            self.dismiss(animated: true, completion: nil)
            
        } else {
            
            // force stop task
            self.forceStop()
            
        }
        
    }
    
    @IBAction func emailData(_ sender: Any) {
        
        if MFMailComposeViewController.canSendMail() {
            
            let mailComposer = MFMailComposeViewController()
            
            mailComposer.mailComposeDelegate = self
            
            // add basic header data
            mailComposer.setSubject("FST Power consumption test result")
            
            mailComposer.setMessageBody("Device Model: \(UIDevice.current.localizedModel) <br/> Task Type: \(self.currentTaskType) <br/> Task Interval: \(self.currentTask?.getIntervalInMins()) mins <br/> Task Span: \(self.currentTask?.getSpanInHours()) hours <br/>Battery deducted: \(self.batteryConsumed * 100)%", isHTML: true)
            
            mailComposer.setToRecipients(["jackie@reactive.xyz"])
            
            // add log attachment
            if FileManager.default.fileExists(atPath: Logger.shared.logUrl().path) {
                
                if let logData = NSData(contentsOf: Logger.shared.logUrl()) {
                    
                    mailComposer.addAttachmentData(logData as Data, mimeType: "text/plain", fileName: "logs.txt")
                    
                }
                
            }
            
            self.present(mailComposer, animated: true, completion: nil)
            
            
        } else {
            
            let alert = UIAlertView(title: "Cannot send email", message: "Please manually email jackie@reactive.xyz with the test conditions, device model, and battery deducted!", delegate: nil, cancelButtonTitle: "OK, will do")
            
            alert.show()
            
        }
        
    }
    
    internal func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    private func decorate() -> Void {
        
        self.emailDataBtn.layer.cornerRadius = 10.0
        
        self.emailDataBtn.layer.borderWidth = 1.0
        
        self.emailDataBtn.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    private func startTask() -> Void {
        
        // log initial battery percentage
        self.batteryConsumed = UIDevice.current.batteryLevel
        
        // add task finished observer
        NotificationCenter.default.addObserver(self, selector: #selector(taskFinished), name: Notification.Name("task:finished"), object: nil);
        
        // start task
        self.currentTask?.run()
        
        // update label
        self.statusLabel.text = "Running..."
        
        // update button text
        self.stopTaskBtn.setTitle("Stop", for: UIControlState.normal)
        
    }
    
    @objc private func taskFinished() -> Void {
        
        // update label
        self.statusLabel.text = "Finished"
        
        // update button text
        self.stopTaskBtn.setTitle("Dismiss", for: UIControlState.normal)
        
        // update flag
        self.hasFinished = true
        
        // update current battery level
        self.batteryConsumed = self.batteryConsumed - (UIDevice.current.batteryLevel)
        
        // show battery deduction
        self.batteryConsumptionLabel.text = "Battery deducted " + String(self.batteryConsumed * 100)  + "%"
        
        // show email button
        self.emailDataBtn.isHidden = false
        
    }
    
    private func forceStop() -> Void {
        
        // stop the task
        self.currentTask?.stop()
        
        // update finished flag
        self.hasFinished = true
        
        // update status
        self.statusLabel.text = "Force Stopped"
        
        // update task label
        self.stopTaskBtn.setTitle("Dismiss", for: UIControlState.normal)
        
        // force clear current log
        Logger.shared.clear()
    }
    
}
