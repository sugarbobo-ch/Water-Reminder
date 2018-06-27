//
//  WaterAlarmTableViewController.swift
//  Water Reminder
//
//  Created by ShiFayChy on 2018/6/23.
//  Copyright © 2018年 Lin Jin An. All rights reserved.
//

import UIKit
import UserNotifications

class WaterAlarmTableViewController: UITableViewController {
    
    @IBAction func returnToWaterAlarm(segue: UIStoryboardSegue)
    {
        print("returnToWaterAlarm, Reload table Data")
        let controller = segue.source as? EditWaterAlarmTableViewController
        
        if let tempAlarm = controller?.tempAlarm {
            if let row = tableView.indexPathForSelectedRow?.row  {
                WaterAlarm.waterAlarms[row] = tempAlarm
            }
            else
            {
                WaterAlarm.waterAlarms.append(tempAlarm)
            }
            WaterAlarm.saveToFile()
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            addUserNotificaton()
            WaterAlarm.saveToFile()
            Utility.alarmIndex = -1
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WaterAlarm.readWaterAlarmFromFile()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "bg000a"))
        self.tableView.tableFooterView = UIView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 1
        if WaterAlarm.waterAlarms.count > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections = 1
        }
        else
        {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "沒有鬧鐘"
            noDataLabel.textColor = UIColor.white
            noDataLabel.textAlignment = .center
            noDataLabel.font = UIFont(name: noDataLabel.font.fontName, size: 36)
            noDataLabel.backgroundColor = UIColor(patternImage: UIImage(named: "bg000a")!)
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return WaterAlarm.waterAlarms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "bg000a"))
        self.tableView.tableFooterView = UIView()
        let cell = tableView.dequeueReusableCell(withIdentifier: "WaterAlarmCell", for: indexPath) as! WaterAlarmCell
        let waterAlarm = WaterAlarm.waterAlarms[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
        let hourString = dateFormatter.string(from: waterAlarm.time as Date)
        let hour = Int(hourString)!
        if(hour < 12)
        {
            cell.NoonLabel.text = "上午"
        }
        else
        {
            cell.NoonLabel.text = "下午"
        }
        dateFormatter.dateFormat = "hh:mm"
        let timeString = dateFormatter.string(from: waterAlarm.time as Date)
        cell.id = indexPath.row
        cell.TimeLabel.text = timeString
        cell.AlarmSwitch.isOn = waterAlarm.enabled
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            WaterAlarm.waterAlarms.remove(at: indexPath.row)
            WaterAlarm.saveToFile()
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.backgroundView = UIImageView(image: UIImage(named: "bg000a"))
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditWaterAlarm", sender: indexPath)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? EditWaterAlarmTableViewController
        let indexPath = sender as? IndexPath
        if let row = indexPath?.row {
            controller?.tempAlarm = WaterAlarm.waterAlarms[row]
            controller?.alarmIndex = row
            Utility.alarmIndex = row
        }
    }
    
    @IBOutlet weak var Bar: UINavigationItem!
    @IBOutlet weak var EditButton: UIBarButtonItem!
    @IBAction func onEditClicked(_ sender: Any) {
        self.setEditing(!self.isEditing, animated: true)
        let newButton = UIBarButtonItem(barButtonSystemItem: (self.isEditing) ? .done : .edit, target: self, action: #selector(self.onEditClicked(_:)))
        Bar.setLeftBarButton(newButton, animated: true)
    }
    
    func addUserNotificaton(){
        for(index, element) in WaterAlarm.waterAlarms.enumerated()
        {
            if(element.enabled)
            {
                let content = UNMutableNotificationContent()
                content.subtitle = "喝水時間"
                content.body = "休息一下，補充水分。"
                content.badge = 1
                content.sound = UNNotificationSound.default()
                content.categoryIdentifier = "message"
                let date = element.time
                let calendar = Calendar.current
                let components = calendar.dateComponents([ .hour, .minute], from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                let request = UNNotificationRequest(identifier: "notification\(index)", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
    }

}
