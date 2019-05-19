//
//  PaymentPluginFlowTest.swift
//  MercadoPagoSDKTests
//
//  Created by Eden Torres on 1/9/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
import XCTest

@testable import MercadoPagoSDKV4

class PaymentPluginFlowTest: BaseTest {

    var mpCheckout: MercadoPagoCheckout!
    var paymentPlugin: PXPaymentProcessor!
    var mockPaymentMethodPlugin1: PXPaymentMethodPlugin!
    var mockPaymentMethodPlugin2: PXPaymentMethodPlugin!

    override func setUp() {
        super.setUp()

        paymentPlugin = MockBuilder.buildPaymentPlugin()

        let paymentConfiguration = PXPaymentConfiguration(paymentProcessor: paymentPlugin)

        // Configure payment methods plugin
        let paymentMethodConfigPlugin = MockConfigPaymentMethodPlugin(shouldSkip: false)

        mockPaymentMethodPlugin1 = MockBuilder.buildPaymentMethodPlugin(id: "plugin1", name: "Plugin 1", configPaymentMethodPlugin: nil)
        mockPaymentMethodPlugin2 = MockBuilder.buildPaymentMethodPlugin(id: "plugin2", name: "Plugin 2", configPaymentMethodPlugin: paymentMethodConfigPlugin)

        paymentConfiguration.addPaymentMethodPlugin(plugin: mockPaymentMethodPlugin1)
        paymentConfiguration.addPaymentMethodPlugin(plugin: mockPaymentMethodPlugin2)

        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        self.mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

    }

    func initPaymentMethodsPlugins() {
        self.mpCheckout.viewModel.initFlow?.model.paymentMethodPluginDidLoaded()
    }

    // MARK: Tests flow with Payment Method Plugins

    func testNextStep_withCheckoutPreference_pluginAndPaymentPlugin() {
        // Plugin 1 has no payment method config plugin

        // Set access_token
        XCTAssertNotNil(mpCheckout.viewModel)

        // 0. Start
        var step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.START, step)
        mpCheckout.viewModel.initFlow?.finishFlow()

        MPCheckoutTestAction.loadGroupsInViewModel(mpCheckout: mpCheckout)

        // 5. Display payment methods (no exclusions)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYMENT_METHOD_SELECTION, step)

        // 6. Payment option selected : plugin 1
        mpCheckout.viewModel.updateCheckoutModel(paymentOptionSelected: mockPaymentMethodPlugin1 as PaymentMethodOption)

        // 9. Display Review and Confirm y setear Payment data
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_REVIEW_AND_CONFIRM, step)

        let accountMoneyPm = MockBuilder.buildPaymentMethod("plugin1", name: "Dinero en cuenta", paymentTypeId: PXPaymentTypes.ACCOUNT_MONEY.rawValue)
        let paymentDataMock = MockBuilder.buildPaymentData(paymentMethod: accountMoneyPm)
        mpCheckout.viewModel.updateCheckoutModel(paymentData: paymentDataMock)

        // 11 . Pagar
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SERVICE_POST_PAYMENT, step)

        // 12. Simular Pago realizado y se muestra congrats
        let paymentMock = MockBuilder.buildPayment("plugin1")
        mpCheckout.viewModel.updateCheckoutModel(payment: paymentMock)
        mpCheckout.viewModel.paymentResult = MockBuilder.buildPaymentResult()
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYMENT_RESULT, step)

        // 13. Finish
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.ACTION_FINISH, step)
    }

    func testNextStep_withCheckoutPreference_accountMoneyWithPaymentPlugin() {
        // Set access_token
        XCTAssertNotNil(mpCheckout.viewModel)

        // 0. Start
        var step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.START, step)
        mpCheckout.viewModel.initFlow?.finishFlow()

        MPCheckoutTestAction.loadGroupsInViewModel(mpCheckout: mpCheckout)

        // 5. Display payment methods (no exclusions)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYMENT_METHOD_SELECTION, step)

        // 6. Payment option selected : account_money
        MPCheckoutTestAction.selectAccountMoney(mpCheckout: mpCheckout)

        // 9. Display Review and Confirm y setear Payment data
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_REVIEW_AND_CONFIRM, step)

        let accountMoneyPm = MockBuilder.buildPaymentMethod("account_money", name: "Dinero en cuenta", paymentTypeId: PXPaymentTypes.ACCOUNT_MONEY.rawValue)
        let paymentDataMock = MockBuilder.buildPaymentData(paymentMethod: accountMoneyPm)
        mpCheckout.viewModel.updateCheckoutModel(paymentData: paymentDataMock)

        // 12. Simular Pago realizado y se muestra congrats
        let paymentMock = MockBuilder.buildPayment("account_money")
        mpCheckout.viewModel.updateCheckoutModel(payment: paymentMock)
        mpCheckout.viewModel.paymentResult = MockBuilder.buildPaymentResult()
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYMENT_RESULT, step)

        // 13. Finish
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.ACTION_FINISH, step)
    }
}
