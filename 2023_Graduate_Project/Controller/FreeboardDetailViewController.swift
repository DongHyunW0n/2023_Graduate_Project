//
//  FreeboardDetailViewController.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/05/14.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

struct commentEntity {
    
    var commentDetail : String
}

class FreeboardDetailViewController: UIViewController {
    
   
    
 
    
    var commentList : [commentEntity] = [] //똑같은 타입으로 맞춰주기.

    
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
        
        updateUI()
        
        let commentRef = ref.child("Freeboard").child(articleID ?? "ERROR").child("댓글")
        
        commentRef.observe(.value) { snapshot in
            self.commentList = []

            for child in snapshot.children {
                guard let childSnapShot = child as? DataSnapshot else { return }
                let value = childSnapShot.value as? NSDictionary
                let discrib = value?["내용"] as? String ?? ""

                let fetchedCommentDetail = value?["commentDetail"] as? String ?? ""
                let fetchedComment = commentEntity(commentDetail: fetchedCommentDetail)

                self.commentList.append(fetchedComment)
            }

            self.tableView.reloadData()
        }
    

        
        
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
        
        commentTextField.text = ""

        
        let alertController = UIAlertController(title: "완료", message: "댓글이 등록되었습니다.", preferredStyle: .actionSheet)
           
           let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
           
         
           
           alertController.addAction(cancelAction)
           
           present(alertController, animated: true, completion: nil)
                
        
        
    }
    

}

extension FreeboardDetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FreeboardCommentCell
        let celldata: commentEntity = commentList[indexPath.row]

        cell.selectionStyle = .none

        cell.commentLabel.text = celldata.commentDetail
        
        return cell
        
    }
    
    
    
    
}
