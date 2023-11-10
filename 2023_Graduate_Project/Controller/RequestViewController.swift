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
import FirebaseStorage
import AVKit
import AVFoundation

class RequestViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var requestPartTextField: UITextField!
    
    @IBOutlet weak var requestDescriptTextView: UITextView!
    
    @IBOutlet weak var requestButton: UIButton!
    
    let uid = Auth.auth().currentUser?.uid // USER에서 UID를 받아서 옴.
    let storageRef = Storage.storage().reference() // 스토리지를 쓰기 위해서 선언
    let ref = Database.database().reference() // 실시간 데이터베이스를 위해서 선언
    var imagePicker: UIImagePickerController! // 이미지피커 선언
    var selectedMediaURL: URL? // 수정: 선택된 미디어 URL을 저장할 변수 추가

    override func viewDidLoad() {
        super.viewDidLoad()
        otherSetting()
        
        imagePicker = UIImagePickerController() // 이미지피커는 UIImagePickerController
        imagePicker.delegate = self // 이미지피커의 위임자는 나 자신으로
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let mediaType = info[.mediaType] as? String {
            if mediaType == "public.movie" {
                // 선택한 미디어가 동영상인 경우
                if let videoURL = info[.mediaURL] as? URL {
                    selectedMediaURL = videoURL // 수정: 선택된 미디어 URL 저장
                    print("Selected video URL: \(videoURL)")
                    doneAlert()
                    
                    
                }
            } else if mediaType == "public.image" {
                changeMediaTypeAlert()
               
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findMedia(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image", "public.movie"]
        present(picker, animated: true)
    }
    
    @IBAction func requestButtonTabbed(_ sender: UIButton) {
        guard let videoURL = selectedMediaURL else {
            print("동영상 URL을 가져오는 데 실패")
            return
        }

        guard let videoData = try? Data(contentsOf: videoURL) else {
            print("동영상 데이터를 가져오는 데 실패")
            return
        }

        let videoName = UUID().uuidString
        let videoRef = storageRef.child("videos/\(videoName).mp4")

        let uploadTask = videoRef.putData(videoData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                print("에러 발생: \(error.debugDescription)")
                return
            }

            videoRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("동영상 다운로드 URL 가져오는거 실패.")
                    return
                }

                // Save the download URL to the Firebase Realtime Database
                let selectedDate = self.datePicker.date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                let dateString = dateFormatter.string(from: selectedDate)

                self.ref.child("ServiceRequest").childByAutoId().setValue([
                    "ㄱ서비스 요청자": "\(self.uid ?? "uid")",
                    "요청 일시": "\(dateString)",
                    "받은 견적": "",
                    "MediaURL": "\(downloadURL.absoluteString)", // 미디어 다운로드 URL 추가
                    "요청 위치": "\(self.requestPartTextField.text ?? "미입력")",
                    "연락처": "\(self.numberTextField.text ?? "미입력")",
                    "상세 설명": "\(self.requestDescriptTextView.text ?? "미입력")"
                ])
            }
        }

        print("DB에 전송 완료 !")

        presentAlert()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.requestDescriptTextView.resignFirstResponder()
    }

    func otherSetting() {
        requestDescriptTextView.delegate = self
        requestDescriptTextView.text = "자세히 적어주세요 !!"
        requestDescriptTextView.textColor = UIColor.lightGray
        requestDescriptTextView.layer.borderWidth = 0.5
        requestDescriptTextView.layer.borderColor = UIColor.gray.cgColor
        requestDescriptTextView.layer.cornerRadius = 10

        
        requestPartTextField.layer.borderWidth = 0.5
        requestPartTextField.layer.borderColor = UIColor.gray.cgColor
        requestPartTextField.layer.cornerRadius = 10

        numberTextField.layer.borderColor = UIColor.gray.cgColor
        numberTextField.layer.borderWidth = 0.5
        numberTextField.layer.cornerRadius = 10

        
    }

    fileprivate func presentAlert() {
        let alert = UIAlertController(title: "완료", message: "등록 완료 되었습니다." , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func doneAlert() {
        let alert = UIAlertController(title: "", message: "첨부되었습니다!." , preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            self.dismiss(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func changeMediaTypeAlert() {
        let alert = UIAlertController(title: "", message: "동영상을 선택해주세요!." , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            self.dismiss(animated: true)
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
