//
//  PaymentMethodSearchTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 1/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest
@testable import MercadoPagoSDKV4
class PaymentMethodSearchTest: BaseTest {

    func testPaymentOptionsCount() {
        let customerMethod = PXCustomOptionSearchItem(id: "String", description: nil, paymentMethodId: nil, paymentTypeId: nil)

        let customOptions = [customerMethod]

        let paymentOption = MockBuilder.buildPaymentMethodSearchItem("id")
        let anotherPaymentOption = MockBuilder.buildPaymentMethodSearchItem("anotherId")
        let anotherMorePaymentOption = MockBuilder.buildPaymentMethodSearchItem("anotherId")

        let paymentOptions = [paymentOption, anotherPaymentOption, anotherMorePaymentOption]

        let paymentMethodSearch = PXPaymentMethodSearch(paymentMethodSearchItem: paymentOptions, customOptionSearchItems: customOptions, paymentMethods: [], cards: nil, defaultOption: nil, oneTap: nil)

        XCTAssertEqual(paymentMethodSearch.getPaymentOptionsCount(), 4)

    }

    func testOnlyCustomOptions() {
        let customerMethod = PXCustomOptionSearchItem(id: "String", description: nil, paymentMethodId: nil, paymentTypeId: nil)

        let customOptions = [customerMethod]
        let paymentMethodSearch = PXPaymentMethodSearch(paymentMethodSearchItem: [], customOptionSearchItems: customOptions, paymentMethods: [], cards: nil, defaultOption: nil, oneTap: nil)

        XCTAssertEqual(paymentMethodSearch.getPaymentOptionsCount(), 1)

    }

    func testOnlyPaymentOptionsCount() {

        let paymentOption = MockBuilder.buildPaymentMethodSearchItem("id")
        let anotherPaymentOption = MockBuilder.buildPaymentMethodSearchItem("anotherId")
        let anotherMorePaymentOption = MockBuilder.buildPaymentMethodSearchItem("anotherId")

        let paymentOptions = [paymentOption, anotherPaymentOption, anotherMorePaymentOption]

        let paymentMethodSearch = PXPaymentMethodSearch(paymentMethodSearchItem: paymentOptions, customOptionSearchItems: [], paymentMethods: [], cards: nil, defaultOption: nil, oneTap: nil)

        XCTAssertEqual(paymentMethodSearch.getPaymentOptionsCount(), 3)

    }

}
