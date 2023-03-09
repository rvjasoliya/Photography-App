//
//  Network.swift
//  Lessons
//
//  Created by iMac on 06/03/23.
//

import Foundation
import Network

class Network: ObservableObject {
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    @Published private(set) var connected: Bool = false
    
    init() {
        checkConnection()
    }
    
    func checkConnection() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self.connected = true
                } else {
                    self.connected = false
                }
            }            
        }
        monitor.start(queue: queue)
    }
    
}
