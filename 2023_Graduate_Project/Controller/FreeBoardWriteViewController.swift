//
//  FreeBoardWriteViewController.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/05/04.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage



class FreeBoardWriteViewController: UIViewController {
    
    
    
    let ref = Database.database().reference()
    let storageRef = Storage.storage().reference()

    @IBOutlet weak var writeTextView: UITextView!
    @IBOutlet weak var TitleTextField: UITextField!
    
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        

        
    }
    

    @IBAction func okButtonTabbed(_ sender: UIButton) {
        
        ref.child("FreeBoard").child("Article").setValue(["Title" : "\(TitleTextField.text ?? "입력값 없음")",
                                 "Detail" : "\(writeTextView.text ?? "입력값 없음")"])
        
        print("DB에 전송 완료 !")
            
        self.navigationController?.popViewController(animated: true)
        
        
    }
    

}
