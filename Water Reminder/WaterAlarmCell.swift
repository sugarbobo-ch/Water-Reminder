//
//  WaterAlarmCell.swift
//  Water Reminder
//
//  Created by ShiFayChy on 2018/6/23.
//  Copyright © 2018年 Lin Jin An. All rights reserved.
//

import UIKit
import UserNotifications

class WaterAlarmCell: UITableViewCell {

    var id = 0
    @IBOutlet weak var NoonLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var AlarmSwitch: UISwitch!
    
    @IBAction func onAlarmSwitched(_ sender: Any) {
        WaterAlarm.waterAlarms[id].enabled = AlarmSwitch.isOn
        print("\(id): \(WaterAlarm.waterAlarms[id].time), \(WaterAlarm.waterAlarms[id].enabled)")
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        addUserNotificaton()
        WaterAlarm.saveToFile()
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
