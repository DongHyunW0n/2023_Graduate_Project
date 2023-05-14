//
//  MyInformationViewController.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/04/10.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


struct requestList : Codable {
    
    
    var date : String
    var place : String
    var detail : String
    var imageURL : String
    
}




class MyInformationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    let currentEmail = Auth.auth().currentUser?.email ?? "고객"
    let ref = Database.database().reference().child("ServiceRequest")
    let uid = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var userNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        print("UID is : \(uid ?? "error")")

        
        
        
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
//
//extension MyInformationViewController : UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//    
//    
//}
//
//extension MyInformationViewController : UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
//    
//    
//}
