//
//  Logging.swift
//  AppExtension
//
//  Created by Vaibhav Parmar on 11/12/18.
//  Copyright © 2020 Nickelfox. All rights reserved.
//

import Foundation
import FLLogs

public func logVerbose(_ closure: @autoclosure @escaping () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String: Any] = [:]) {
    
    verboselog(closure(), functionName: functionName,
               fileName: fileName, lineNumber: lineNumber,
               userInfo: userInfo)
}

public func logDebug(_ closure: @autoclosure @escaping () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String: Any] = [:]) {
    debuglog(closure(), functionName: functionName,
               fileName: fileName, lineNumber: lineNumber,
               userInfo: userInfo)
}

public func logInfo(_ closure: @autoclosure @escaping () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String: Any] = [:]) {
    infolog(closure(), functionName: functionName,
               fileName: fileName, lineNumber: lineNumber,
               userInfo: userInfo)
}

public func logWarning(_ closure: @autoclosure @escaping () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String: Any] = [:]) {
    warninglog(closure(), functionName: functionName,
               fileName: fileName, lineNumber: lineNumber,
               userInfo: userInfo)
}

public func logError(_ closure: @autoclosure @escaping () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String: Any] = [:]) {
    errorlog(closure(), functionName: functionName,
               fileName: fileName, lineNumber: lineNumber,
               userInfo: userInfo)
}

public func logSevere(_ closure: @autoclosure @escaping () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String: Any] = [:]) {
    severelog(closure(), functionName: functionName,
               fileName: fileName, lineNumber: lineNumber,
               userInfo: userInfo)
}
