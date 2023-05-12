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
    
    
    struct articleTest : Codable {
        
        var title : String
        var detail : String
        
        var toDictionary : [String : Any] {
            
            let dict : [String : Any] = ["title" : title , "detail" : detail]
            return dict
        }
    }
    
    var article : articleTest = .init(title: "제목", detail: "내용")
    
    
    let ref = Database.database().reference()
    let storageRef = Storage.storage().reference()

    @IBOutlet weak var writeTextView: UITextView!
    @IBOutlet weak var TitleTextField: UITextField!
    
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        

        
    }
    

    @IBAction func okButtonTabbed(_ sender: UIButton) {
        
        article.title = TitleTextField.text ?? "제목없음"
        article.detail = writeTextView.text ?? "내용없음"
        
        ref.child("FreeBoard").child("Article").setValue(article.toDictionary)
        
        print("DB에 전송 완료 !")
            
        self.navigationController?.popViewController(animated: true)
        
        
    }
    

}
