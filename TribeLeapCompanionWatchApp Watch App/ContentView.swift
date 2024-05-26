//
//  ContentView.swift
//  WatchTracker Watch App
//
//  Created by Michael Chrisandy on 21/05/24.
//


import SwiftUI
import HealthKitUI

struct ContentView: View {
    
    @StateObject private var watchSessionManager = WatchSessionManager()
    @StateObject private var healthManager = HealthManager()
    @StateObject private var workoutManager = WorkoutManager()
    
    let healthStore = HKHealthStore()
    
    let allTypes: Set = [
        HKQuantityType.workoutType(),
        HKQuantityType(.activeEnergyBurned),
        HKQuantityType(.heartRate)
    ]
    
    
    @State private var isAuthorized = false
    @State private var authenticated = false
    
    var body: some View {
        VStack {
            Button(action: {
                watchSessionManager.sendMessageToiPhone(heartRate: workoutManager.heartRate, activeEnergyBurned: workoutManager.activeEnergyBurned)
                
//                print(workoutManager.heartRate)
            }) {
                Text("Send Message")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            if isAuthorized {
                VStack {
                    Text("Heart Rate: \(workoutManager.heartRate, specifier: "%.0f") BPM")
                        .padding()
                    
                    Text("Active Energy Burned: \(workoutManager.activeEnergyBurned, specifier: "%.0f") kcal")
                        .padding()
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                    
                    
                    Button(action: {
                        workoutManager.startWorkout()
                    }) {
                        Text("Start Workout")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        workoutManager.stopWorkout()
                        print("stop workout 1")
                    }) {
                        Text("Stop Workout")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                }
            } else {
                Text("Requesting HealthKit Authorization...")
                    .onAppear {
                        healthManager.requestAuthorization { success, error in
                            DispatchQueue.main.async {
                                self.isAuthorized = success
                            }
                        }
                    }
            }
            
        }
        .onDisappear{
            workoutManager.stopWorkout()
            print("stop workout")
        }
        .onAppear() {
            
            // Check that Health data is available on the device.
            if HKHealthStore.isHealthDataAvailable() {
                // Modifying the trigger initiates the health data
                // access request.
                isAuthorized.toggle()
            }
        }
        .healthDataAccessRequest(store: healthStore,
                                 shareTypes: allTypes,
                                 readTypes: allTypes,
                                 trigger: isAuthorized) { result in
            switch result {
                
            case .success(_):
                authenticated = true
            case .failure(let error):
                // Handle the error here.
                fatalError("*** An error occurred while requesting authentication: \(error) ***")
            }
        }
    }
    
}
#Preview {
    ContentView()
}

