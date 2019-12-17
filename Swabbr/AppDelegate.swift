//
//  AppDelegate.swift
//  Swabbr
//
//  Created by James Bal on 16-09-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    // MARK: UNUserNotificationCenterDelegate
    var configValues: NSDictionary?
    var notificationHubNamespace: String?
    var notificationHubName: String?
    var notificationHubKeyName: String?
    var notificationHubKey: String?
    let tags = ["iOS"]

    // MARK: UIApplicationDelegate
    var window: UIWindow?
    
    var registrationService : NotificationRegistrationService?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if UserDefaults.standard.getUserId() == nil {
            UserDefaults.standard.setUserId(value: 1)
        }
        
        if(CommandLine.arguments.contains("testing")) {
            ApiPreferences.shared = ApiPreferences.getAPIPreferences(enviroment: .test)
        }
        
        // MARK: UNUserNotificationCenterDelegate
        if let path = Bundle.main.path(forResource: "Notification-Hub-Settings", ofType: "plist") {
            if let configValues = NSDictionary(contentsOfFile: path) {
                self.notificationHubNamespace = configValues["notificationHubNamespace"] as? String
                self.notificationHubName = configValues["notificationHubName"] as? String
                self.notificationHubKeyName = configValues["notificationHubKeyName"] as? String
                self.notificationHubKey = configValues["notificationHubKey"] as? String
            }
        }
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                if granted {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                }
            }
        }
        
//        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        var rootViewController: UIViewController?
        if UserDefaults.standard.string(forKey: "user") != nil {
            // setup window
            rootViewController = TimelineViewController(nibName: nil, bundle: nil)
            let navigationController = UINavigationController(rootViewController: rootViewController!)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        } else {
            rootViewController = LoginViewController()
            window?.rootViewController = rootViewController
            window?.makeKeyAndVisible()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

// MARK: UNUserNotificationCenterDelegate
extension AppDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        let installationId = (UIDevice.current.identifierForVendor?.description)!
        let pushChannel = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})

        // Initialize the Notification Registration Service
        self.registrationService = NotificationRegistrationService(
            withInstallationId: installationId,
            andPushChannel: pushChannel,
            andHubNamespace: notificationHubNamespace!,
            andHubName: notificationHubName!,
            andKeyName: notificationHubKeyName!,
            andKey: notificationHubKey!)

        // Call register, passing in the tags and template parameters
        // ["genericTemplate" : self.genericTemplate]
        self.registrationService!.register(withTags: nil) { (result) in
            if !result {
                print("Registration issue")
            } else {
                print("Registered")
            }
        }
    }
    
    func showAlert(withText text: String) {
        let alertController = UIAlertController(title: "Test", message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    @available(iOS 10, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        handleNotification(with: notification.request.content.userInfo)
        showAlert(withText: notification.request.content.body)
    }
    
    @available(iOS 10, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        handleNotification(with: response.notification.request.content.userInfo)
        print(response.notification.request.content.userInfo)
        showAlert(withText: response.notification.request.content.body)
    }
    
    private func handleNotification(with userInfo: [AnyHashable : Any]) {
        let jsonData = try? JSONSerialization.data(withJSONObject: userInfo["payload"]!, options: [])
        let notificationObject = try? JSONDecoder().decode(Payload<SNotification>.self, from: jsonData!)
        switch notificationObject!.innerData.clickAction {
        case .followedProfileLive:
            // timeline with specific vlog
            break
        case .inactiveUserMotivate:
            // timelineviewcontroller
            break
        case .inactiveUnwatchedVlogs:
            // followers list
            break
        case .inactiveVlogRecordRequest:
            // timelineviewcontroller
            break
        case .vlogGainedLikes:
            break
        case .vlogNewReaction:
            break
        case .vlogRecordRequest:
            // vlogstreamviewcontroller
            break
        }
        
    }
    
}

