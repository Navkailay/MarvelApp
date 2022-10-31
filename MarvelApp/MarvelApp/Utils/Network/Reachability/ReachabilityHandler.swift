//
//  ReachabilityHandler.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 31/10/22.
//

import Foundation

class ReachabilityHandler: ReachabilityObserverDelegate {
    
    //MARK: Lifecycle
    
    required init() {
        try? addReachabilityObserver()
    }
    
    deinit {
        removeReachabilityObserver()
    }
    
    //MARK: Reachability
    
    func reachabilityChanged(_ isReachable: Bool) {
        if !isReachable {
            print("No internet connection")
        }
    }
}
