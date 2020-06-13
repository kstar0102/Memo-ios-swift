//
//  LoginViewController.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/03/20.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailLe: UITextField!
    
    @IBOutlet weak var passwordLe: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addDoneButtonOnKeyboard()
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.emailLe.inputAccessoryView = doneToolbar
        self.passwordLe.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction(){
        self.emailLe.resignFirstResponder()
        self.passwordLe.resignFirstResponder()
    }

    func checkEmptyFeild() -> Bool {
        
        if self.emailLe.text == "" || !(self.emailLe.text?.contains("@"))! || self.emailLe.text != Common.me!.email {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "メールアドレス"+Config.INPUT_ERR_MSG)
            return false
        }
        
        if self.passwordLe.text == "" || self.passwordLe.text != Common.me!.password {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "パスワード"+Config.INPUT_ERR_MSG)
            return false
        }
        
        return true
    }

    
    @IBAction func loginBtnClicked(_ sender: Any) {
        
        if checkEmptyFeild() {
            let delegateObj = AppDelegate.instance();
            self.dismiss(animated: true) {
                let vc: UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "mainView") as UIViewController
                vc.modalPresentationStyle = .fullScreen
                delegateObj.window?.rootViewController!.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
