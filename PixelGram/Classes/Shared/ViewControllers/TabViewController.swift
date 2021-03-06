//
//  TabViewController.swift
//  PixelGram
//
//  Created by Robert Dimitrov on 10/28/17.
//  Copyright © 2017 Robert Dimitrov. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class TabViewController: UIViewController {
    
    private enum TabType: Int {
        case child
        case modal
    }
    
    enum Tab: Int {
        case feed = 0
        case camera
        case profile
        
        var identifier: String {
            switch self {
            case .feed:
                return FeedViewController.storyboardIdentifier
            case .camera:
                return CameraViewController.storyboardIdentifier
            case .profile:
                return ProfileViewController.storyboardIdentifier
            }
        }
        
        private var type: TabType {
            switch self {
            case .camera:
                return .modal
            default:
                return .child
            }
        }
    }

    private var viewControllers = [Int: UIViewController]()
    private var buttons = [UIButton]()
    private let disposeBag = DisposeBag()
    private var selectedTab = Variable(0)
    
    @IBOutlet var homeButton: UIButton?
    @IBOutlet var cameraButton: UIButton?
    @IBOutlet var profileButton: UIButton?
    @IBOutlet var contentView: UIView?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureButtons()
        configureTabbing()
    }
    
    // MARK: - Setup
    
    private func configureTabbing() {
        selectedTab.asObservable().scan([]) { (previous, current) in
            return Array(previous + [current]).suffix(2)
        }.subscribe(onNext: { [weak self] (lastTwoOptions) in
            let oldValue = lastTwoOptions.first
            let currentValue = lastTwoOptions.last
            
            self?.updateSelectedTab(currentValue ?? 0, oldValue: oldValue ?? 0)
        }).disposed(by: disposeBag)
    }
    
    private func configureButtons() {
        guard let homeButton = homeButton, let cameraButton = cameraButton, let profileButton = profileButton else {
            print("Configure Buttons failed. One or more of the buttons is missing.")
            return
        }
        
        buttons.append(contentsOf: [homeButton, cameraButton, profileButton])
        
        for button in buttons {
            configureButton(button: button)
        }
    }
    
    private func configureButton(button: UIButton) {
        let image = button.image(for: .normal)?.withRenderingMode(.alwaysTemplate)
        
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.black.withAlphaComponent(0.25)
        
        button.rx.tap.subscribe(onNext: { [weak self] in
            let index = self?.buttons.index(of: button) ?? 0
            
            self?.handleTabSelection(withSelected: index)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Helpers
    
    func handleTabSelection(withSelected index: Int) {
        if index == Tab.camera.rawValue {
            // Open the camera, don't change the selected tab value
            
            let viewController = instantiateViewControllerForIndex(index)
            present(viewController, animated: true, completion: nil)
        } else {
            selectedTab.value = index
        }
    }
    
    // MARK: - Lazy loading view controller
    
    private func viewControllerForIndex(_ index: Int) -> UIViewController {
        if let viewController = viewControllers[index] {
            return viewController
        }
        
        let viewController = instantiateViewControllerForIndex(index)
        viewControllers[index] = viewController
        
        return viewController
    }
    
    private func instantiateViewControllerForIndex(_ index: Int) -> UIViewController {
        let identifier = Tab(rawValue: index)?.identifier
        let viewController = storyboard?.instantiateViewController(withIdentifier:
            identifier ?? "") ?? UIViewController()
        
        return NavigationController(rootViewController: viewController)
    }
    
    // MARK: - Update state
    
    private func updateSelectedTab(_ currentValue: Int, oldValue: Int = 0) {
        updateSelectedTabButton(currentValue, oldValue: oldValue)
        updateSelectedViewController(currentValue, oldValue: oldValue)
    }
    
    private func updateSelectedTabButton(_ currentValue: Int, oldValue: Int = 0) {
        let previousButton = buttons[oldValue]
        previousButton.isSelected = false
        previousButton.tintColor = UIColor.black.withAlphaComponent(0.25)
        
        let currentButton = buttons[currentValue]
        currentButton.isSelected = true
        currentButton.tintColor = UIColor.black.withAlphaComponent(1.0)
    }
    
    private func updateSelectedViewController(_ currentValue: Int, oldValue: Int = 0) {
        let previousViewController = viewControllers[oldValue]
        let currentViewController = viewControllerForIndex(currentValue)
        
        guard previousViewController != currentViewController else {
            print("View controller didn't change")
            (currentViewController as? UINavigationController)?.popToRootViewController(animated: true)
            return
        }
        
        // Remove the old view controller
        if let previousViewController = previousViewController {
            previousViewController.willMove(toParentViewController: nil)
            previousViewController.view.removeFromSuperview()
            previousViewController.removeFromParentViewController()
        }
        
        // Add the selected view controller as a child subview
        addChildViewController(currentViewController)
        currentViewController.view.frame = contentView?.bounds ?? CGRect.zero
        currentViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView?.addSubview(currentViewController.view)
        currentViewController.didMove(toParentViewController: self)
    }

}

// MARK: - UIViewController extension

extension UIViewController {
    
    var tabViewController: TabViewController? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let viewController = appDelegate.window?.rootViewController as? TabViewController else {
            return nil
        }
        return viewController
    }
    
}
