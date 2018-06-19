//
//  ViewController.swift
//  PlannerApp
//
//  Created by Michael Berend on 04/06/2018.
//  Code inspired by: https://stackoverflow.com/questions/31735228/how-to-make-a-simple-collection-view-with-swift
//

import UIKit
import JTAppleCalendar


var monthsArray = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
var daysPerMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
var currentMonth = 0
var currentYear: Int = 0
var currentDay = 0
var startDay = 0
var currentWeekDay = 0
var startMonth = 0
var startYear = 0
var highLightedCell: String!

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let formatter = DateFormatter()

    let reuseIdentifier = "cell"
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
    var temp = [String]()
    
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var leftButton: UIButton!
    
    @IBOutlet weak var monthYearLabel: UILabel!
    
    @IBOutlet weak var collectionVIew: UICollectionView!
    
    @IBOutlet weak var goToDateButton: UIButton!
    
    var newDate: Date!
    
    var month: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftButton.isEnabled = false
        leftButton.isHidden = true
        goToDateButton.isHidden = true
        currentMonth = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        startYear = Calendar.current.component(.year, from: Date())
        startMonth = Calendar.current.component(.month, from: Date()) - 1
        currentWeekDay = Calendar.current.component(.weekday, from: Date())
        currentDay = Calendar.current.component(.day, from: Date())
        startDay = (7 + (3 - (currentDay%7 - 1)))%7
        print(currentDay)
        print(currentWeekDay)
        print(startDay)

        
        updateUI()

    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        startDay = (startDay + daysPerMonth[currentMonth]%7)%7
        currentMonth += 1
        if currentMonth > 11{
            currentYear += 1
            currentMonth = 0

        }
        leftButton.isEnabled = true
        leftButton.isHidden = false
        print(startDay)
        goToDateButton.isHidden = true
        updateUI()
        
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        currentMonth -= 1
        if currentMonth < 0 {
            currentYear -= 1
            currentMonth = 11
        }
        if (currentMonth == startMonth && currentYear == startYear) {
            leftButton.isEnabled = false
            leftButton.isHidden = true
        }
        goToDateButton.isHidden = true
        updateUI()
    }
    
    func updateUI() {
        temp.removeAll()
        if startDay - 1 > 0 {
            for _ in 1...(startDay - 1) {
                temp.append(" ")
            }
        }
        for item in items {
            temp.append(item)
        }
        month = monthsArray[currentMonth]
        monthYearLabel.text = "\(month!) \(currentYear)"
        collectionVIew.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.temp.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCell
        
        cell.dateLabel.text = self.temp[indexPath.item]
        cell.backgroundColor = UIColor.blue
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.item)!")

    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
    
        if indexPath.item > startDay - 2 {
            if cell?.backgroundColor == UIColor.red {
                cell?.backgroundColor = UIColor.blue
            } else {
                for cell in collectionView.visibleCells as [UICollectionViewCell] {
                    cell.backgroundColor = UIColor.blue
                }
                cell?.backgroundColor = UIColor.red
            }
        }
        highLightedCell = self.temp[indexPath.item]
        if items.contains(highLightedCell) {
            goToDateButton.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let currentDate = "\(month!) \(highLightedCell!), \(currentYear)"
        print(currentDate)
        newDate = formatter.date(from: currentDate)
        print(newDate!)
         
        
        super.prepare(for: segue, sender: sender)
        //guard segue.identifier == "saveUnwind" else { return }
        
    }
}
