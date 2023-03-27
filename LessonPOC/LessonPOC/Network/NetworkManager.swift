//
//  NetworkManager.swift
//  LessonPOC
//
//  Created by Abhishek Suryawanshi on 26/03/23.
//

import Foundation
import Network

class NetworkManager {
    
    let monitor = NWPathMonitor()
    var isNetworkAvailable = false
    
    init() {
        self.monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.isNetworkAvailable = true
            } else {
                self.isNetworkAvailable = false
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        self.monitor.start(queue: queue)
    }
}
