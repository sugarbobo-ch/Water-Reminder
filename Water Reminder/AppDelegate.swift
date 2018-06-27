//
//  AppDelegate.swift
//  Water Reminder
//
//  Created by ShiFayChy on 23/06/2018.
//  Copyright © 2018 Lin Jin An. All rights reserved.
//

import UIKit
import UserNotifications
//import HealthKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { granted, error in
            if granted {
                print("UserNotifications access")
            }
            else {
                print("UserNotifications denied")
            }
            
        })
        UIApplication.shared.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().delegate = self
        let drink = UNNotificationAction(identifier: "drink", title: "馬上喝", options: [.foreground])
        let drink100 = UNNotificationAction(identifier: "drink100", title: "喝一口", options: [])
        let drink250 = UNNotificationAction(identifier: "drink250", title: "喝一杯水", options: [])
        let category = UNNotificationCategory(identifier: "message", actions: [drink, drink100, drink250], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])

        /*
        if HKHealthStore.isHealthDataAvailable() {
            var shareTypes = Set<HKSampleType>()
            shareTypes.insert(HKObjectType.quantityType(forIdentifier: .dietaryWater)!)
            shareTypes.insert(HKObjectType.quantityType(forIdentifier: .height)!)
            shareTypes.insert(HKObjectType.quantityType(forIdentifier: .bodyMass)!)
            //shareTypes.insert(HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!)
            //shareTypes.insert(HKObjectType.characteristicType(forIdentifier: .biologicalSex)!)
            
            var readTypes = Set<HKObjectType>()
            readTypes.insert(HKObjectType.quantityType(forIdentifier: .dietaryWater)!)
            readTypes.insert(HKObjectType.quantityType(forIdentifier: .height)!)
            readTypes.insert(HKObjectType.quantityType(forIdentifier: .bodyMass)!)
            //readTypes.insert(HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!)
            //readTypes.insert(HKObjectType.characteristicType(forIdentifier: .biologicalSex)!)
            healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) { (success, error) in
                if !success {
                    HealthStore.success = false
                }
                else
                {
                    HealthStore.success = true
                }
            }
        }*/
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler:  @escaping () -> Void) {
        
        let actionIdentifier = response.actionIdentifier
        print("actionIdentifier \(response.actionIdentifier)")
        if actionIdentifier == "drink100" {
            AddWaterAmount(amount: 100)
        }
        else if actionIdentifier == "drink250" {
            AddWaterAmount(amount: 250)
        }

        completionHandler()
    }
    
    func AddWaterAmount(amount: Int){
        UserProfile.readUserProfileFromFile()
        UserProfile.userProfile.drinkAmount += amount
        WaterRecord.readRecordsFromFile()
        let waterData = WaterData(date: Date(), amount: amount)
        WaterRecord.updateAndSaveRecord(waterData: waterData)
        UserProfile.saveToFile()
    }
}

