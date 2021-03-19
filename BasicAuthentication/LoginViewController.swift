//
//  LoginViewController.swift
//  BasicAuthentication
//
//  Created by Benjamin Lewis on 3/17/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    var urlTextField:UITextField?
    var usernameTextField:UITextField?
    var passwordTextField:UITextField?
    var submitButton:UIButton?
    var waitingView:UIView?
    var loginTask:URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray

        let userNameTextField = UITextField()
        view.addSubview(userNameTextField)
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        userNameTextField.backgroundColor = .secondarySystemBackground
        userNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0).isActive = true
        userNameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        userNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20.0).isActive = true
        userNameTextField.textContentType = .username
        userNameTextField.textAlignment = .center
        userNameTextField.layer.cornerRadius = 5
        userNameTextField.clipsToBounds = true
        userNameTextField.placeholder = "email"
        userNameTextField.autocorrectionType = .no
        userNameTextField.autocapitalizationType = .none
        if let un = UserDefaults().string(forKey: "username"){
            userNameTextField.text = un
        }
        usernameTextField = userNameTextField
        
        let password = UITextField()
        password.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(password)
        password.backgroundColor = .secondarySystemBackground
        password.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0).isActive = true
        password.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 20.0).isActive = true
        password.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20.0).isActive = true
        password.layer.cornerRadius = 5
        password.clipsToBounds = true
        password.textContentType = .password
        password.placeholder = "password"
        password.textAlignment = .center
        password.isSecureTextEntry = true
        passwordTextField = password
        
        let submit = UIButton(frame: CGRect())
        submit.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(submit)
        submit.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        submit.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 20.0).isActive = true
        submit.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        submit.layer.cornerRadius = 10
        submit.clipsToBounds = true
        submit.backgroundColor = .darkGray
        submit.setTitle("Login", for:.normal)
        submit.addTarget(self, action: #selector(self.submitLogin), for: .touchUpInside)
        submitButton = submit
        //submit.setTitle("Login", for: .normal)
        
        let urlTF = UITextField()
        view.addSubview(urlTF)
        urlTF.translatesAutoresizingMaskIntoConstraints = false
        urlTF.bottomAnchor.constraint(equalTo: userNameTextField.topAnchor, constant: -20.0).isActive = true
        urlTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20.0).isActive = true
        urlTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20.0).isActive = true
        urlTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        urlTF.placeholder = "url"
        urlTF.autocorrectionType = .no
        urlTF.autocapitalizationType = .none
        urlTF.textContentType = .URL
        urlTF.textAlignment = .center
        urlTF.layer.cornerRadius = 5
        urlTF.clipsToBounds = true
        urlTF.backgroundColor = .secondarySystemBackground
        urlTextField = urlTF
        if let url = UserDefaults().string(forKey: "url"){
            urlTF.text = url
        }
        if let username = UserDefaults().string(forKey: "username"){
            userNameTextField.text = username
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func submitLogin(){
        guard let username = usernameTextField?.text,
              let password = passwordTextField?.text,
              let url = urlTextField?.text else{
            print("ye shall not pass")
            return
        }
        
        UserDefaults().setValue(url, forKey: "url")
        UserDefaults().setValue(username, forKey: "username")
        
        if(url.count < 13 || username.count < 1 || password.count < 1){
            return
        }
        
        
        
        switchToCancel()
        
        print("passed")
        
        //setup a waiting inidicator
        let wv = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        wv.layer.cornerRadius = 10
        wv.clipsToBounds = true
        
        let spinner = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        wv.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: wv.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: wv.centerXAnchor).isActive = true
        spinner.widthAnchor.constraint(equalTo: wv.widthAnchor).isActive = true
        spinner.heightAnchor.constraint(equalTo: wv.heightAnchor).isActive = true
        
        view.addSubview(wv)
        wv.translatesAutoresizingMaskIntoConstraints = false
        wv.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        wv.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        spinner.startAnimating()
        
        waitingView = wv
        
        //do the network work
        
        let urlURL = URL(string: url)!
        var request = URLRequest(url: urlURL)
        request.httpMethod = "POST"

        let bodyUnencoded = "username=" + username + "&password=" + password + "&tokenType=jwt"
        request.httpBody = bodyUnencoded.data(using: .utf8)

        weak var weakSelf = self
        loginTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 404:
                    print("\(httpResponse.statusCode) - Not Found")
                default:
                    print("\(httpResponse.statusCode) - Undefined")
                }
            }
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print("Received JSON:")
                print(responseJSON)
                if let token = responseJSON["token"] as? String{
                    UserDefaults().setValue(token, forKey: "jwt")
                    DispatchQueue.main.async {
                        wv.removeFromSuperview()
                        weakSelf?.navigationController?.popViewController(animated: false)
                    }
                }
            }else{
                let responseText = String(decoding: data, as: UTF8.self)
                print("Received non-JSON")
                print(responseText)
            }
            DispatchQueue.main.async {
                wv.removeFromSuperview()
                weakSelf?.switchToLogin()
            }
            
        }

        loginTask?.resume()
        
        
        //push the returned information to a new view on the nav controller
    }
    
    @objc func cancelLogin(){
        loginTask?.cancel()
        switchToLogin()
    }
    
    func switchToCancel(){
        submitButton?.removeTarget(self, action: #selector(self.submitLogin), for: .touchUpInside)
        submitButton?.addTarget(self, action: #selector(self.cancelLogin), for: .touchUpInside)
        submitButton?.setTitle("Cancel", for: .normal)
    }
    
    func switchToLogin(){
        submitButton?.removeTarget(self, action: #selector(cancelLogin), for: .touchUpInside)
        submitButton?.addTarget(self, action: #selector(submitLogin), for: .touchUpInside)
        submitButton?.setTitle("Login", for: .normal)
        waitingView?.removeFromSuperview()
    }
    
}
