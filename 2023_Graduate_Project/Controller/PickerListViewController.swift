//
//  PickerListViewController.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/05/17.
//

import UIKit

class PickerListViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
   
    
    
    let cities = ["강서구", "북구", "사상구", "서구", "금정구", "해운대구", "사하구", "수영구", "연제구", "중구" ,"영도구" ,"동구"]
    
    
    var districts: [[String]] = []
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedCity: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
//        tableView.delegate = self
//        tableView.dataSource = self
        
        // 구 데이터 초기화
        districts = [
            ["구1-1", "구1-2", "구1-3", "구1-4", "구1-5", "구1-6", "구1-7", "구1-8", "구1-9", "구1-10"],
            ["구2-1", "구2-2", "구2-3", "구2-4", "구2-5", "구2-6", "구2-7", "구2-8", "구2-9", "구2-10"],
            ["구3-1", "구3-2", "구3-3", "구3-4", "구3-5", "구3-6", "구3-7", "구3-8", "구3-9", "구3-10"],
            ["구4-1", "구4-2", "구4-3", "구4-4", "구4-5", "구4-6", "구4-7", "구4-8", "구4-9", "구4-10"],
            ["구5-1", "구5-2", "구5-3", "구5-4", "구5-5", "구5-6", "구5-7", "구5-8", "구5-9", "구5-10"],
            ["구6-1", "구6-2", "구6-3", "구6-4", "구6-5", "구6-6", "구6-7", "구6-8", "구6-9", "구6-10"],
            ["구7-1", "구7-2", "구7-3", "구7-4", "구7-5", "구7-6", "구7-7", "구7-8", "구7-9", "구7-10"],
            ["구8-1", "구8-2", "구8-3", "구8-4", "구8-5", "구8-6", "구8-7", "구8-8", "구8-9", "구8-10"],
            ["구9-1", "구9-2", "구9-3", "구9-4", "구9-5", "구9-6", "구9-7", "구9-8", "구9-9", "구9-10"],
            ["구10-1", "구10-2", "구10-3", "구10-4", "구10-5", "구10-6", "구10-7", "구10-8", "구10-9", "구10-10"]
        ]
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return cities.count
        } else {
            return districts[selectedCity].count
        }
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return cities[row]
        } else {
            return districts[selectedCity][row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedCity = row
            pickerView.reloadComponent(1)
            tableView.reloadData()
        }
    }
    
    
    
  
    
}

//extension PickerListViewController : UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//
//
//}
//
//extension PickerListViewController : UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
//
//
//}



