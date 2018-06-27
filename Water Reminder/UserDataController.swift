//
//  UserDataController.swift
//  Water Reminder
//
//  Created by ShiFayChy on 2018/6/23.
//  Copyright © 2018年 Lin Jin An. All rights reserved.
//

import UIKit

class UserDataController: UITableViewController {
    var BMI = 0.0
    var result = 0
    var isMale = true
    var ageValue = 0
    var heightValue = 0
    var weightValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "bg004"))
        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var weight: UITextField!
    
    @IBAction func onCaculateButtonClicked(_ sender: Any) {
        if !confirmDataValid()
        {
            let refreshAlert = UIAlertController(title: "錯誤", message: "資料尚未完成，是否繼續？", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "繼續", style: .default, handler: { (action: UIAlertAction!) in
                self.result = 2000
                self.performSegue(withIdentifier: "setHealthyData", sender: nil)
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            
            present(refreshAlert, animated: true, completion: nil)
        }
        else
        {
            UserProfile.userProfile.isMale = isMale
            UserProfile.userProfile.age = ageValue
            UserProfile.userProfile.height = heightValue
            UserProfile.userProfile.weight = weightValue
            UserProfile.saveToFile()
            
            performSegue(withIdentifier: "setHealthyData", sender: nil)
        }
    }
    
    func confirmDataValid() -> Bool {
        var ageValue = 0, heightValue = 0, weightValue = 0
        
        if gender.selectedSegmentIndex == 0
        {
            isMale = true
        }
        else
        {
            isMale = false
        }
        
        if let ageText = age.text, !ageText.isEmpty
        {
            ageValue = Int(ageText)!
        }
        if let heightText = height.text, !heightText.isEmpty
        {
            heightValue = Int(heightText)!
        }
        if let weightText = weight.text, !weightText.isEmpty
        {
            weightValue = Int(weightText)!
        }
        
        if ageValue > 0 && heightValue > 0 && weightValue > 0 {
            caculateDrinkAmount(age: Double(ageValue), height: Double(heightValue), weight: Double(weightValue))
            self.ageValue = ageValue
            self.heightValue = heightValue
            self.weightValue = weightValue
            return true
        }
        else {
            return false
        }
    }
    
    func caculateDrinkAmount(age: Double, height: Double, weight: Double){
        let BMI: Double = Double(weight / height / height * 10000)
        var drinkAmount: Double = 0.0;
        
        if age < 2
        {
            drinkAmount = 100.0 * weight
        }
        else if age < 5
        {
            drinkAmount = 50.0 * (weight - 10.0) + 1000.0
        }
        else if age < 13
        {
            drinkAmount = 20.0 * (weight - 20.0) + 1500.0
        }
        else if age < 20
        {
            drinkAmount = weight * 25.0
        }
        else
        {
            drinkAmount = weight * 30.0
        }
        
        if BMI < 18.5
        {
            drinkAmount += 250
            drinkAmount *= 0.9
        }
        else if BMI > 27
        {
            drinkAmount *= 1.2
        }
        else if BMI > 30
        {
            drinkAmount *= 1.35
        }
        
        let result: Int = Int(drinkAmount / 10) * 10
        print(BMI)
        self.BMI = BMI
        self.result = result
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? UserConfigController
        controller?.BMI = self.BMI
        controller?.result = self.result
     }
    

}
