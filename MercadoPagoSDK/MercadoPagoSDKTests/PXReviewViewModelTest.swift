//
//  PXReviewViewModelTest.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 4/18/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import XCTest
@testable import MercadoPagoSDKV4

class PXReviewViewModelTest: BaseTest {

    var instance: PXReviewViewModel?
    var instanceWithCoupon: PXReviewViewModel?
    var instanceWithCustomSummaryRow: PXReviewViewModel?

    var paymentData: PXPaymentData = PXPaymentData()

    let mockPaymentMethodSearchItem = MockBuilder.buildPaymentMethodSearchItem("paymentMethodId")

    override func setUp() {

        let amountHelper = MockBuilder.buildAmountHelper()
        paymentData = amountHelper.paymentData

        self.instance = PXReviewViewModel(amountHelper: amountHelper, paymentOptionSelected: mockPaymentMethodSearchItem as PaymentMethodOption, reviewConfirmConfig: PXReviewConfirmConfiguration(), userLogged: true)

        amountHelper.paymentData.paymentMethod = MockBuilder.buildPaymentMethod("visa")
        amountHelper.paymentData.payerCost = MockBuilder.buildInstallment().payerCosts[1]
        amountHelper.paymentData.payerCost?.installments = 3
        amountHelper.paymentData.setDiscount(MockBuilder.buildDiscount(), withCampaign: MockBuilder.buildCampaign())
        amountHelper.paymentData.payer = MockBuilder.buildPayer()

        self.instanceWithCoupon = PXReviewViewModel(amountHelper: amountHelper, paymentOptionSelected: mockPaymentMethodSearchItem as PaymentMethodOption, reviewConfirmConfig: PXReviewConfirmConfiguration(), userLogged: true)

        self.instanceWithCustomSummaryRow = PXReviewViewModel(amountHelper: amountHelper, paymentOptionSelected: mockPaymentMethodSearchItem as PaymentMethodOption, reviewConfirmConfig: PXReviewConfirmConfiguration(), userLogged: true)
    }

    func testIsPaymentMethodSelectedCard() {

        self.instance!.amountHelper.paymentData.paymentMethod = MockBuilder.buildPaymentMethod("rapipago", name: "rapipago", paymentTypeId: PXPaymentTypes.TICKET.rawValue)
        XCTAssertFalse(self.instance!.isPaymentMethodSelectedCard())

        self.instance!.amountHelper.paymentData.paymentMethod = MockBuilder.buildPaymentMethod("visa", name: "visa", paymentTypeId: PXPaymentTypes.CREDIT_CARD.rawValue)
        XCTAssertTrue(self.instance!.isPaymentMethodSelectedCard())

        self.instance!.amountHelper.paymentData.paymentMethod = MockBuilder.buildPaymentMethod("debmaster", name: "master", paymentTypeId: PXPaymentTypes.DEBIT_CARD.rawValue)
        XCTAssertTrue(self.instance!.isPaymentMethodSelectedCard())
    }

    func testIsPaymentMethodSelected() {

        self.instance!.amountHelper.paymentData.paymentMethod = MockBuilder.buildPaymentMethod("rapipago", name: "rapipago", paymentTypeId: PXPaymentTypes.TICKET.rawValue)

        XCTAssertTrue(self.instance!.isPaymentMethodSelected())

        self.instance!.amountHelper.paymentData.paymentMethod = nil

        XCTAssertFalse(self.instance!.isPaymentMethodSelected())

    }

    func testGetTotalAmount() {
        let paymentMethodCreditCard = MockBuilder.buildPaymentMethod("master", name: "master", paymentTypeId: PXPaymentTypes.CREDIT_CARD.rawValue)
        self.instance!.amountHelper.paymentData.paymentMethod = paymentMethodCreditCard
        self.instance!.amountHelper.paymentData.payerCost = MockBuilder.buildPayerCost()
        self.instance!.amountHelper.paymentData.payerCost!.totalAmount = 10
        var totalAmount = self.instance!.getTotalAmount()
        XCTAssertEqual(totalAmount, self.instance!.amountHelper.paymentData.payerCost!.totalAmount)

        self.instance!.amountHelper.paymentData.payerCost = nil
        totalAmount = self.instance!.getTotalAmount()
        XCTAssertEqual(totalAmount, instance?.amountHelper.amountToPay)

        //Amount with discount
        self.instanceWithCoupon?.amountHelper.paymentData.payerCost = nil
        XCTAssertEqual(self.instanceWithCoupon?.getTotalAmount(), instanceWithCoupon?.amountHelper.amountToPay)
    }

    func testShouldDisplayNoRate() {

        // No payerCost loaded
        XCTAssertFalse(self.instance!.shouldDisplayNoRate())

        // PayerCost with installmentRate
        let payerCost = MockBuilder.buildPayerCost()
        payerCost.installmentRate = 10.0
        self.instance!.amountHelper.paymentData.payerCost = payerCost
        XCTAssertFalse(self.instance!.shouldDisplayNoRate())

        // PayerCost with no installmentRate but one installment
        let payerCostOneInstallment = MockBuilder.buildPayerCost()
        payerCostOneInstallment.installmentRate = 0.0
        payerCostOneInstallment.installments = 1
        self.instance!.amountHelper.paymentData.payerCost = payerCostOneInstallment
        XCTAssertFalse(self.instance!.shouldDisplayNoRate())

        // PayerCost with no installmentRate and few installments
        let payerCostWithNoRate = MockBuilder.buildPayerCost()
        payerCostWithNoRate.installmentRate = 0.0
        payerCostWithNoRate.installments = 6
        self.instance!.amountHelper.paymentData.payerCost = payerCostWithNoRate
        XCTAssertTrue(self.instance!.shouldDisplayNoRate())
    }

    func testCleanPaymentData() {
        XCTAssertEqual(self.instanceWithCoupon!.amountHelper.paymentData.paymentMethod!.id, "visa")
        XCTAssertEqual(self.instanceWithCoupon!.amountHelper.paymentData.payerCost!.installments, 3)
        XCTAssertEqual(self.instanceWithCoupon!.amountHelper.paymentData.payer!.email, "thisisanem@il.com")
        XCTAssertEqual(self.instanceWithCoupon!.amountHelper.paymentData.discount!.id, "123")
        let newPaymentData = self.instanceWithCoupon!.getClearPaymentData()

        XCTAssertNil(newPaymentData.paymentMethod)
        XCTAssertNil(newPaymentData.payerCost)
        XCTAssertEqual(newPaymentData.payer?.email, "thisisanem@il.com")
        XCTAssertEqual(newPaymentData.discount!.id, "123")
    }

    func getInvalidSummary() -> Summary {
        let preference = PXReviewConfirmConfiguration()
        preference.addSummaryProductDetail(amount: 1000)
        preference.addSummaryProductDetail(amount: 20)
        preference.addSummaryTaxesDetail(amount: 190)
        preference.addSummaryShippingDetail(amount: 100)
        return Summary(details: preference.details)
    }

    func getValidSummary() -> Summary {
        let preference = PXReviewConfirmConfiguration()
        preference.addSummaryProductDetail(amount: 500)
        preference.addSummaryProductDetail(amount: 200)
        preference.addSummaryTaxesDetail(amount: 200)
        preference.addSummaryShippingDetail(amount: 100)
        return Summary(details: preference.details)
    }

    func getValidSummaryWithoutProductDetail() -> Summary {
        let preference = PXReviewConfirmConfiguration()
        preference.addSummaryTaxesDetail(amount: 900)
        preference.addSummaryShippingDetail(amount: 100)
        return Summary(details: preference.details)
    }

}

// MARK: Terms and conditions.
extension PXReviewViewModelTest {

    func testShouldShowTermsAndConditions() {
        instance?.userLogged = false
        XCTAssertTrue(self.instance!.shouldShowTermsAndCondition())
    }

    func testShouldHideTermsAndConditions() {
        instance?.userLogged = true
        XCTAssertFalse(self.instance!.shouldShowTermsAndCondition())
    }
}
