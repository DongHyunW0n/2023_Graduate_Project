//
//  RequestViewController.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/05/02.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import Firebase


class RequestViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var requestDateTextField: UITextField!
    @IBOutlet weak var requestPartTextField: UITextField!
    
    @IBOutlet weak var requestDescriptTextView: UITextView!
    
    @IBOutlet weak var findPhotoButton: UIButton!
    
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var requestButton: UIButton!
    
    
    let storage = Storage.storage().reference()
    
    let ref = Database.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        requestDescriptTextView.delegate = self
        
        
        requestDescriptTextView.text = "자세히 적어주세요 !!"
        requestDescriptTextView.textColor = UIColor.lightGray
        
        
        requestDescriptTextView.layer.borderWidth = 1
        requestDescriptTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        requestPartTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
        guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
        let url = URL(string: urlString)else{
            return
            
            
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else{
                
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.uploadedImage.image = image
            }
            
           
        }
        task.resume()
    }
    
    @IBAction func findPhoto(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        picker.dismiss(animated: true,  completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        guard let imageData = image.pngData() else{
            return
        }
        
        storage.child("images/file.png").putData(imageData,
                                                 metadata: nil,
                                                 completion: { _, error in
            
            guard error == nil else{
                print("Failed to upload")
                return
            }
            
//            self.storage.child("images/file.png").downloadURL { url, error in
//
//                guard let url = url, error == nil else{
//                    return
//                }
//
//                let urlString = url.absoluteString
//
//                DispatchQueue.main.async {
//                    self.uploadedImage.image = image
//                }
//                print("Download URL : \(urlString)")
//                UserDefaults.standard.set(urlString, forKey: "url")
//            }
            
        })
        //upload image data
        
        // get download url
        
        //save download
        
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
    @IBAction func requestButtonTabbed(_ sender: UIButton) {
        
        let email = Auth.auth().currentUser?.email ?? "고객"
        print(email)
        
       
        
        ref.child("ServiceRequest").child("Request").setValue(["서비스 요청자" : "\(email)", "요청 일시" : "\(requestDateTextField.text ?? "미입력")", "요청 부분" :"\(requestPartTextField.text ?? "미입력")" ,"상세 설명" : "\(requestDescriptTextView.text ?? "미입력")"])
        print("DB에 전송 완료 !")

        
        
        
        
        
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.requestDescriptTextView.resignFirstResponder()
        }
    

}












extension RequestViewController: UITextViewDelegate {
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if requestDescriptTextView.text.isEmpty {
            requestDescriptTextView.text =  "자세히 적어주세요"
            requestDescriptTextView.textColor = UIColor.lightGray
        }

    }

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if requestDescriptTextView.textColor == UIColor.lightGray {
            requestDescriptTextView.text = nil
            requestDescriptTextView.textColor = UIColor.black
        }
    }


}


