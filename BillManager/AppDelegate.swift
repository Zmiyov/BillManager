//
//  AppDelegate.swift
//  BillManager
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let notificationID = response.notification.request.identifier
        print(notificationID)
        var bill = Database().getBill(for: notificationID)
        print(bill?.remindDate)
        
        if response.actionIdentifier == Bill.remindInAnHourActionID {
            let snoozeDate = Date().addingTimeInterval(60 * 60)
            bill?.schedule(date: snoozeDate, completion: { bill in
                Database.shared.updateAndSave(bill)
            })
            print(Bill.remindInAnHourActionID)
            print(Date())
            print(snoozeDate)
            
        } else if response.actionIdentifier == Bill.markAsPaidActionID {
            bill?.paidDate = Date()
//            Database.shared.updateAndSave(bill!)
            print(Bill.markAsPaidActionID)
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner, .list])
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let center = UNUserNotificationCenter.current()
        let remindInAnHourAction = UNNotificationAction(identifier: Bill.remindInAnHourActionID, title: "In Hour", options: [])
        let markAsPaidAction = UNNotificationAction(identifier: Bill.markAsPaidActionID, title: "Mark", options: [.authenticationRequired])
        let remindCategory = UNNotificationCategory(identifier: Bill.notificationCategoryID, actions: [remindInAnHourAction, markAsPaidAction], intentIdentifiers: [], options: [])
        center.setNotificationCategories([remindCategory])
        center.delegate = self
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

