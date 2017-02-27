//
//  LightTask.swift
//  BackgroundTask
//
//  Created by Jackie Chung on 25/2/17.
//  Copyright © 2017 ReactiveXYZ. All rights reserved.
//

import Foundation


/// Light task: Simply print a console log
class LightTask : BaseTask {
    
    
    override init(interval: Int, span: Int) {
        
        super.init(interval: interval, span: span)
        
    }

    override func runTask() -> Void {
        
        print("I AM PRINTTING A BUNCH OF LOGS!!!")
        
    }
    
    
}
