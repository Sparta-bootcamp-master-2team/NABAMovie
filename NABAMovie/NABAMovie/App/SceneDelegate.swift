import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
                   willConnectTo session: UISceneSession,
                   options connectionOptions: UIScene.ConnectionOptions) {
            
            guard let windowScene = (scene as? UIWindowScene) else { return }
            
            self.window = UIWindow(windowScene: windowScene)

            if let _ = Auth.auth().currentUser {
                // 로그인 되어 있으면 홈 화면
                let repository = MovieRepositoryImpl(networkManager: MovieNetworkManager())
                let usecase = FetchHomeScreenMoviesUseCase(repository: repository)
                let homeVM = HomeViewModel(usecase: usecase)
                let homeVC = HomeViewController(viewModel: homeVM)
                window?.rootViewController = homeVC
            } else {
                // 로그인 안 되어 있으면 로그인 화면
                let loginViewModel = LoginViewModel(loginUseCase: LoginUseCase(repository: FirebaseAuthRepositoryImpl(firebaseService: FirebaseService())))
                window?.rootViewController = LoginViewController(viewModel: loginViewModel)
            }
            
            window?.makeKeyAndVisible()
        }
}
