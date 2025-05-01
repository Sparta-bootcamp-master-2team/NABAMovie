import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    deinit {
        print("SceneDelegate deinit")
    }
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        let container = AppFactory()
        let coordinator = AppCoordinator(window: window, diContainer: container)

        self.window = window
        self.appCoordinator = coordinator
        coordinator.start()
    }
}
