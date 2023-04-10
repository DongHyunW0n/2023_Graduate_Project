//
//  EnterEmailViewController.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/04/10.
//

import UIKit

class EnterEmailViewController: UIViewController{
    
    
    
    @IBOutlet weak var emailTextField : UITextField!
    @IBOutlet weak var passwordTextField : UITextField!
    @IBOutlet weak var errorLabel : UILabel!
    @IBOutlet weak var nextButton : UIButton!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.layer.cornerRadius = 20
        
        nextButton.isEnabled = false // 다 입력 전에는 넘어가면 안되니까 ~~
        
        emailTextField.delegate  = self
        passwordTextField.delegate = self
        
        emailTextField.becomeFirstResponder() // 화면이 켜졌을때 처음으로 커서가 이쪽으로 가게 설정

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false // 앞에서 숨긴거 다시 보여줘야죠 ?
    }
    
    
    @IBAction func nextButtonTabbed(_ sender: UIButton) {
        
        
    }
    
   
}


extension EnterEmailViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = emailTextField.text == "" // 불형
        let isPassworkEmpty = passwordTextField.text == "" // 불형
        
        nextButton.isEnabled = !isEmailEmpty && !isPassworkEmpty  //둘다 false 일때 같아지면 true
    }
    
}
