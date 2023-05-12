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
    
    
    
    var article : Article = .init(title: "제목", datail: "내용")
    
    
    let ref = Database.database().reference()
    let storageRef = Storage.storage().reference()

    @IBOutlet weak var writeTextView: UITextView!
    @IBOutlet weak var TitleTextField: UITextField!
    
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        

        
    }
    

    @IBAction func okButtonTabbed(_ sender: UIButton) {
        
        
        let data = Article(title: "\(TitleTextField.text ?? "제목없음")", datail: "\(writeTextView.text ?? "내용없음")")
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(data)
            print(jsonData)
        } catch {
            print("error")
        }
        
        
        ref.child("FreeBoard").child("Article").setValue(data.toDictionary)
        
        print("DB에 전송 완료 !")
            
        self.navigationController?.popViewController(animated: true)
        
        
    }
    

}
