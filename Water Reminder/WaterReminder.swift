//
//  WaterReminder.swift
//  Water Reminder
//
//  Created by ShiFayChy on 2018/6/23.
//  Copyright © 2018年 Lin Jin An. All rights reserved.
//

import Foundation

class WaterAlarm: Codable {
    var time: Date
    var enabled: Bool
    
    init(){
        time = Date()
        enabled = false
    }
    
    init(time: Date, enabled: Bool){
        self.time = time
        self.enabled = enabled
    }
    
    static var waterAlarms = Array<WaterAlarm>()
    
    static func readWaterAlarmFromFile() {
        let propertyDecoder = PropertyListDecoder()
        if let data = UserDefaults.standard.data(forKey: "WaterAlarms"),
            let waterAlarms = try? propertyDecoder.decode([WaterAlarm].self, from: data) {
            self.waterAlarms = waterAlarms
            self.waterAlarms.sort(by: { $0.time < $1.time })
        }
    }
    
    static func saveToFile(alarm: [WaterAlarm]) {
        waterAlarms = alarm
        waterAlarms.sort(by: { $0.time < $1.time })
        let propertyEncoder = PropertyListEncoder()
        if let data = try? propertyEncoder.encode(alarm) {
            UserDefaults.standard.set(data, forKey: "WaterAlarms")
        }
    }
    
    static func saveToFile() {
        waterAlarms.sort(by: { $0.time < $1.time })
        print("save, water alarm count: \(waterAlarms.count)")
        let propertyEncoder = PropertyListEncoder()
        if let data = try? propertyEncoder.encode(waterAlarms) {
            UserDefaults.standard.set(data, forKey: "WaterAlarms")
        }
    }
}

class UserProfile: Codable {
    var isMale: Bool
    var age: Int
    var height: Int
    var weight: Int
    var drinkAmount: Int
    var targetAmount: Int
    var lastDrink: Date
    
    init(){
        isMale = true
        age = 0
        height = 0
        weight = 0
        drinkAmount = 0
        targetAmount = 2000
        lastDrink = Date()
    }
    
    static var userProfile = UserProfile()
    
    static func readUserProfileFromFile() -> UserProfile? {
        let propertyDecoder = PropertyListDecoder()
        if let data = UserDefaults.standard.data(forKey: "UserProfile"),
            let userProfile = try? propertyDecoder.decode(UserProfile.self, from: data) {
            self.userProfile = userProfile
            return self.userProfile
        }
        else
        {
            return nil
        }
    }
    
    static func saveToFile(profile: UserProfile) {
        let propertyEncoder = PropertyListEncoder()
        userProfile = profile
        print(userProfile.isMale)
        print(userProfile.age)
        print(userProfile.height)
        print(userProfile.weight)
        print(userProfile.drinkAmount)
        print(userProfile.targetAmount)
        print(userProfile.lastDrink)
        if let data = try? propertyEncoder.encode(profile) {
            UserDefaults.standard.set(data, forKey: "UserProfile")
        }
    }
    
    static func saveToFile() {
        print(userProfile.isMale)
        print(userProfile.age)
        print(userProfile.height)
        print(userProfile.weight)
        print(userProfile.drinkAmount)
        print(userProfile.targetAmount)
        print(userProfile.lastDrink)
        let propertyEncoder = PropertyListEncoder()
        if let data = try? propertyEncoder.encode(userProfile) {
            UserDefaults.standard.set(data, forKey: "UserProfile")
        }
    }
}

class WaterRecord: Codable{
    var date: Date
    var drinkAmount: Int
    var targetAmount: Int
    var achieve: Bool
    var details: Array<WaterData>
    
    static var waterRecords = Array<WaterRecord>()
    static var todayRecord = WaterRecord()
    
    init(){
        date = UserProfile.userProfile.lastDrink
        drinkAmount = UserProfile.userProfile.drinkAmount
        targetAmount = UserProfile.userProfile.targetAmount
        if drinkAmount >= targetAmount {
            achieve = true
        }
        else
        {
            achieve = false
        }
        details = []
    }
    
    static func readRecordsFromFile() -> WaterRecord? {
        let propertyDecoder = PropertyListDecoder()
        if let data = UserDefaults.standard.data(forKey: "History"),
            let waterRecords = try? propertyDecoder.decode([WaterRecord].self, from: data) {
            self.waterRecords = waterRecords
            self.todayRecord = waterRecords.last!
            return self.todayRecord
        }
        else
        {
            return nil
        }
    }
    
    static func removeRecord(){
        todayRecord.drinkAmount = 0
        todayRecord.details.removeAll()
        if waterRecords.count != 0{
            waterRecords[waterRecords.count - 1] = todayRecord
        }
        saveToFile()
    }
    
    static func updateAndSaveRecord(waterData: WaterData){
        todayRecord.drinkAmount = UserProfile.userProfile.drinkAmount
        todayRecord.targetAmount = UserProfile.userProfile.targetAmount
        if todayRecord.drinkAmount < todayRecord.targetAmount
        {
            todayRecord.achieve = false
        }
        else
        {
            todayRecord.achieve = true
        }
        print("todayRecord.achieve: \(todayRecord.achieve)")
        todayRecord.details.append(waterData)
        waterRecords[waterRecords.count - 1] = todayRecord
        saveToFile()
    }
    
    static func saveToFile() {
        let propertyEncoder = PropertyListEncoder()
        if let data = try? propertyEncoder.encode(waterRecords) {
            UserDefaults.standard.set(data, forKey: "History")
        }
    }
}

struct WaterData: Codable{
    var date: Date
    var amount: Int
}

class Utility {
    static var tableCellIndex = -1
    static var alarmIndex = -1
}


