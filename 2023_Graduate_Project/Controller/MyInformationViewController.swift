//
//  MyInformationViewController.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/04/10.
//

import UIKit
import FirebaseAuth


struct requestList : Codable {
    
    
    var date : String
    var place : String
    var detail : String
    var imageURL : String
    
}



class MyInformationViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        
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
