//
//  AppDelegate.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 03.05.23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.        
        return true
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // Get user activity
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let incomingUrl = userActivity.webpageURL,
              let components = NSURLComponents(url: incomingUrl, resolvingAgainstBaseURL: true) else {
            return false
        }
              
        // Check for specific URL component
        guard let path = components.path,
              let params = components.queryItems else {
            print("AppDelegate: Invalid URL or path missing")
            return false
        }
        
        print("AppDelegate: path = \(path)")
        
        if let roomCode = params.first(where: {$0.name == "roomCode"})?.value {
            print("AppDelegate: room code = \(roomCode)")
            return true
        } else {
            print("AppDelegate: room code is missing")
            return false
        }
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func performNetworkRequest(completion: @escaping (Response) -> Void) {
        let session = UserDefaults.standard.value(forKey: "session")
        if let session = session {
            UserService().getUser() { response in
                DispatchQueue.main.async {
                    if response == .success {
                        NSLog("User retrieval completed successfully. Session: \(session)")
                        completion(.success)
                    } else {
                        NSLog("Cannot get User.")
                        completion(.requestError)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                NSLog("No session found.")
                completion(.requestError)
            }
        }
    }

}

