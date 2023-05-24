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
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var requestPartTextField: UITextField!
    
    @IBOutlet weak var requestDescriptTextView: UITextView!
    
    @IBOutlet weak var findPhotoButton: UIButton!
    
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var requestButton: UIButton!
    
    let uid = Auth.auth().currentUser?.uid // USER에서 UID를 받아서 옴.
    let storageRef = Storage.storage().reference() // 스토리지를 쓰기 위해서 선언
    let ref = Database.database().reference() // 실시간 데이터베이스를 위해서 선언
    var imagePicker: UIImagePickerController! // 이미지피커 선언
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController() //이미지피커는 UIImagePicker
        imagePicker.delegate = self // 이미지피커의 위임자는 나 자신으로
        
       
        
        
        
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
            
            DispatchQueue.main.async {      // 실시간으로 선택한 이미지를 쇼잉 해줍니당
                let image = UIImage(data: data)
                self.uploadedImage.image = image
            }
            
           
        }
        task.resume()
    }
    
    @IBAction func findPhoto(_ sender: Any) { //사진 찾아보기 버튼
        
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
        print(type(of: uid))
        
        
        
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
                        
                        
                        let selectedDate = self.datePicker.date

                        // DateFormatter를 사용하여 날짜를 String으로 변환
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                        let dateString = dateFormatter.string(from: selectedDate)
                        
                        ref.child("ServiceRequest")
                            .childByAutoId().setValue(["ㄱ서비스 요청자" : "\(self.uid ?? "uid")",
                                                       "요청 일시" : "\(dateString )",
                                                       "받은 견적" : "" ,
                                                                                 "사진 URL" : "\(downloadURL.absoluteString ?? "사진 미선택")",

                                                                                 "요청 위치" :"\(self.requestPartTextField.text ?? "미입력")" ,
                                                                                 "상세 설명" : "\(self.requestDescriptTextView.text ?? "미입력")"])
                    }
                }
        
        print("DB에 전송 완료 !")
        
        presentAlert()
            
//        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.requestDescriptTextView.resignFirstResponder()
        }
    

    
    
    fileprivate func presentAlert () {
        
        let alert = UIAlertController(title: "완료", message: "등록 완료 되었습니다." , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
        
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


