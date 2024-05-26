import HealthKit

class HealthManager: ObservableObject {
    let healthStore = HKHealthStore()
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let typesToShare: Set = [
            HKObjectType.workoutType(),
            HKQuantityType(.heartRate),
            HKQuantityType(.activeEnergyBurned)
        ]
        
//        let typesToRead: Set = [
//            HKObjectType.quantityType(forIdentifier: .heartRate)!
//        ]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToShare) { (success, error) in
            completion(success, error)
        }
    }
}
