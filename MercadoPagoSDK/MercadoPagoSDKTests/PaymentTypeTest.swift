//
//  PaymentTypeTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 1/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest
@testable import MercadoPagoSDKV4

class PaymentTypeTest: BaseTest {

    func testInit() {
        let paymentType = PXPaymentType()
        paymentType.id = PXPaymentTypes.CREDIT_CARD.rawValue
        XCTAssertEqual(paymentType.id, PXPaymentTypes.CREDIT_CARD.rawValue)

    }

}
