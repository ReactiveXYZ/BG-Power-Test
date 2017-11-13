//
//  MediumTask.swift
//  BackgroundTask
//
//  Created by Jackie Chung on 25/2/17.
//  Copyright © 2017 ReactiveXYZ. All rights reserved.
//

import Foundation


/// Medium Task: Do CPU arithmetics
class MediumTask : BaseTask {

    override func runTask() -> Void {
        
        // some random calculations
        // looks like arctan(tan(arctan.. can be cpu intensive
        var dict = Dictionary<Int, Double>()
        
        for i in 1...50 {
            
            dict[i] = atan(tan(atan(tan(57 * M_PI / 180))))
        
        }
        
        dict.removeAll()
        
        print("Finished a rounded of calculation")
        
    }
    
    
}
