//
//  UIViewController+.swift
//  NABAMovie
//
//  Created by 양원식 on 4/29/25.
//

import UIKit

extension UIViewController {
    func changeRootViewController(to viewController: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }

    func navigateToHome() {
        changeRootViewController(to: TestHomeViewController())
    }

    func navigateToLogin() {
        let loginVM = LoginViewModel(loginUseCase: LoginUseCase(repository: FirebaseAuthRepositoryImpl(firebaseService: FirebaseService())))
        changeRootViewController(to: LoginViewController(viewModel: loginVM))
    }
}
