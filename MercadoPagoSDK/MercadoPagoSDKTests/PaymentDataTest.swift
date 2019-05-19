//
//  PaymentDataTest.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 7/21/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import XCTest
@testable import MercadoPagoSDKV4

class PaymentDataTest: BaseTest {

    func testClearCollectData() {
        let paymentData = MockBuilder.buildPaymentData()
        paymentData.setDiscount(MockBuilder.buildDiscount(), withCampaign: MockBuilder.buildCampaign())
        paymentData.clearCollectedData()
        XCTAssertNotNil(paymentData.discount!.id)
        XCTAssertNotNil(paymentData.payer)
        XCTAssertNil(paymentData.paymentMethod)
        XCTAssertNil(paymentData.issuer)
        XCTAssertNil(paymentData.payerCost)
        XCTAssertNil(paymentData.token)
        XCTAssertNil(paymentData.transactionDetails)
    }

    func testHasToken() {
        let paymentData = MockBuilder.buildPaymentData()
        XCTAssert(paymentData.hasToken())
        paymentData.token = nil
        XCTAssertFalse(paymentData.hasToken())
    }

    func testHasPaymentMethod() {
        let paymentData = MockBuilder.buildPaymentData()
        XCTAssert(paymentData.hasPaymentMethod())
        paymentData.paymentMethod = nil
        XCTAssertFalse(paymentData.hasPaymentMethod())
    }

    func testHasPayerCost() {
        let paymentData = MockBuilder.buildPaymentData()
        XCTAssert(paymentData.hasPayerCost())
        paymentData.payerCost = nil
        XCTAssertFalse(paymentData.hasPayerCost())
    }

    func testHasIssuer() {
        let paymentData = MockBuilder.buildPaymentData()
        XCTAssert(paymentData.hasIssuer())
        paymentData.issuer = nil
        XCTAssertFalse(paymentData.hasIssuer())
    }

}
