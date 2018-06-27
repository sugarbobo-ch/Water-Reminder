//
//  FileLoadController.swift
//  Water Reminder
//
//  Created by ShiFayChy on 2018/6/23.
//  Copyright © 2018年 Lin Jin An. All rights reserved.
//

import UIKit
import HealthKit

class FileLoadController: UIViewController {

    @IBAction func returnToWaterAmount(segue: UIStoryboardSegue)
    {
        print("returnToWaterAmount")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Load file")
        if(UserProfile.readUserProfileFromFile() == nil){
            print("User profile does not exist.")
            performSegue(withIdentifier: "setUserProfile", sender:nil)
        }
        else
        {
            print("Get user profile")
            WaterRecord.readRecordsFromFile()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
            let lastDrinkString = dateFormatter.string(from: UserProfile.userProfile.lastDrink as Date)
            let now = Date()
            let nowString = dateFormatter.string(from: now as Date)
            print("Old date: \(lastDrinkString) Now: \(nowString)")
            if nowString != lastDrinkString || WaterRecord.waterRecords.count == 0
            {
                print("A new date, reset water amount")
                ResetWaterAmount()
                let newRecord = WaterRecord()
                WaterRecord.todayRecord = newRecord
                WaterRecord.waterRecords.append(newRecord)
                WaterRecord.saveToFile()
            }
            UpdateWaterAmountDisplays()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var waterButton50ml: UIButton!
    @IBOutlet weak var waterButton100ml: UIButton!
    @IBOutlet weak var waterButton250ml: UIButton!
    @IBOutlet weak var waterButton600ml: UIButton!
    @IBOutlet weak var waterButton1000ml: UIButton!
    @IBOutlet weak var waterButtonCustom: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var waterAmountLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBAction func selectRoleButtonPressed(_ sender: UIButton) {
        switch sender {
        case waterButton50ml:
            AddWaterAmount(amount: 50)
        case waterButton100ml:
            AddWaterAmount(amount: 100)
        case waterButton250ml:
            AddWaterAmount(amount: 250)
        case waterButton600ml:
            AddWaterAmount(amount: 600)
        case waterButton1000ml:
            AddWaterAmount(amount: 1000)
        case waterButtonCustom:
            ResetWaterAmount()
        default:
            break
        }
        UserProfile.saveToFile()
    }
    
    func AddWaterAmount(amount: Int){
        UserProfile.userProfile.drinkAmount += amount
        let waterData = WaterData(date: Date(), amount: amount)
        WaterRecord.updateAndSaveRecord(waterData: waterData)
        UpdateWaterAmountDisplays()
        UserProfile.saveToFile()
    }
    
    func ResetWaterAmount(){
        UserProfile.userProfile.lastDrink = Date()
        UserProfile.userProfile.drinkAmount = 0
        UpdateWaterAmountDisplays()
        WaterRecord.removeRecord()
        UserProfile.saveToFile()
    }
    
    func UpdateWaterAmountDisplays(){
        waterAmountLabel.text = "\(UserProfile.userProfile.drinkAmount) / \(UserProfile.userProfile.targetAmount)"
        var progress = Float(UserProfile.userProfile.drinkAmount) / Float(UserProfile.userProfile.targetAmount)
        if progress > 1.0
        {
            progress = 1
        }
        progressBar.progress = progress
        progressLabel.text = String(format: "%.2f", progress * 100) + " %"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
