//
//  FreeBoardViewController.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/05/04.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

struct ArticleEntity {
    
    var refid : String
    var title : String
    var describ : String
}



let ref = Database.database().reference().child("Freeboard")
let commentRef = ref.child("댓글")


class FreeBoardViewController: UIViewController{

    
    public var articleList : [ArticleEntity] = []
    var commentCount = 0
    
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.dataSource = self
        
        
        self.tableView.delegate = self
        
        
        ref.observe(.value) {snapshot in
            
            
            
            self.articleList = []
            
            for child in snapshot.children {
                guard let childSnapShot = child as? DataSnapshot else {return}
                let value = childSnapShot.value as? NSDictionary
                let title = value?["제목"] as? String ?? ""
                let discrib = value?["내용"] as? String ?? ""
                
                let fetchedArticle = ArticleEntity(refid: childSnapShot.key, title: title, describ: discrib)
                
                self.articleList.append(fetchedArticle)
            }
            
            self.tableView.reloadData()
            
            
            
        }
        
        commentRef.observe(.value) {snapshot in
            
            
            
            
            commentRef.observeSingleEvent(of: .value) { snapshot in
                   let commentCount = snapshot.childrenCount
                   // 이제 commentCount를 사용하여 표시하고자 하는 곳에 업데이트하면 됩니다.
                   print("댓글 갯수: \(commentCount)")
               }
            
            self.tableView.reloadData()
            
            
            
        }
    }
    
    private func fetchCommentCount(for articleID: String, completion: @escaping (Int) -> Void) {
         let commentRef = ref.child(articleID).child("댓글")
         
         commentRef.observeSingleEvent(of: .value) { snapshot in
             let commentCount = Int(snapshot.childrenCount)
             completion(commentCount)
         }
     }
    
}
    

    extension FreeBoardViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return articleList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? FreeBoardTableViewCell else {return UITableViewCell()}
            
            
            let celldata : ArticleEntity = articleList[indexPath.row]
            cell.boardTitle.text = celldata.title
            cell.detailLabel.text = celldata.describ
            fetchCommentCount(for: celldata.refid) { commentCount in
                        // 댓글 수 업데이트
                        cell.commentCountLabel.text = "\(commentCount)"
                    }
            cell.selectionStyle = .none
            return cell
        }
    }


extension FreeBoardViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    
        
        print(articleList[indexPath.row])
        
    
        
        
        let celldata: ArticleEntity = articleList[indexPath.row] //인덱스에 해당하는 셀데이터를 받음.
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "FreeboardDetailViewController") as? FreeboardDetailViewController {
            
            
            detailViewController.articleID = celldata.refid
            print("글의 id 값은 : \(celldata.refid)")
            detailViewController.detailText = celldata.describ
            detailViewController.titleText = celldata.title
            navigationController?.pushViewController(detailViewController, animated: true)
            
            
           
            
        }
        
        
    }

}




    





