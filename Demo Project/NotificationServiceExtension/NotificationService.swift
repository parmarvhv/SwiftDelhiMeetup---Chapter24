//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by Vaibhav Parmar on 28/02/20.
//  Copyright © 2020 Nickelfox. All rights reserved.
//

import UserNotifications
import Model

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        defer {
            contentHandler(self.bestAttemptContent ?? request.content)
        }
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            
            let notificationBody = bestAttemptContent.body
            
            do {
                let detector = try NSDataDetector(
                    types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue
                )
                let matches = detector.matches(
                    in: notificationBody,
                    range: NSRange(notificationBody.startIndex...,
                                   in: notificationBody)
                )
                
                if let phoneNumber = matches.first?.phoneNumber {
                    let name = ContactsUtility.shared.getName(for: phoneNumber)
                    let body = notificationBody.replacingOccurrences(of: phoneNumber, with: name)
                    bestAttemptContent.body = body
                }
            } catch {
                print(error)
            }
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
