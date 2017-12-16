//
//  BLMigration.swift
//  BLMigration_iOS
//
//  Created by Benny Lach on 16.12.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import Foundation

public typealias BLMigrationBlock = (() -> Void)

open class BLMigration {
    public static func migrate(version: String, migrationBlock: BLMigrationBlock) {
        if version.compare(lastMigrationVersion, options: .numeric) == .orderedDescending && version.compare(appVersion, options: .numeric) != .orderedDescending {
            migrationBlock()
            
            #if DEBUG
                print("BLMigration: Running migration for version ", version)
            #endif
            
            lastMigrationVersion = version
        }
    }
    
    public static func migrate(build: String, migrationBlock: BLMigrationBlock) {
        if build.compare(lastMigrationBuild, options: .numeric) == .orderedDescending && build.compare(appBuild, options: .numeric) != .orderedDescending {
            migrationBlock()
            
            #if DEBUG
                print("BLMigration: Running migration for build ", build)
            #endif
            
            lastMigrationBuild = build
        }
    }
    
    public static func applicationUpdate(updateBlock: BLMigrationBlock) {
        if lastAppVersion != appVersion {
            updateBlock()
            
            #if DEBUG
                print("BLMigration: Running update for version ", appVersion)
            #endif
            
            // TODO: - Check optional stuff
            lastAppVersion = appVersion
        }
    }
    
    public static func buildNumberUpdate(updatBlock: BLMigrationBlock) {
        if lastAppBuild != appBuild {
            updatBlock()
            
            #if DEBUG
                print("BLMigration: Running update for build ", appBuild)
            #endif
            
            // TODO: - Check optional stuff
            lastAppBuild = appBuild
        }
    }
    
    public static func reset() {
        lastMigrationVersion = ""
        lastAppVersion = ""
        lastMigrationBuild = ""
        lastAppBuild = ""
    }
}


//MARK - Internal getter / setter
public extension BLMigration {
    private static var defaults: UserDefaults {
        return UserDefaults.standard
    }
    
    // Public getter only also available outside the framework
    public static var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }
    
    public static var appBuild: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion" ) as? String ?? "1.0"
    }
    
    // Public getter / private setter
    public(set) static var lastMigrationVersion: String {
        get {
            if let _version = defaults.string(forKey: Constants.lastMigrationVersionKey) {
                return _version
            }
            return ""
        }
        set {
            defaults.setValue(newValue, forKey: Constants.lastMigrationVersionKey)
            defaults.synchronize()
        }
    }
    
    public(set) static var lastMigrationBuild: String {
        get {
            if let _build = defaults.string(forKey: Constants.lastMigrationBuildKey) {
                return _build
            }
            return ""
        }
        set {
            defaults.setValue(newValue, forKey: Constants.lastMigrationBuildKey)
            defaults.synchronize()
        }
        
    }
    
    public(set) static var lastAppVersion: String {
        get {
            if let _version = defaults.string(forKey: Constants.lastAppVersionKey) {
                return _version
            }
            return ""
        }
        set {
            defaults.setValue(newValue, forKey: Constants.lastAppVersionKey)
            defaults.synchronize()
        }
    }
    
    public(set) static var lastAppBuild: String {
        get {
            if let _build = defaults.string(forKey: Constants.lastAppBuildKey) {
                return _build
            }
            return ""
        }
        set {
            defaults.setValue(newValue, forKey: Constants.lastAppBuildKey)
            defaults.synchronize()
        }
    }
}

