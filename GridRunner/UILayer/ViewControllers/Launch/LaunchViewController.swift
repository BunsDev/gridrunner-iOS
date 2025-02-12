//
//  LaunchViewController.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.06.23.
//

import UIKit

class LaunchViewController: UIViewController {

    var forceUpgrade: Bool = false
    let alertAdapter: AlertAdapter = AlertAdapter()
    
    @IBOutlet weak var loadingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadingLabel.text = "Fetching user preferences..."
        
        // Check API version. If API version needs force upgrade show pop up.
        // Make API call to check for API availability
        if isAPIAvailable() {
            DispatchQueue.main.async {
                let alert = self.alertAdapter.createForceUpgradeAlert(completion: self.transitionToMainScreen)
                self.present(alert, animated: true)
            }
        } else {
            self.transitionToMainScreen()
        }
    }

    private func transitionToMainScreen() {
        AppDelegate.shared.performNetworkRequest { _ in
            let mainViewController: MainViewController = MainViewController()
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegate?.transitionViewController.transition(to: mainViewController, with: [.transitionCurlUp])
        }
    }
    
    private func isAPIAvailable() -> Bool {
        self.forceUpgrade
    }
}
