//
//  ChatListViewController.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/06/01.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

struct myChatListEntity {
    
    var companyName : String
    var customerUID : String
    var postID : String
    var detail : String
    
}



class ChatListViewController: UIViewController {
    
    let uid = Auth.auth().currentUser?.uid
    let ref = Database.database().reference()
    var myChatList : [myChatListEntity] = []
    
    
    
    
    @IBOutlet weak var TableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
                self.TableView.dataSource = self
                self.TableView.delegate = self
        
        
        if let userID = uid {
            let chatRef = ref.child("Chat")
            let mychatRef = chatRef.queryOrdered(byChild: "customerUID").queryEqual(toValue: userID)
            
            mychatRef.observe(.value) { snapshot in
                self.myChatList = []
                
                for child in snapshot.children {
                    guard let childSnapShot = child as? DataSnapshot else { continue }
                    
                    let value = childSnapShot.value as? NSDictionary
                    let companyName = value?["companyName"] as? String ?? ""
                    let customerUID = value?["customerUID"] as? String ?? ""
                    let PostID = value?["PostID"] as? String ?? ""
                    
                    let getPostNameRef = self.ref.child("ServiceRequest").child(PostID)
                    
                    getPostNameRef.observeSingleEvent(of: .value) { snapshot in
                        if let value = snapshot.value as? [String: Any],
                           let detail = value["상세 설명"] as? String {
                            let fetchedChatList = myChatListEntity(companyName: companyName, customerUID: customerUID, postID: PostID, detail: detail)
                            self.myChatList.append(fetchedChatList)
                            print("제목은 : \(detail)")
                            
                            // 채팅 리스트가 업데이트된 후에 출력
                            print("나의 채팅 리스트 : \(self.myChatList)")
                            
                            self.TableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}


extension ChatListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(myChatList.count)

        return myChatList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChatListCell
        let cellData : myChatListEntity = myChatList[indexPath.row]
        
        cell.companyLabel.text = cellData.companyName
        cell.detailLabel.text = cellData.detail
        cell.selectionStyle = .none
        return cell
        
    }



}

extension ChatListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let chatView = self.storyboard?.instantiateViewController(withIdentifier: "ChatView") as? ChatViewController {
            
            let cellData : myChatListEntity = myChatList[indexPath.row]
          
            chatView.postID = cellData.postID
            chatView.title = "\(cellData.companyName) 사장님과의 대화"
        

            self.navigationController?.pushViewController(chatView, animated: true)
        }
    }


}
