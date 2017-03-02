//
//  HeavyTask.swift
//  BackgroundTask
//
//  Created by Jackie Chung on 25/2/17.
//  Copyright © 2017 ReactiveXYZ. All rights reserved.
//

import Foundation


/// Heavy Task: Do network requests
class HeavyTask : BaseTask {
    
    override init(interval: Int, span: Int) {
        
        super.init(interval: interval, span: span)
    }
    
    override func runTask() -> Void {
        
        for _ in 1...5 {
            
            // send HTTP request to get random quotes
            let urlString = "https://quotesondesign.com/wp-json/posts?filter[orderby]=rand&filter[posts_per_page]=1&callback="
            
            let url = URL(string: urlString)
            
            var request = URLRequest(url: url!)
            
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) {data, response, interval in
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String : AnyObject]]
                    
                    print(json[0]["content"] ?? "NOTHING???")
                    
                } catch let error {
                    
                    print(error)
                    
                }
                
                }.resume()

        }
        
        
    }
    
}
