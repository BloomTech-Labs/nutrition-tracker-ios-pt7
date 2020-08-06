//
//  UserDefaults.swift
//  Nutrivurv
//
//  Created by Dillon on 7/28/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

extension UserDefaults {
    private struct Keys {
        static let dailyLoginStreak = "dailyLoginStreak"
        static let previousLoginDate = "previousLoginDate"
        static let weightUnitPreference = "weightUnitPreference"
        static let heightUnitPreference = "heightUnitPreference"
    }
    
    private class var lastLoginDate: Date? {
        guard let storedValue = UserDefaults.standard.value(forKey: UserDefaults.Keys.previousLoginDate) as? Date else { return nil }
        
        return storedValue
    }
    
    private class var streak: Int {
        return UserDefaults.standard.integer(forKey: UserDefaults.Keys.dailyLoginStreak)
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
        UserDefaults.standard.set(Date(), forKey: UserDefaults.Keys.previousLoginDate)
    }
    
    // Explicitly call upon app close/enter background
    class func updateLoginDateAndStreak() {
        // If the date changed while user's app is running, this will ensure streak iterates properly
        if differenceInDays() == 1 {
            let newStreak = UserDefaults.standard.integer(forKey: UserDefaults.Keys.dailyLoginStreak) + 1
            UserDefaults.standard.set(newStreak, forKey: UserDefaults.Keys.dailyLoginStreak)
        }
        UserDefaults.setLoginDate()
    }
    
    // Explicitly call upon app load
    class func getLoginStreak() -> Int {
        var currentLoginStreak = UserDefaults.standard.integer(forKey: UserDefaults.Keys.dailyLoginStreak)
        
        if let differenceInDays = UserDefaults.differenceInDays() {
            switch differenceInDays {
            case 0:
                // If first time logging in then will be 0. Change it to one and seve to User Defaults.
                if currentLoginStreak == 0 {
                    currentLoginStreak = 1
                    UserDefaults.standard.set(currentLoginStreak, forKey: UserDefaults.Keys.dailyLoginStreak)
                    UserDefaults.setLoginDate()
                    return currentLoginStreak
                } else {
                    // If last login was today, leave streak unchanged and return current streak
                    return currentLoginStreak
                }
            case 1:
                // If last login was yesterday, iterate and update streak value, and update last login to today
                currentLoginStreak += 1
                UserDefaults.standard.set(currentLoginStreak, forKey: UserDefaults.Keys.dailyLoginStreak)
                UserDefaults.setLoginDate()
                return currentLoginStreak
            default:
                // Streak has been broken, therefore reset it to 1 and return value
                currentLoginStreak = 1
                UserDefaults.standard.set(currentLoginStreak, forKey: UserDefaults.Keys.dailyLoginStreak)
                UserDefaults.setLoginDate()
                return currentLoginStreak
            }
        }
        
        // If difference in days doesn't exist, set streak to 1, set login date, and return 1 for the current streak
        UserDefaults.standard.set(1, forKey: UserDefaults.Keys.dailyLoginStreak)
        UserDefaults.setLoginDate()
        return 1
    }
}
