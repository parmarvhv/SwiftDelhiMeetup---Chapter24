//
//  AppDelegate.swift
//  AppExtension
//
//  Created by Vaibhav Parmar on 11/12/18.
//  Copyright © 2020 Nickelfox. All rights reserved.
//


import UIKit
import AppCenter
import AppCenterCrashes
import AppCenterAnalytics
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.setupAppCenterAnalytics()
        self.registerFirebase()
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

// MARK: AppCenter
extension AppDelegate {
    
    private func setupAppCenterAnalytics() {
        MSAppCenter.start(Configuration.AppCenterAppSecret,
                          withServices: [MSAnalytics.self, MSCrashes.self])
    }
    
}

// MARK: MessagingDelegate
extension AppDelegate: MessagingDelegate {
    
    func registerFirebase() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
            Messaging.messaging().delegate = self
            self.registerForPushNotifications()
        }
        #if RELEASE
        Analytics.setAnalyticsCollectionEnabled(true)
        #else
        Analytics.setAnalyticsCollectionEnabled(false)
        #endif
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage)
    }
    
}

// MARK: Remote Notifications
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func registerForPushNotifications() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (flag, _) in
            if flag {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                center.getNotificationSettings { settings in
                    if settings.authorizationStatus == .authorized {
                        
                    }
                }
            }
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.hexString
        print("didRegisterForRemoteNotificationsWithDeviceToken \(token)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let info = notification.request.content.userInfo
        print("APNS WillPresent: \(info)")
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let info = response.notification.request.content.userInfo
        print("APNS DidReceive: \(info)")
        completionHandler()
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNS DidFailToRegister: \(error)")
    }
    
}

extension Data {
    
    var hexString: String {
        return self.reduce("") { string, byte in
            string + String(format: "%02X", byte)
        }
    }
}
