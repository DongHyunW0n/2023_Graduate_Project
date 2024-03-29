import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseDatabase


private let minimalUsernameLength = 5
private let minimalPasswordLength = 6






let minimumPWLength : Int = 5
class JoinViewController: UIViewController {
    let ref = Database.database().reference()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

         self.view.endEditing(true)

   }
    
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordValidOutlet: UILabel!

    
    @IBOutlet weak var repasswordOutlet: UITextField!
    
    @IBOutlet weak var repasswordValidOutlet: UILabel!
    @IBOutlet weak var doSomethingOutlet: UIButton!
    
    @IBOutlet weak var nickNameValidOutlet: UILabel!
    let disposeBag = DisposeBag() //디스포스백을 사용하기 위해 디스포스백 선언

    override func viewDidLoad() {
        super.viewDidLoad()

   
        
        doSomethingOutlet.isExclusiveTouch = true

//        doSomethingOutlet.titleLabel?.text = "뭔데?"
//        doSomethingOutlet.titleLabel?.font = UIFont(name: "SOYO Maple Regular", size: 10)
//        doSomethingOutlet.titleLabel?.textColor = .white

        passwordValidOutlet.text = "비밀번호는 6자 이상 입력해주세요."
        repasswordValidOutlet.text = "비밀번호 일치를 확인하세요."
   
        let usernameValid = usernameOutlet.rx.text.orEmpty
            .map { $0.count >= minimalUsernameLength }
            .share(replay: 1) // without this map would be executed once for each binding, rx is stateless by default

        let passwordValid = passwordOutlet.rx.text.orEmpty
            .map { $0.count >= minimalPasswordLength }
            .share(replay: 1)
        
        
        let passwordObserable = passwordOutlet.rx.text.orEmpty.asObservable()
        let repasswordObserable = repasswordOutlet.rx.text.orEmpty.asObservable()
        
        let passwordsMatch = Observable.combineLatest(passwordObserable, repasswordObserable) { pw, repw in
            return pw == repw && !pw.isEmpty && !repw.isEmpty
        }.map { $0 }
        .share(replay: 1)
        
       
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid, passwordsMatch) {
            $0 && $1 && $2
        }.share(replay: 1)
        usernameValid
            .bind(to: passwordOutlet.rx.isEnabled)
            .disposed(by: disposeBag)
        
        
        passwordValid
            .bind(to: passwordValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)
        
        passwordValid
            .bind(to: repasswordOutlet.rx.isEnabled)
            .disposed(by: disposeBag)
        
        passwordsMatch
            .bind(to: repasswordValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)
        
    

 
        everythingValid
            .bind(to: doSomethingOutlet.rx.isEnabled)
            .disposed(by: disposeBag)
        
  
        doSomethingOutlet.rx.tap
                    .debounce(.seconds(1), scheduler: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] in
                        self?.doSomethingOutlet.isEnabled = false // 중복 클릭 방지
                        self?.createUser(self?.usernameOutlet.text ?? "", self?.passwordOutlet.text ?? "")
                    })
                    .disposed(by: disposeBag)
    }
    


    
    func createUser(_ email : String ,  _ password : String ){
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
               
                let code = (error as NSError).code
                
                switch code  {
                    
                case 17007 : //이메일 이미 존재하는 경우
                    
                    self.AlreadyshowAlert(detail: "이미 존재하는 아이디입니다.\n 로그인 화면으로 이동합니다 !")
                    
                    
                default :
                    
                    self.showAlert(detail: "\(error.localizedDescription)")
                }
                
                print("사용자 생성 오류: \(error.localizedDescription)")
            } else if let authResult = authResult {
                // 사용자 생성이 성공한 경우
                let user = authResult.user
                
                let emailKey = user.email?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "defaultKey"

                
                
                print("계정 생성 완료 ! UID는 : \(user.uid)")
                
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                
                guard let mainVC = storyboard.instantiateViewController(identifier: "MainViewController") as? MainViewController else{return}
                
                
        
                self.navigationController?.pushViewController(mainVC, animated: true)

                
                
                
                
            }
        }

        
    }
    
    func AlreadyshowAlert( detail : String) {
        
        
        let alertController = UIAlertController(title: "에러", message: detail , preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "확인", style: .cancel) { _ in
            
            self.moveToLoginViewController()
        }
        alertController.addAction(okButton)
        present(alertController, animated: true)
        
    }
    
    func showAlert( detail : String) {
        
        
        let alertController = UIAlertController(title: "에러", message: detail , preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "확인", style: .cancel) { _ in
            
        }
        alertController.addAction(okButton)
        present(alertController, animated: true)
        
    }

    func moveToLoginViewController() {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(identifier: "LoginViewController")
        self.navigationController?.pushViewController(loginViewController, animated: true)
        print("로그인뷰컨트롤러로 이동 함수 블럭 실행!")
    
        
    }
    

}
