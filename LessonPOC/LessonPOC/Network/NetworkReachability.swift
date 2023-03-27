//
//  NetworkReachability.swift
//  LessonPOC
//
//  Created by Abhishek Suryawanshi on 26/03/23.
//
import Foundation
import SystemConfiguration

class NetworkReachability {

    var reachability: SCNetworkReachability?
    
    init?() {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let reachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return nil
        }
        
        self.reachability = reachability
    }
    
    func start() -> Bool {
        var context = SCNetworkReachabilityContext()
        context.info = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        
        guard let reachability = reachability, SCNetworkReachabilitySetCallback(reachability, { (target, flags, info) in
            guard let info = info else { return }
            let instance = Unmanaged<NetworkReachability>.fromOpaque(info).takeUnretainedValue()
            instance.statusDidChange()
        }, &context) else {
            return false
        }
        
        return SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
    }
    
    func stop() -> Bool {
        guard let reachability = reachability else {
            return false
        }
        
        return SCNetworkReachabilityUnscheduleFromRunLoop(reachability, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
    }
    
    func statusDidChange() {
        // Override this method in a subclass to respond to changes in network reachability status
    }
    
    deinit {
        stop()
    }
}
