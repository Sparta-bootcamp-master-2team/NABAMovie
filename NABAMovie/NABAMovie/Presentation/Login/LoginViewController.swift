//
//  LoginViewController.swift
//  NABAMovie
//
//  Created by 양원식 on 4/28/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    private let loginView = LoginView()
    
    
    override func loadView() {
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

}
