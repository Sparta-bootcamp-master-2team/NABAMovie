import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let headerView = HeaderView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      navigationController?.setNavigationBarHidden(true, animated: true) // 뷰 컨트롤러가 나타날 때 숨기기
    }

    override func viewWillDisappear(_ animated: Bool) {
      navigationController?.setNavigationBarHidden(false, animated: true) // 뷰 컨트롤러가 사라질 때 나타내기
    }
}

// MARK: - Configure

private extension MainViewController {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
    }
    
    func setAttributes() {
        view.backgroundColor = .secondarySystemBackground
    }
    
    func setHierarchy() {
        view.addSubview(headerView)
    }
    
    func setConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    func setBindings() {
        
    }
}
