//
//  WatchSessionManager.swift
//  WatchTracker Watch App
//
//  Created by Michael Chrisandy on 21/05/24.
//

import Foundation
import WatchConnectivity
import SwiftUI

class WatchSessionManager: NSObject, ObservableObject, WCSessionDelegate {
    @Published var message: String = "No message yet"
    @Published var heartRate: Double = 0.0
    @Published var caloriesBurned: Double = 0.0
    
    @StateObject private var workoutManager = WorkoutManager()

    override init() {
        super.init()
        if WCSession.isSupported() {
            print("berhasil watch")
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func sendMessageToiPhone(heartRate: Double, activeEnergyBurned: Double) {
        if WCSession.default.isReachable {
            let message = ["message": "Hello, iPhone!"]
            
//            let message =
//                ["heartRate" : self.workoutManager.heartRate,
//                 "caloriesBurned" : self.workoutManager.activeEnergyBurned
//                ]
            
            WCSession.default.sendMessage(message, replyHandler: nil) { error in
                print("Error sending message: \(error.localizedDescription)")
            }
        } else {
            print("iPhone is not reachable")
        }
    }

    // WCSessionDelegate methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle session activation
        print("Watch session activated with state: \(activationState.rawValue)")
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        // Handle session reachability change
        print("Watch session reachability changed: \(session.isReachable)")
    }

//    func sessionDidBecomeInactive(_ session: WCSession) {
//        // Handle session becoming inactive
//        print("Watch session inactive")
//    }
//
//    func sessionDidDeactivate(_ session: WCSession) {
//        // Handle session deactivation
//        print("Watch session deactivated")
//        session.activate()
//    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let receivedMessage = message["heartRate"] as? Double {
                self.heartRate = receivedMessage
            }
            if let receivedMessage = message["caloriesBurned"] as? Double {
                self.caloriesBurned = receivedMessage
            }
        }
    }
}
