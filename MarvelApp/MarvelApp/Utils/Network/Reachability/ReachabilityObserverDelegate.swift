//
//  ReachabilityObserverDelegate.swift
//  MarvelApp
//
//  Created by Navpreet Kailay on 31/10/22.
//

import Foundation
import Reachability
//Reachability
//declare this property where it won't go out of scope relative to your listener
fileprivate var reachability: Reachability!

protocol ReachabilityActionDelegate {
    func reachabilityChanged(_ isReachable: Bool)
}

protocol ReachabilityObserverDelegate: AnyObject, ReachabilityActionDelegate {
    func addReachabilityObserver() throws
    func removeReachabilityObserver()
}

// Declaring default implementation of adding/removing observer
extension ReachabilityObserverDelegate {
    /** Subscribe on reachability changing */
    func addReachabilityObserver() throws {
        reachability = try Reachability()
        reachability.whenReachable = { [weak self] reachability in
            self?.reachabilityChanged(true)
        }
        reachability.whenUnreachable = { [weak self] reachability in
            self?.reachabilityChanged(false)
        }
        try reachability.startNotifier()
    }
    /** Unsubscribe */
    func removeReachabilityObserver() {
        reachability.stopNotifier()
        reachability = nil
    }
}
