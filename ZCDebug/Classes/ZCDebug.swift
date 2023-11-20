//
//  ZCDebug.swift
//
//  Created by Sergey Zalozniy
//  All rights reserved.
//

import Foundation
import UIKit
import OSLog

private let kErrorMark: String = "❌"
private let kWarningMark: String = "❗"
private let kDebugMark: String = "💬"

@available(iOS 14.0, *)
public var useAppleLogger: Bool = true

@available(iOS 14.0, *)
private extension Logger {
    private static let appIdentifier = Bundle.main.bundleIdentifier ?? "com.app.logger"
    static let main = Logger(subsystem: appIdentifier, category: "main")
}

#if DEBUG
public func _$c(_ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    swift_print(kDebugMark, textObject: "", file: file, function: function, line: line)
}

public func _$l<T>(_ debug: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    swift_print(kDebugMark, textObject: debug, file: file, function: function, line: line)
}

public func _$le<T>(_ debug: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    swift_print(kErrorMark, textObject: debug, file: file, function: function, line: line)
}

public func _$lw<T>(_ debug: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    swift_print(kWarningMark, textObject: debug, file: file, function: function, line: line)
}

@discardableResult
public func _$tf(file: String = #file, _ function: String = #function, _ line: Int = #line) -> Any? {
    let obj = ZCDebugObject(file: file, function: function, line: line)
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: { _ = obj.startTime }) // Prevent object from immediate dealocation
    return obj
}

public func _$fail(_ condition: Bool = true, reason: String, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    guard condition else {
        return
    }
    let stackSymbols = Thread.callStackSymbols.reduce("", { (result, value) -> String in
        return result + "\n" + value
    })
    let message = "❗❗❗ fail: " + reason + "❗❗❗\n"
    _$le(message, file, function, line)
    if #available(iOS 14.0, *), useAppleLogger {
        Logger.main.critical("\(stackSymbols)")
    } else {
        print(stackSymbols)
    }
    abort()
}
#else
public func _$c(_ file: String = #file, _ function: String = #function, _ line: Int = #line) {}

public func _$l<T>(_ debug: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {}

public func _$le<T>(_ debug: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {}

public func _$lw<T>(_ debug: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {}

public func _$tf(file: String = #file, _ function: String = #function, _ line: Int = #line) -> Any? { return nil }

public func _$fail(_ condition: Bool = true, reason: String, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {}
#endif

private func swift_print<T>(_ prefix: String, textObject: T, file: String, function: String, line: Int) {
    var text = ""
    if let stringObject = textObject as? String {
        text = stringObject
    } else {
        text = "\(textObject)"
    }
    let filename = ((file as NSString).lastPathComponent as NSString).deletingPathExtension
    let message = String(format: "\(prefix) \(timenow()) \(filename) [\(function)] : %-4d ~~ %@",
                         line,
                         text)
    if #available(iOS 14.0, *), useAppleLogger {
        let main = Logger.main
        switch prefix {
        case kDebugMark:
            main.debug("\(message)")
        case kWarningMark:
            main.warning("\(message)")
        case kErrorMark:
            main.critical("\(message)")
        default:
            main.info("\(message)")
        }
    } else {
        print(message)
    }
}

private func timenow() -> String {
    var buffer: [Int8] = [Int8](repeating: 0, count: 17)
    var atime: time_t = time(nil)
    
    let milliseconds: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
    var integer: Double = 0.0
    let fraction = Int(modf(milliseconds, &integer) * 1000)
    
    let format = "%H:%M:%S."
    strftime_l(&buffer, buffer.count, format, localtime(&atime), nil)
    return String(cString: buffer) + String(format: "%03d", fraction)
}

private class ZCDebugObject {
    let startTime = CFAbsoluteTimeGetCurrent()
    private var file = ""
    private var function = ""
    private var line = 0
    
    init(file: String = #file, function: String = #function, line: Int = #line) {
        self.file = file
        self.function = function
        self.line = line
        swift_print(kDebugMark, textObject: "Start \(function)", file: file, function: function, line: line)
    }
    
    deinit {
        let message = "Finished \(function) in \(CFAbsoluteTimeGetCurrent() - self.startTime)"
        swift_print(kDebugMark, textObject: message , file: file, function: function, line: line)
    }
}
