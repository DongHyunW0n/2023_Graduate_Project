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


class FreeBoardViewController: UIViewController{

    
    let ref = Database.database().reference().child("Freeboard")
    
    var articleList : [ArticleEntity] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        self.tableView.dataSource = self
        
        
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
            cell.selectionStyle = .none
            return cell
        }
    }

    



