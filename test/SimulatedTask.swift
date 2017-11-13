//
//  SimulatedTask.swift
//  BackgroundTask
//
//  Created by Jackie Chung on 12/11/17.
//  Copyright © 2017 ReactiveXYZ. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class SimulatedTask: BaseTask {
    
    var serviceBrowser: MCNearbyServiceBrowser!
    
    ///An object that handles broadcasting one's presence on the network.
    var serviceAdvertiser: MCNearbyServiceAdvertiser!
    
    ///`true` if this object is currently browsing.
    var isBrowsing: Bool = true
    ///`true` if this object is currently advertising.
    var isAdvertising: Bool = true
    
    //MARK: Convenience methods
    ///Begins advertising the current peer on the network.
    func startAdvertisingPeer() {
        serviceAdvertiser.startAdvertisingPeer()
        isAdvertising = true
    }
    
    ///Stops advertising the current peer.
    func stopAdvertisingPeer() {
        serviceAdvertiser.stopAdvertisingPeer()
        isAdvertising = false
    }
    
    ///Begins browsing for other peers on the network.
    func startBrowsingForPeers() {
        serviceBrowser.startBrowsingForPeers()
        isBrowsing = true
    }
    
    ///Stops browsing for other peers.
    func stopBrowsingForPeers() {
        serviceBrowser.stopBrowsingForPeers()
        isBrowsing = false
    }
    
    override func runTask() -> Void {
        // TODO...
        // Basically this function will be called with the selected interval
        // on the first screen
        // So now, I think you will need to implement the MC Peer connectivity
        // framework methods in this class and call start/stopAdvertising() or any
        // other functions you want to measure power consumption in this method
        
        ///An object that handles searching for and finding other phones on the network.
        startAdvertisingPeer();
        startBrowsingForPeers();
        
        
    }
    
}
