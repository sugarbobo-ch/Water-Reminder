//
//  DayDrinkTableViewController.swift
//  Water Reminder
//
//  Created by ShiFayChy on 2018/6/25.
//  Copyright © 2018年 Lin Jin An. All rights reserved.
//

import UIKit

class DayDrinkTableViewController: UITableViewController {
    var date = Date()
    var record: WaterRecord!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "bg002"))
        self.tableView.tableFooterView = UIView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Utility.tableCellIndex != -1 {
             record = WaterRecord.waterRecords[Utility.tableCellIndex]
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 1
        if record.details.count > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections = 1
        }
        else
        {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "沒有記錄或已經被重置"
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
        return record.details.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WaterDataCell", for: indexPath) as! WaterDataCell
        let dateFormatter = DateFormatter()
        var noon = ""
        dateFormatter.dateFormat = "H"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
        let hourString = dateFormatter.string(from: record.details[indexPath.row].date as Date)
        let hour = Int(hourString)!
        if(hour < 12)
        {
            noon = "上午"
        }
        else
        {
            noon = "下午"
        }
        dateFormatter.dateFormat = "MM月dd日 "
        let dateString = dateFormatter.string(from: record.details[indexPath.row].date as Date)
        dateFormatter.dateFormat = " hh:mm"
        let timeString = dateFormatter.string(from: record.details[indexPath.row].date as Date)
        cell.DrinkTimeLabel.text = dateString + noon + timeString
        cell.DrinkAmount.text = "\(record.details[indexPath.row].amount) 毫公升"
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
