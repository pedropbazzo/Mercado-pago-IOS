//
//  SavedCardToken.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 1/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest
@testable import MercadoPagoSDKV4

class SavedCardTokenTest: BaseTest {

    let card = MockBuilder.buildCard()
    func testInit() {
        let savedCardToken = PXSavedCardToken(cardId: "cardId", securityCode: "123")
        XCTAssertEqual(savedCardToken.cardId, "cardId")
        XCTAssertEqual(savedCardToken.securityCode, "123")
    }

    func testInitWithCard() {
        let savedCard = PXSavedCardToken(card: card, securityCode: "123", securityCodeRequired: true)
        XCTAssertEqual(savedCard.cardId, card.id)
        XCTAssertEqual(savedCard.securityCode, "123")
        XCTAssertTrue(savedCard.securityCodeRequired)
    }
}
