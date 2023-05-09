//
//  RequestViewController.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/05/02.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase


class RequestViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var requestDateTextField: UITextField!
    @IBOutlet weak var requestPartTextField: UITextField!
    
    @IBOutlet weak var requestDescriptTextView: UITextView!
    
    @IBOutlet weak var findPhotoButton: UIButton!
    
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var requestButton: UIButton!
    
    
    let storageRef = Storage.storage().reference()
    let ref = Database.database().reference()
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        
        
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
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true, completion: nil)
            uploadedImage.image = info[.originalImage] as? UIImage
        }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
    @IBAction func requestButtonTabbed(_ sender: UIButton) {
        
        let email = Auth.auth().currentUser?.email ?? "고객"
        print(email)
        
        
        
        guard let image = uploadedImage.image else{return}
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {return}
        
        
        
        let imageName = UUID().uuidString
        let imageRef = storageRef.child("images/\(imageName)")
        
        let uploadTask = imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                    guard let metadata = metadata else {
                        print("뭔가 에러가 있다")
                        return
                    }
                    // Metadata contains file metadata such as size, content-type.
                    let size = metadata.size
                    // You can also access to download URL after upload.
                    imageRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            print("뭔가 에러가 있다")
                            return
                        }
                        // Save the download URL to the Firebase Realtime Database
//                        let dbRef = Database.database().reference().child("images").child("ServiceRequest").childByAutoId()
//                        dbRef.setValue(downloadURL.absoluteString)
                        let ref = Database.database().reference()
                    
                        ref.child("ServiceRequest").child("Request").setValue(["서비스 요청자" : "\(email)",
                                                                                 "요청 일시" : "\(self.requestDateTextField.text ?? "미입력")",
                                                                                 "사진 URL" : "\(downloadURL.absoluteString ?? "사진 미선택")",

                                                                                 "요청 부분" :"\(self.requestPartTextField.text ?? "미입력")" ,
                                                                                 "상세 설명" : "\(self.requestDescriptTextView.text ?? "미입력")"])
                    }
                }
        
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

