//
//  RootViewController.swift
//  BasicAuthentication
//
//  Created by Benjamin Lewis on 3/17/21.
//

import UIKit

class RootViewController: UIViewController {

    var userIdField = UITextField(frame: CGRect())
    var goodAfterField = UITextField(frame: CGRect())
    var expiresField = UITextField(frame: CGRect())
    var validView = UIView(frame: CGRect())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("disappeared");
    }
}

extension RootViewController{
    func setupView(){
        let df = UITextField(frame: CGRect())
        
        view.backgroundColor = .gray
        
        view.addSubview(userIdField)
        view.addSubview(goodAfterField)
        view.addSubview(expiresField)
        view.addSubview(validView)
        view.addSubview(df)
        
        df.textColor = .label
        df.textAlignment = .center
        df.translatesAutoresizingMaskIntoConstraints = false
        df.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        df.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        df.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        df.text = "JWT Payload"
        
        userIdField.textColor = .label
        userIdField.textAlignment = .center
        userIdField.translatesAutoresizingMaskIntoConstraints = false
        userIdField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        userIdField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        userIdField.topAnchor.constraint(equalTo: df.bottomAnchor, constant: 20.0).isActive = true
        
        goodAfterField.textColor = .label
        goodAfterField.textAlignment = .center
        goodAfterField.translatesAutoresizingMaskIntoConstraints = false
        goodAfterField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        goodAfterField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        goodAfterField.topAnchor.constraint(equalTo: userIdField.bottomAnchor, constant: 20.0).isActive = true
        
        expiresField.textColor = .label
        expiresField.textAlignment = .center
        expiresField.translatesAutoresizingMaskIntoConstraints = false
        expiresField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        expiresField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        expiresField.topAnchor.constraint(equalTo: goodAfterField.bottomAnchor, constant: 20.0).isActive = true
        
        validView.translatesAutoresizingMaskIntoConstraints = false
        validView.topAnchor.constraint(equalTo: expiresField.bottomAnchor, constant: 20.0).isActive = true
        validView.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        validView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        validView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        validView.layer.cornerRadius = 15
        validView.clipsToBounds = true
        validView.backgroundColor = .green
        
        weak var weakSelf = self
        let logoutButton = UIBarButtonItem(title: "Logout", primaryAction: UIAction(){ _ in
            UserDefaults().setValue(nil, forKey: "jwt")
            weakSelf?.userIdField.text = nil
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let sceneDelegate = windowScene.delegate as? SceneDelegate else {
                return
            }
            sceneDelegate.activateLoginView()
        })
        
        self.setToolbarItems([logoutButton], animated: true)
        self.navigationController!.setToolbarHidden(false, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func updateView(){
        guard let jwtString = UserDefaults().string(forKey: "jwt") else{
            return
        }
        do{
            let jwt = try decode(jwt: jwtString)
            userIdField.text = "User ID: \(jwt.userId ?? "")"
            goodAfterField.text = "Issued: \(jwt.notBefore?.toFormatted(.ymDhms) ?? "")"
            expiresField.text = "Expires: \(jwt.expiresAt?.toFormatted(.ymDhms) ?? "")"
            if(jwt.expired){
                validView.backgroundColor = .red
            }else{
                validView.backgroundColor = .green
            }
            return
        }catch{
            
        }
        userIdField.text = UserDefaults().string(forKey: "jwt")
    }
}
