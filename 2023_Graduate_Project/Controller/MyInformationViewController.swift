//
//  MyInformationViewController.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/04/10.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


struct requestListEntity {
    
    var refid : String
    var date : String
    var place : String
    var detail : String
    var imageURL : String
    
}




class MyInformationViewController: UIViewController {
    
    
    var myRequestList : [requestListEntity] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    let ref = Database.database().reference().child("ServiceRequest").child(Auth.auth().currentUser?.uid ?? "ERROR")
    
    
    let currentEmail = Auth.auth().currentUser?.email ?? "고객"
    let userID = Auth.auth().currentUser?.uid
    
   

    
    @IBOutlet weak var userNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        print("UID is : \(userID ?? "error")")
        
        self.tableView.dataSource = self

        
        
        ref.observe(.value) { snapshot in
            
            self.myRequestList = []
            
            for child in snapshot.children {
                
                guard let childSnapShot = child as? DataSnapshot else {return}
                let value = childSnapShot.value as? NSDictionary
                let date = value?["요청 일시"] as? String ?? ""
                let place = value?["요청 장소"] as? String ?? ""
                let detail = value?["상세 설명"] as? String ?? ""
                let imageURL = value?["사진 URL"] as? String ?? ""
                
                let fetchedRequestList = requestListEntity(refid: childSnapShot.key, date: date, place: place, detail: detail, imageURL: imageURL)
                self.myRequestList.append(fetchedRequestList)
            }
            
            self.tableView.reloadData()
            
            
        }
        
        
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let email = Auth.auth().currentUser?.email ?? "고객"
        
        userNameLabel.text = "현재 로그인한 계정 : \(email)"
    }

    @IBAction func logoutButtonTabbed(_ sender: UIButton) {
        
        
        let firebaseAuth = Auth.auth()
        
        
        do{
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)

            
        }catch let sighOutError as NSError{
            
            print("ERROR : SIGNOUT \(sighOutError.localizedDescription)")
            
        }
    }
}

extension MyInformationViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRequestList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? MyRequestListCell else {
            return UITableViewCell()
        }
        
        let celldata : requestListEntity = myRequestList[indexPath.row]
        cell.titleLabel.text = celldata.detail
        cell.selectionStyle = .none
        return cell
    }

    
    
}

//extension MyInformationViewController : UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
//    
//    
//}
