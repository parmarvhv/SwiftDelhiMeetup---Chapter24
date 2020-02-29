//
//  Logger.swift
//  FLLogs
//
//  Created by Ravindra Soni on 16/12/16.
//  Copyright © 2016 Nickelfox. All rights reserved.
//

import Foundation
import XCGLogger

private var logger = Logger.shared.internalLogger

public class Logger {
	
	public static var shared = Logger()
	
	fileprivate var internalLogger: XCGLogger
	
	init() {
		// Create a logger object with no destinations
		self.internalLogger = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)
		
		// Create a destination for the system console log (via NSLog)
		let systemDestination = AppleSystemLogDestination(identifier: "advancedLogger.systemDestination")
		
		// Optionally set some configuration options
		systemDestination.outputLevel = .debug
		systemDestination.showLogIdentifier = false
		systemDestination.showFunctionName = true
		systemDestination.showThreadName = true
		systemDestination.showLevel = true
		systemDestination.showFileName = true
		systemDestination.showLineNumber = true
		systemDestination.showDate = true
		
		// Add the destination to the logger
		self.internalLogger.add(destination: systemDestination)
		
		// Create a file log destination
		let logsPath = FileManager.default.urls(
			for: FileManager.SearchPathDirectory.documentDirectory,
			in: FileManager.SearchPathDomainMask.userDomainMask
		)[0].appendingPathComponent("Logs", isDirectory: false)
		
		self.internalLogger.info("Logs path: \(logsPath)")
		
		let fileDestination = FileDestination(
			writeToFile: logsPath,
			identifier: "FLLoger.Logs"
		)
		
		// Optionally set some configuration options
		fileDestination.outputLevel = .debug
		fileDestination.showLogIdentifier = false
		fileDestination.showFunctionName = true
		fileDestination.showThreadName = true
		fileDestination.showLevel = true
		fileDestination.showFileName = true
		fileDestination.showLineNumber = true
		fileDestination.showDate = true
		
		// Process this destination in the background
		fileDestination.logQueue = XCGLogger.logQueue
		
		// Add the destination to the logger
		self.internalLogger.add(destination: fileDestination)
		
		// Add basic app info, version info etc, to the start of the logs
		self.internalLogger.logAppDetails()
	}
	
}

public func verboselog(_ closure: @autoclosure @escaping () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String: Any] = [:]) {
	logger.verbose(closure(), functionName: functionName, fileName: fileName, lineNumber: lineNumber, userInfo: userInfo)
}

public func debuglog(_ closure: @autoclosure @escaping () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String: Any] = [:]) {
	logger.debug(closure(), functionName: functionName, fileName: fileName, lineNumber: lineNumber, userInfo: userInfo)
}

public func infolog(_ closure: @autoclosure @escaping () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String: Any] = [:]) {
	logger.info(closure(), functionName: functionName, fileName: fileName, lineNumber: lineNumber, userInfo: userInfo)
}

public func warninglog(_ closure: @autoclosure @escaping () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String: Any] = [:]) {
	logger.warning(closure(), functionName: functionName, fileName: fileName, lineNumber: lineNumber, userInfo: userInfo)
}

public func errorlog(_ closure: @autoclosure @escaping () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String: Any] = [:]) {
	logger.error(closure(), functionName: functionName, fileName: fileName, lineNumber: lineNumber, userInfo: userInfo)
}

public func severelog(_ closure: @autoclosure @escaping () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String: Any] = [:]) {
	logger.severe(closure(), functionName: functionName, fileName: fileName, lineNumber: lineNumber, userInfo: userInfo)
}
