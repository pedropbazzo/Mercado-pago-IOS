//
//  SavedESCCardTokenTest.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 7/20/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import XCTest
@testable import MercadoPagoSDKV4

class SavedESCCardTokenTest: BaseTest {

    func testInit() {
        let savedESCCardToken = PXSavedESCCardToken(cardId: "cardId", securityCode: "123", requireESC: false)
        XCTAssertEqual(savedESCCardToken.cardId, "cardId")
        XCTAssertEqual(savedESCCardToken.securityCode!, "123")
        XCTAssertFalse(savedESCCardToken.requireESC)
    }

    func testInitWithCard() {
        let savedESCCardToken = PXSavedESCCardToken(cardId: "cardId", esc: "esc", requireESC: false)
        XCTAssertEqual(savedESCCardToken.cardId, "cardId")
        XCTAssertEqual(savedESCCardToken.esc, "esc")
        XCTAssertFalse(savedESCCardToken.requireESC)
        XCTAssertEqual(savedESCCardToken.securityCode!, "")
        XCTAssertEqual(savedESCCardToken.device.fingerprint.getDevicesIds()![0].name, PXDevice().fingerprint.getDevicesIds()![0].name)
    }
}
