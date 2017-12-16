//
//  BLMigration_iOSTests.swift
//  BLMigration_iOSTests
//
//  Created by Benny Lach on 16.12.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import XCTest
@testable import BLMigration

class BLMigrationTests: XCTestCase {
    private let EXPECTATION_TIMEOUT: TimeInterval = 2.0
    
    override func setUp() {
        super.setUp()
        BLMigration.reset()
    }
    
    func testMigrationReset() {
        let expectBlock1 = expectation(description: "Expecting block to be run for version 0.9")
        
        BLMigration.migrate(version: "0.9") {
            expectBlock1.fulfill()
        }
        
        let expectBlock2 = expectation(description: "Expecting block to be run for version 1.0")
        
        BLMigration.migrate(version: "1.0") {
            expectBlock2.fulfill()
        }
        
        BLMigration.reset()
        
        let expectBlock3 = expectation(description: "Expecting block to be run AGAIN for version 0.9")
        
        BLMigration.migrate(version: "0.9") {
            expectBlock3.fulfill()
        }
        
        let expectBlock4 = expectation(description: "Expecting block to be run AGAIN for version 1.0")
        
        BLMigration.migrate(version: "1.0") {
            expectBlock4.fulfill()
        }
        
        waitForAllExpectations()
    }
    
    func testMigrationOnFirstRun() {
        let expectBlock = expectation(description: "Should execute migration after reset")
        
        BLMigration.migrate(version: "1.0") {
            expectBlock.fulfill()
        }
        
        waitForAllExpectations()
    }
    
    func testMigratesOnce() {
        let expectBlock = expectation(description: "Expecting block to be run")
        
        BLMigration.migrate(version: "1.0") {
            expectBlock.fulfill()
        }
        
        BLMigration.migrate(version: "1.0") {
            XCTFail("Should not execute a block for the same version twice.")
        }
        
        waitForAllExpectations()
    }
    
    func testMigratesPreviousBlocks() {
        let expectBlock1 = expectation(description:"Expecting block to be run for version 0.9")
        BLMigration.migrate(version: "0.9") {
            expectBlock1.fulfill()
        }
        
        let expectBlock2 = expectation(description:"Expecting block to be run for version 1.0")
        BLMigration.migrate(version: "1.0") {
            expectBlock2.fulfill()
        }
        
        waitForAllExpectations()
    }
    
    func testMigratesInNaturalSortOrder() {
        let expectBlock1 = expectation(description:"Expecting block to be run for version 0.9")
        BLMigration.migrate(version: "0.9") {
            expectBlock1.fulfill()
        }
        
        BLMigration.migrate(version: "0.1") {
            XCTFail("Should use natural sort order, e.g. treat 0.10 as a follower of 0.9")
        }
        
        let expectingBlock2 = expectation(description:"Expecting block to be run for version 0.10")
        BLMigration.migrate(version: "0.10") {
            expectingBlock2.fulfill()
        }
        
        waitForAllExpectations()
    }
    
    func testRunsApplicationUpdateBlockOnce() {
        let expectationBlock = self.expectation(description: "Should only call block once")
        BLMigration.applicationUpdate {
            expectationBlock.fulfill()
        }
        
        BLMigration.applicationUpdate {
            XCTFail("Expected applicationUpdateBlock to be called only once")
        }
        
        waitForAllExpectations()
    }
    
    func testRunsApplicationUpdateBlockeOnlyOnceWithMultipleMigrations() {
        BLMigration.migrate(version: "0.8") {
            
        }
        
        BLMigration.migrate(version: "0.9") {
            
        }
        
        BLMigration.migrate(version: "0.10") {
            
        }
        
        
        let expectationBlock = expectation(description:"Should call the applicationUpdateBlock only once no matter how many migrations have to be done")
        BLMigration.applicationUpdate {
            expectationBlock.fulfill()
        }
        
        waitForAllExpectations()
    }
    private func waitForAllExpectations() {
        waitForExpectations(timeout: EXPECTATION_TIMEOUT) { (_) in
            
        }
    }
}

