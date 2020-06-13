
import UIKit

class SpashViewController: UIViewController {

    
    @IBOutlet weak var AccountView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //let user = LocalstorageManager.getLoginInfo()
        //if user != nil {
        //    AccountView.isHidden = true
        //    Common.me = user!
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
                self.gotoNextScreen()
        }
        //}else{
          //  AccountView.isHidden = false
        //}
   }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }

    func gotoNextScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let delegateObj = AppDelegate.instance();
        DispatchQueue.main.async {
                    let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "mainView") as UIViewController
                    vc.modalPresentationStyle = .fullScreen
                    delegateObj.window?.rootViewController!.present(vc, animated: true, completion: {
                    })
        }
    }
    
    @IBAction func startBtnClicked(_ sender: Any) {
//        gotoNextScreen()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let delegateObj = AppDelegate.instance();
        DispatchQueue.main.async {
                    let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "loginView") as UIViewController
                    vc.modalPresentationStyle = .fullScreen
                    delegateObj.window?.rootViewController!.present(vc, animated: true, completion: {
                    })
        }
    }
    

}
