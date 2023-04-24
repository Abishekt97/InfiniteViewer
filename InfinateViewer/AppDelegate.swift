//
//  AppDelegate.swift
//  InfinateViewer
//
//  Created by Abishek Thangaraj on 24/04/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
                
        // Set initial view controller
        setRootViewController(ViewController())
        
        return true
    }

}

extension AppDelegate{
    
    func setRootViewController(_ viewController: UIViewController){
        
        window = UIWindow(frame: UIScreen.main.bounds)
        navigationController = UINavigationController(rootViewController: viewController)
        navigationController?.setNavigationBarHidden(true, animated: true)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
    }
    
}
