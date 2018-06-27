//
//  RecordsTableViewController.swift
//  Water Reminder
//
//  Created by ShiFayChy on 2018/6/25.
//  Copyright © 2018年 Lin Jin An. All rights reserved.
//

import UIKit

class RecordsTableViewController: UITableViewController {
    
    @IBAction func goToRefresh(segue: UIStoryboardSegue)
    {
        print("goToRefresh, Reload table Data")
        tableView.reloadData()
    }
    
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
        WaterRecord.readRecordsFromFile()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 1
        if WaterRecord.waterRecords.count > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections = 1
        }
        else
        {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "沒有記錄"
            noDataLabel.textColor  = UIColor.white
            noDataLabel.textAlignment = .center
            noDataLabel.font = UIFont(name: noDataLabel.font.fontName, size: 36)
            noDataLabel.backgroundColor = UIColor(patternImage: UIImage(named: "bg000a")!)
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }
        return numOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return WaterRecord.waterRecords.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "bg000a"))
        self.tableView.tableFooterView = UIView()
        let cell = tableView.dequeueReusableCell(withIdentifier: "WaterRecordCell", for: indexPath) as! WaterRecordCell
        let record = WaterRecord.waterRecords[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy 年 M 月 dd 日"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
        let dateString = dateFormatter.string(from: record.date as Date)
        cell.id = indexPath.row
        cell.Title.text = dateString
        if record.achieve {
            cell.Achieve.textColor = UIColor.green
            cell.Achieve.text = "已達成"
        }
        else
        {
            cell.Achieve.textColor = UIColor.red
            cell.Achieve.text = "未達成"
        }
        cell.details = record.details
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DisplayRecordDetails", sender: indexPath)
    }
 

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? DayDrinkTableViewController
        let indexPath = sender as? IndexPath
            if let row = indexPath?.row {
            controller?.record = WaterRecord.waterRecords[row]
            Utility.tableCellIndex = row
        }
    }
}
