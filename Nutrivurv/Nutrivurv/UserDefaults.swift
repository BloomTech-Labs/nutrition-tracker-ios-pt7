//
//  UserDefaults.swift
//  Nutrivurv
//
//  Created by Dillon on 7/28/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

extension UserDefaults {
    enum Keys: String, CaseIterable {
        case dailyLoginStreak = "dailyLoginStreak"
        case previousLoginDate = "previousLoginDate"
        case userIdKey = "userIdKey"
        case promptedForHKPermission = "promptedForHKPermission"
        case caloricBudget = "caloricBudget"
        case carbsBudget = "carbsBudget"
        case proteinBudget = "proteinBudget"
        case fatBudget = "fatBudget"
    }
    
    private class var lastLoginDate: Date? {
        guard let storedValue = UserDefaults.standard.value(forKey: Keys.previousLoginDate.rawValue) as? Date else { return nil }
        
        return storedValue
    }
    
    private class var streak: Int {
        return UserDefaults.standard.integer(forKey: Keys.dailyLoginStreak.rawValue)
    }
    
    private class func differenceInDays() -> Int? {
        guard let lastloginDate = lastLoginDate else { return nil }
        let differenceInDays = Calendar.current.dateComponents([.day], from: lastloginDate, to: Date()).day
        
        return differenceInDays
    }
    
    private class func setLoginDate() {
        if differenceInDays() == 0 {
            return
        }
        UserDefaults.standard.set(Date(), forKey: Keys.previousLoginDate.rawValue)
    }
    
    private class func hkDataAvailable() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.promptedForHKPermission.rawValue)
    }
    
    // Explicitly call upon app close/enter background
    class func updateLoginDateAndStreak() {
        // If the date changed while user's app is running, this will ensure streak iterates properly
        if differenceInDays() == 1 {
            let newStreak = UserDefaults.standard.integer(forKey: Keys.dailyLoginStreak.rawValue) + 1
            UserDefaults.standard.set(newStreak, forKey: Keys.dailyLoginStreak.rawValue)
        }
        setLoginDate()
    }
    
    // Explicitly call upon app load
    class func getLoginStreak() -> Int {
        var currentLoginStreak = UserDefaults.standard.integer(forKey: Keys.dailyLoginStreak.rawValue)
        
        if let differenceInDays = differenceInDays() {
            switch differenceInDays {
            case 0:
                // If first time logging in then will be 0. Change it to one and seve to User Defaults.
                if currentLoginStreak == 0 {
                    currentLoginStreak = 1
                    UserDefaults.standard.set(currentLoginStreak, forKey: Keys.dailyLoginStreak.rawValue)
                    setLoginDate()
                    return currentLoginStreak
                } else {
                    // If last login was today, leave streak unchanged and return current streak
                    return currentLoginStreak
                }
            case 1:
                // If last login was yesterday, iterate and update streak value, and update last login to today
                currentLoginStreak += 1
                UserDefaults.standard.set(currentLoginStreak, forKey: Keys.dailyLoginStreak.rawValue)
                setLoginDate()
                return currentLoginStreak
            default:
                // Streak has been broken, therefore reset it to 1 and return value
                currentLoginStreak = 1
                UserDefaults.standard.set(currentLoginStreak, forKey: Keys.dailyLoginStreak.rawValue)
                setLoginDate()
                return currentLoginStreak
            }
        }
        
        // If difference in days doesn't exist, set streak to 1, set login date, and return 1 for the current streak
        UserDefaults.standard.set(1, forKey: Keys.dailyLoginStreak.rawValue)
        setLoginDate()
        return 1
    }
}
