//
//  FreeBoardViewController.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/05/04.
//

import UIKit
import FirebaseDatabase

class FreeBoardViewController: UIViewController {

    
    let ref = Database.database().reference().child("FreeBoard").child("Article")
    
    var articleList : [Article] = []
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        ref.observeSingleEvent(of: .value){ snapshot, error  in
                    //snapshot의 값을 딕셔너리 형태로 변경해줍니다.
                    guard let snapData = snapshot.value as? [String:Any] else {return}
                    //Data를 JSON형태로 변경해줍니다.
                    let data = try! JSONSerialization.data(withJSONObject: Array(snapData.values), options: [])
                    do{
                        let decoder = JSONDecoder()
                        let articleList = try decoder.decode([Article].self, from: data)
                        self.articleList = articleList
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    }catch let error {
                        print(String(describing: error))
                    }
           
            
            
            print(self.articleList.count)
                }
               

            }
        
        

        // Do any additional setup after loading the view.
    }
    

    extension FreeBoardViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return articleList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? FreeBoardTableViewCell else {return UITableViewCell()}
            cell.boardTitle.text = articleList[indexPath.row].Title
            return cell
        }
    }

    


