//
//  BaseCase.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 21/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest
@testable import MercadoPagoSDKV4

class BaseTest: XCTestCase {

    static let WAIT_FOR_REQUEST_EXPECTATION_DESCRIPTION = "waitForRequest"
    static let WAIT_FOR_NAVIGATION_CONTROLLER = "waitForNavigationController"
    static let WAIT_FOR_VIEW_LOADED = "waitForViewDidLoad"
    static let WAIT_EXPECTATION_TIME_INTERVAL = 10.0

    override func setUp() {
        super.setUp()
        SiteManager.shared.setSite(siteId: "MLA")
    }

    override func tearDown() {
        super.tearDown()
    }

}
