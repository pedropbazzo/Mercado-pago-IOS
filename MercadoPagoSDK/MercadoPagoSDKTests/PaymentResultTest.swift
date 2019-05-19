//
//  PaymentResultTest.swift
//  MercadoPagoSDK
//
//  Created by Mauro Reverter on 6/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import XCTest
@testable import MercadoPagoSDKV4

class PaymentResultTest: BaseTest {
    override func setUp() {
        super.setUp()
    }

    func testPayerEmailObtainedFromPaymentData() {
        let payment = PXPayment(id: 1, status: "approved")
        payment.statusDetail = "accredited"
        let payer = PXPayer(email: "unemail@gmail.com")
        let paymentData = PXPaymentData()
        paymentData.payer = payer
        let paymentResult = PaymentResult(payment: payment, paymentData: paymentData)
        XCTAssertEqual(paymentResult.payerEmail, "unemail@gmail.com")
    }
}
