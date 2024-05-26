import HealthKit

class WorkoutManager: NSObject, ObservableObject, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    private var healthStore: HKHealthStore
    private var session: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?
    
    @Published var heartRate: Double = 0.0
    @Published var activeEnergyBurned: Double = 0.0
    
    override init() {
        healthStore = HKHealthStore()
    }
    
    func startWorkout() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .jumpRope
        configuration.locationType = .indoor
        
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
            
            session?.delegate = self
            builder?.delegate = self
            
            builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
            
            session?.startActivity(with: Date())
            builder?.beginCollection(withStart: Date(), completion: { (success, error) in
                // Handle the start of the workout
            })
        } catch {
            // Handle any errors
        }
    }
    
    func stopWorkout() {
        session?.end()
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        if toState == .ended {
            print("The workout has now ended.")
            builder?.endCollection(withEnd: Date()) { (success, error) in
                self.builder?.finishWorkout { (workout, error) in
                    // Optionally display a workout summary to the user.
//                    self.resetWorkout()
                }
            }
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        // Handle errors
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        // Handle events
    }
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate),
              let activeEnergyBurnedType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            return
        }
        
        if collectedTypes.contains(heartRateType) {
            if let statistics = workoutBuilder.statistics(for: heartRateType) {
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                let heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit)
                DispatchQueue.main.async {
                    self.heartRate = heartRate ?? 0.0
                }
            }
        }
        
        if collectedTypes.contains(activeEnergyBurnedType) {
            if let statistics = workoutBuilder.statistics(for: activeEnergyBurnedType) {
                let activeEnergyBurnedUnit = HKUnit.kilocalorie()
                let activeEnergyBurned = statistics.sumQuantity()?.doubleValue(for: activeEnergyBurnedUnit)
                DispatchQueue.main.async {
                    self.activeEnergyBurned = activeEnergyBurned ?? 0.0
                }
            }
        }
        
    }
    
    
}
//
//extension WorkoutManager {
//    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState,
//                        from fromState: HKWorkoutSessionState, date: Date) {
//        // Wait for the session to transition states before ending the builder.
//        /// - Tag: SaveWorkout
//        if toState == .ended {
//            print("The workout has now ended.")
//            builder.endCollection(withEnd: Date()) { (success, error) in
//                self.builder.finishWorkout { (workout, error) in
//                    // Optionally display a workout summary to the user.
//                    self.resetWorkout()
//                }
//            }
//        }
//    }
//
//    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
//
//    }
//}
