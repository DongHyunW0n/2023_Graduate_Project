//
//  FreeboardDetailViewController.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/05/14.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth



class FreeboardDetailViewController: UIViewController {
    
    let uid = Auth.auth().currentUser?.uid
    let ref = Database.database().reference()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var addCommentButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    var titleText : String?
    
    var detailText : String?
    
    var articleID : String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        updateUI()
        
        
        
    }
    
    func updateUI() {
            if let title = titleText {
                titleLabel.text = title
            }
            
            if let detail = detailText {
                detailTextView.text = detail
            }
        }
    
   
    

    @IBAction func addButtonTabbed(_ sender: UIButton) {
        
        
        let commentRef = ref.child("Freeboard").child(articleID ?? "ERROR").child("댓글")
        
        commentRef.childByAutoId().setValue(["uid" : uid , "commentDetail" : commentTextField.text])
        
                
        
        
    }
    

}

extension FreeboardDetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
    
    
}

extension FreeboardDetailViewController : UITableViewDelegate {
    
    
}
