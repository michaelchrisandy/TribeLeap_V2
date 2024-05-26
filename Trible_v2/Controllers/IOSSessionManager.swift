import Foundation
import WatchConnectivity
import SwiftUI

class IOSSessionManager: NSObject, ObservableObject, WCSessionDelegate {
    @Published var message: String = "No message yet"
    @Published var heartRate: Double = 0.0
    @Published var caloriesBurned: Double = 0.0
    
    override init() {
        super.init()
        
        print("init")
        if WCSession.isSupported() {
            print("berhasil iph")
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    // WCSessionDelegate methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle session activation
        print("iPhone session activated with state: \(activationState.rawValue)")
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        // Handle session becoming inactive
        print("iPhone session inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // Handle session deactivation
        print("iPhone session deactivated")
        session.activate()
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let receivedMessage = message["message"] as? String {
                self.message = receivedMessage
            }
            
//            print("help")
//            
//            if let receivedMessage = message["heartRate"] as? Double {
//                self.heartRate = receivedMessage
//            }
//            if let receivedMessage = message["caloriesBurned"] as? Double {
//                self.caloriesBurned = receivedMessage
//            }
//            
//            print("kekirim")
        }
    }
}
