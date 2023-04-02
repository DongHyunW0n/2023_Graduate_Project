//
//  LaunchScreenViewController.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/04/03.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // postDelay
        // 1초 뒤에 실행
    }
    override func viewDidAppear(_ animated: Bool) {
        checkDeviceNetworkStatus()
    }
    
    func checkDeviceNetworkStatus() {
        if(DeviceManager.shared.netWorkStatus) {
            guard let vc:MainViewController = UIStoryboard(name: "MainViewController", bundle: nil).instantiateViewController(identifier: "login_UI") as? MainViewController else { return }
            
            self.view.window?.rootViewController = vc
            self.view.window?.makeKeyAndVisible()
            
        } else {
            let alert: UIAlertController = UIAlertController(title: "네트워크 오류", message: "네트워크 연결을 확인하세요.", preferredStyle: .alert)
            let action: UIAlertAction = UIAlertAction(title: "다시 시도", style: .default, handler: { (ACTION) in
                self.checkDeviceNetworkStatus()
            })
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
}
