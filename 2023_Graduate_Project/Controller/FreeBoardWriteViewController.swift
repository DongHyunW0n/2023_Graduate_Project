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
import FirebaseAuth


class FreeBoardWriteViewController: UIViewController {
    
    
    struct Article : Codable {
        
       
        var title : String
        var datail : String
        var uid : String
        
        

        }
    
    let uid = Auth.auth().currentUser?.uid
    let ref = Database.database().reference()
    let storageRef = Storage.storage().reference()

    @IBOutlet weak var writeTextView: UITextView!
    @IBOutlet weak var TitleTextField: UITextField!
    
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        

        
    }
    

    @IBAction func okButtonTabbed(_ sender: UIButton) {
        
        
        guard let titleInput : String = TitleTextField.text, let descipInput : String = writeTextView.text, let uid : String = uid,
              titleInput.count > 0 else{
            
            
            presentAlert()
            return
        }
        
        self.ref
            .child("Freeboard")
//            .child(uid ?? "uid ERROR")
            .childByAutoId()
            .setValue(["제목" : titleInput ,
                       "내용" : descipInput ,
                       "uid" : uid])
       
        
        print("DB에 전송 완료 !")
            
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    fileprivate func presentAlert () {
        
        let alert = UIAlertController(title: "오류", message: "제목이 없습니다" , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    

}
