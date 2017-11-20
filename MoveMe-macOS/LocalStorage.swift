import Foundation

struct LocalStorage {
    private static let NUMBER_OF_MINUTES_KEY = "NUMBER_OF_MINUTES_KEY"
    
    static func saveNumberOfMinutes(minutes: Int) {
        UserDefaults.standard.set(minutes, forKey: NUMBER_OF_MINUTES_KEY)
    }
    
    static func loadNumberOfMinutes() -> Int {
        return UserDefaults.standard.integer(forKey: NUMBER_OF_MINUTES_KEY)
    }
}
