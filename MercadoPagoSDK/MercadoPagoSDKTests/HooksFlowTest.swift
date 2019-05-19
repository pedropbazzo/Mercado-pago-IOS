//
//  HooksFlowTest.swift
//  MercadoPagoSDKTests
//
//  Created by Eden Torres on 11/28/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation
import XCTest
@testable import MercadoPagoSDKV4

class HooksFlowTest: BaseTest {

    var mpCheckout: MercadoPagoCheckout!

    override func setUp() {
        super.setUp()

        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        let firstHook = MockedHookViewController(hookStep: PXHookStep.BEFORE_PAYMENT_METHOD_CONFIG)
        let secondHook = MockedHookViewController(hookStep: PXHookStep.AFTER_PAYMENT_METHOD_CONFIG)
        let thirdHook = MockedHookViewController(hookStep: PXHookStep.BEFORE_PAYMENT)

        mpCheckout.viewModel.hookService.addHookToFlow(hook: firstHook)
        mpCheckout.viewModel.hookService.addHookToFlow(hook: secondHook)
        mpCheckout.viewModel.hookService.addHookToFlow(hook: thirdHook)

    }

    // MARK: Test Account Money with Hooks
    func testNextStep_withCheckoutPreference_accountMoneyWithHooks() {
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

        // 7. Display HOOK 1: After payment type selected
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_HOOK_BEFORE_PAYMENT_METHOD_CONFIG, step)
        mpCheckout.viewModel.continueFrom(hook: .BEFORE_PAYMENT_METHOD_CONFIG)

        // 8. Display HOOK 2: After payment method selected
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_HOOK_AFTER_PAYMENT_METHOD_CONFIG, step)
        mpCheckout.viewModel.continueFrom(hook: .AFTER_PAYMENT_METHOD_CONFIG)

        // 9. Display Review and Confirm y setear Payment data
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_REVIEW_AND_CONFIRM, step)

        let accountMoneyPm = MockBuilder.buildPaymentMethod("account_money", name: "Dinero en cuenta", paymentTypeId: PXPaymentTypes.ACCOUNT_MONEY.rawValue)
        let paymentDataMock = MockBuilder.buildPaymentData(paymentMethod: accountMoneyPm)
        mpCheckout.viewModel.updateCheckoutModel(paymentData: paymentDataMock)

        // 10. Display HOOK 3: BeFore payment
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_HOOK_BEFORE_PAYMENT, step)
        mpCheckout.viewModel.continueFrom(hook: .BEFORE_PAYMENT)

        // 11 . Pagar
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SERVICE_POST_PAYMENT, step)

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

    // MARK: Test Credit Card with Hooks
    func testNextStep_withCheckoutPreference_masterCreditCardWithHooks() {

//        XCTAssertNotNil(mpCheckout.viewModel)
//
//        // 0. Start
//        var step = mpCheckout.viewModel.nextStep()
//        XCTAssertEqual(CheckoutStep.START, step)
//
//        MPCheckoutTestAction.loadGroupsInViewModel(mpCheckout: mpCheckout)
//
//        // 5. Display payment methods (no exclusions) y payment option selected : tarjeta de credito =>
//        step = mpCheckout.viewModel.nextStep()
//        XCTAssertEqual(CheckoutStep.SCREEN_PAYMENT_METHOD_SELECTION, step)
//        MPCheckoutTestAction.selectCreditCardOption(mpCheckout: mpCheckout)
//
//        // 6. Display HOOK 1: After payment type selected
//        step = mpCheckout.viewModel.nextStep()
//        XCTAssertEqual(CheckoutStep.SCREEN_HOOK_BEFORE_PAYMENT_METHOD_CONFIG, step)
//        mpCheckout.viewModel.continueFrom(hook: .BEFORE_PAYMENT_METHOD_CONFIG)
//        XCTAssertEqual(PXCheckoutStore.sharedInstance.getPaymentOptionSelected()?.getId(), "credit_card")
//
//        // 7. Display Form Tarjeta
//        step = mpCheckout.viewModel.nextStep()
//        XCTAssertEqual(CheckoutStep.SCREEN_CARD_FORM, step)
//
//        // Simular paymentMethod completo
//        let paymentMethodMaster = MockBuilder.buildPaymentMethod("master")
//        // Se necesita identification input
//        paymentMethodMaster.additionalInfoNeeded = ["cardholder_identification_number"]
//        mpCheckout.viewModel.paymentData.paymentMethod = paymentMethodMaster
//
//        let cardToken = MockBuilder.buildCardToken()
//        mpCheckout.viewModel.cardToken = cardToken
//
//        // 8. Buscar Identification
//        step = mpCheckout.viewModel.nextStep()
//        XCTAssertEqual(CheckoutStep.SERVICE_GET_IDENTIFICATION_TYPES, step)
//        mpCheckout.viewModel.identificationTypes = MockBuilder.buildIdentificationTypes()
//
//        // 9. Identification
//        step = mpCheckout.viewModel.nextStep()
//        XCTAssertEqual(CheckoutStep.SCREEN_IDENTIFICATION, step)
//
//        // Simular identificacion completa
//        let identificationMock = MockBuilder.buildIdentification()
//        mpCheckout.viewModel.updateCheckoutModel(identification: identificationMock)
//
//        // 10. Crear token
//        step = mpCheckout.viewModel.nextStep()
//        XCTAssertEqual(CheckoutStep.SERVICE_CREATE_CARD_TOKEN, step)
//
//        // Simular token completo
//        let mockToken = MockBuilder.buildToken()
//        mpCheckout.viewModel.updateCheckoutModel(token: mockToken)
//
//        // 11 . Get Issuers
//        step = mpCheckout.viewModel.nextStep()
//        XCTAssertEqual(CheckoutStep.SERVICE_GET_ISSUERS, step)
//
//        // Simular issuers
//        let onlyIssuerAvailable = MockBuilder.buildIssuer()
//        mpCheckout.viewModel.issuers = [onlyIssuerAvailable]
//        mpCheckout.viewModel.updateCheckoutModel(issuer: onlyIssuerAvailable)
//
//        // 12. Un solo banco disponible => Payer Costs
//        step = mpCheckout.viewModel.nextStep()
//        XCTAssertEqual(CheckoutStep.SERVICE_GET_PAYER_COSTS, step)
//        mpCheckout.viewModel.payerCosts = MockBuilder.buildInstallment().payerCosts
//
//        // 13. Pantalla cuotas
//        step = mpCheckout.viewModel.nextStep()
//        XCTAssertEqual(CheckoutStep.SCREEN_PAYER_COST, step)
//
//        //Simular cuotas seleccionadas
//        mpCheckout.viewModel.paymentData.payerCost = MockBuilder.buildPayerCost()
//
//        // 14. Display HOOK 2: After payment method selected
//        step = mpCheckout.viewModel.nextStep()
//        XCTAssertEqual(CheckoutStep.SCREEN_HOOK_AFTER_PAYMENT_METHOD_CONFIG, step)
//        mpCheckout.viewModel.continueFrom(hook: .AFTER_PAYMENT_METHOD_CONFIG)
//
//        // 15. RyC
//        step = mpCheckout.viewModel.nextStep()
//        XCTAssertEqual(CheckoutStep.SCREEN_REVIEW_AND_CONFIRM, step)
//        let paymentDataMock = MockBuilder.buildPaymentData(paymentMethod: paymentMethodMaster)
//        paymentDataMock.issuer = MockBuilder.buildIssuer()
//        paymentDataMock.payerCost = MockBuilder.buildPayerCost()
//        paymentDataMock.token = MockBuilder.buildToken()
//        mpCheckout.viewModel.updateCheckoutModel(paymentData: paymentDataMock)
//
//        // 16. Display HOOK 3: Before payment
//        step = mpCheckout.viewModel.nextStep()
//        XCTAssertEqual(CheckoutStep.SCREEN_HOOK_BEFORE_PAYMENT, step)
//        mpCheckout.viewModel.continueFrom(hook: .BEFORE_PAYMENT)
//
//        // 17. Simular pago
//        step = mpCheckout.viewModel.nextStep()
//        XCTAssertEqual(CheckoutStep.SERVICE_POST_PAYMENT, step)
//
//        // 18. Simular pago completo => Congrats
//        let paymentMock = MockBuilder.buildPayment("master")
//        mpCheckout.viewModel.updateCheckoutModel(payment: paymentMock)
//        mpCheckout.viewModel.paymentResult = MockBuilder.buildPaymentResult()
//
//        step = mpCheckout.viewModel.nextStep()
//        XCTAssertEqual(CheckoutStep.SCREEN_PAYMENT_RESULT, step)
//
//        // 19. Finish
//        step = mpCheckout.viewModel.nextStep()
//        XCTAssertEqual(CheckoutStep.ACTION_FINISH, step)
//
//        // Ejecutar finish
//        mpCheckout.executeNextStep()

    }

    // MARK: Test Customer Cards with Hooks
    func testNextStep_withCustomerCard_WithHooks() {
        // Set access_token

        XCTAssertNotNil(mpCheckout.viewModel)

        // 0. Start
        var step = mpCheckout.viewModel.nextStep()

        XCTAssertEqual(CheckoutStep.START, step)
        mpCheckout.viewModel.initFlow?.finishFlow()

        // 1. Search Preference
        step = mpCheckout.viewModel.nextStep()
        MPCheckoutTestAction.loadGroupsInViewModel(mpCheckout: mpCheckout)

        // Simular api call a grupos
        let customerCardOption = MockBuilder.buildCustomerPaymentMethod("customerCardId", paymentMethodId: "visa")
        let creditCardOption = MockBuilder.buildPaymentMethodSearchItem("credit_card", type: PXPaymentMethodSearchItemType.PAYMENT_TYPE)
        let paymentMethodVisa = MockBuilder.buildPaymentMethod("visa")
        let paymentMethodSearchMock = MockBuilder.buildPaymentMethodSearch(groups: [creditCardOption], paymentMethods: [paymentMethodVisa], customOptions: [customerCardOption])
        mpCheckout.viewModel.updateCheckoutModel(paymentMethodSearch: paymentMethodSearchMock)

        // 5. Display payment methods (no exclusions) y payment option selected : customer card visa
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYMENT_METHOD_SELECTION, step)
        mpCheckout.viewModel.updateCheckoutModel(paymentOptionSelected: customerCardOption as! PaymentMethodOption)

        // 6. Display HOOK 1: After payment type selected
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_HOOK_BEFORE_PAYMENT_METHOD_CONFIG, step)
        mpCheckout.viewModel.continueFrom(hook: .BEFORE_PAYMENT_METHOD_CONFIG)

        // 7.  Search Cuotas
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SERVICE_GET_PAYER_COSTS, step)
        mpCheckout.viewModel.payerCosts = MockBuilder.buildInstallment().payerCosts

        // 8. Mostrar cuotas
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYER_COST, step)

        //Simular cuotas seleccionadas
        mpCheckout.viewModel.paymentData.payerCost = MockBuilder.buildPayerCost()

        // 9. Mostrar SecCode (incluye creación de token)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_SECURITY_CODE, step)
        let token = MockBuilder.buildToken()
        mpCheckout.viewModel.updateCheckoutModel(token: token)

        // 10. Display HOOK 2: After payment method selected
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_HOOK_AFTER_PAYMENT_METHOD_CONFIG, step)
        mpCheckout.viewModel.continueFrom(hook: .AFTER_PAYMENT_METHOD_CONFIG)

        // 11. RyC
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_REVIEW_AND_CONFIRM, step)

        // Simular pago
        let visaPaymentMethod = MockBuilder.buildPaymentMethod("visa")
        let paymentDataMock = MockBuilder.buildPaymentData(paymentMethod: visaPaymentMethod)
        paymentDataMock.issuer = MockBuilder.buildIssuer()
        paymentDataMock.payerCost = MockBuilder.buildPayerCost()
        paymentDataMock.token = MockBuilder.buildToken()
        mpCheckout.viewModel.updateCheckoutModel(paymentData: paymentDataMock)

        // 12. Display HOOK 3: BeFore payment
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_HOOK_BEFORE_PAYMENT, step)
        mpCheckout.viewModel.continueFrom(hook: .BEFORE_PAYMENT)

        // 13. Post Payment
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SERVICE_POST_PAYMENT, step)

        // 14. Simular pago completo => Congrats
        let paymentMock = MockBuilder.buildPayment("visa")
        mpCheckout.viewModel.updateCheckoutModel(payment: paymentMock)
        mpCheckout.viewModel.paymentResult = MockBuilder.buildPaymentResult()

        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYMENT_RESULT, step)

        // 15. Finish
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.ACTION_FINISH, step)

        // Ejecutar finish
        mpCheckout.executeNextStep()
    }

    // MARK: Test Account with Hooks and no discount
    func testNextStep_withCheckoutPreference_accountMoney_noDiscountWithHooks() {

        // Deshabilitar descuentos
//        flowPreference.disableDiscount()
//        MercadoPagoCheckout.setFlowPreference(flowPreference)
        XCTAssertNotNil(mpCheckout.viewModel)

        // 0. Start
        var step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.START, step)
        mpCheckout.viewModel.initFlow?.finishFlow()

        MPCheckoutTestAction.loadGroupsInViewModel(mpCheckout: mpCheckout)

        // 4. Display payment methods (no exclusions) y payment option selected : account_money
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYMENT_METHOD_SELECTION, step)
        MPCheckoutTestAction.selectAccountMoney(mpCheckout: mpCheckout)

        // 5. Display HOOK 1: After payment type selected
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_HOOK_BEFORE_PAYMENT_METHOD_CONFIG, step)
        mpCheckout.viewModel.continueFrom(hook: .BEFORE_PAYMENT_METHOD_CONFIG)

        // 6. Display HOOK 2: After payment method selected
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_HOOK_AFTER_PAYMENT_METHOD_CONFIG, step)
        mpCheckout.viewModel.continueFrom(hook: .AFTER_PAYMENT_METHOD_CONFIG)

        // 7. Display RyC y simular paymentData
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_REVIEW_AND_CONFIRM, step)
        let accountMoneyPm = MockBuilder.buildPaymentMethod("account_money", name: "Dinero en cuenta", paymentTypeId: PXPaymentTypes.ACCOUNT_MONEY.rawValue)
        let paymentDataMock = MockBuilder.buildPaymentData(paymentMethod: accountMoneyPm)
        mpCheckout.viewModel.updateCheckoutModel(paymentData: paymentDataMock)

        // 8. Display HOOK 3: Before payment
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_HOOK_BEFORE_PAYMENT, step)
        mpCheckout.viewModel.continueFrom(hook: .BEFORE_PAYMENT)

        // 9. Pagar
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SERVICE_POST_PAYMENT, step)

        // 10. Simular Pago realizado y se muestra congrats
        let paymentMock = MockBuilder.buildPayment("account_money")
        mpCheckout.viewModel.updateCheckoutModel(payment: paymentMock)
        mpCheckout.viewModel.paymentResult = MockBuilder.buildPaymentResult()

        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYMENT_RESULT, step)

        step = mpCheckout.viewModel.nextStep()

        // 11. Finish
        XCTAssertEqual(CheckoutStep.ACTION_FINISH, step)
    }

    // MARK: Test ESC Flow With CAP Error in Payment with Hooks
    func testEntireFlow_WithCustomerCard_WithESErrorInPayment_WithHooks() {

        mpCheckout.viewModel.mpESCManager = MercadoPagoESCImplementationTest(escEnable: true)

        XCTAssertNotNil(mpCheckout.viewModel)

        // 0. Start
        var step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.START, step)
        mpCheckout.viewModel.initFlow?.finishFlow()

        MPCheckoutTestAction.loadGroupsInViewModel(mpCheckout: mpCheckout)

        // Simular api call a grupos
        var customerCardOption = MockBuilder.buildCustomerPaymentMethodWithESC(paymentMethodId: "visa")
        let creditCardOption = MockBuilder.buildPaymentMethodSearchItem("credit_card", type: PXPaymentMethodSearchItemType.PAYMENT_TYPE)
        let paymentMethodVisa = MockBuilder.buildPaymentMethod("visa")
        let paymentMethodSearchMock = MockBuilder.buildPaymentMethodSearch(groups: [creditCardOption], paymentMethods: [paymentMethodVisa], customOptions: [customerCardOption])
        mpCheckout.viewModel.updateCheckoutModel(paymentMethodSearch: paymentMethodSearchMock)

        // 5. Display payment methods (no exclusions) y payment option selected : customer card visa
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYMENT_METHOD_SELECTION, step)
        mpCheckout.viewModel.updateCheckoutModel(paymentOptionSelected: customerCardOption as! PaymentMethodOption)

        // 6. Display HOOK 1: After payment type selected
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_HOOK_BEFORE_PAYMENT_METHOD_CONFIG, step)
        mpCheckout.viewModel.continueFrom(hook: .BEFORE_PAYMENT_METHOD_CONFIG)

        // 7. Display Cuotas
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SERVICE_GET_PAYER_COSTS, step)
        mpCheckout.viewModel.payerCosts = MockBuilder.buildInstallment().payerCosts

        // 8. Mostrar cuotas
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYER_COST, step)

        // Simular cuotas seleccionadas
        mpCheckout.viewModel.paymentData.payerCost = MockBuilder.buildPayerCost()

        // 9. Creacion de token (No pasa por security code)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SERVICE_CREATE_CARD_TOKEN, step)
        var token = MockBuilder.buildToken(withESC: true)
        mpCheckout.viewModel.updateCheckoutModel(token: token)

        // 10. Display HOOK 2: After payment method selected
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_HOOK_AFTER_PAYMENT_METHOD_CONFIG, step)
        mpCheckout.viewModel.continueFrom(hook: .AFTER_PAYMENT_METHOD_CONFIG)

        // 11. RyC
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_REVIEW_AND_CONFIRM, step)

        // Simular pago
        let visaPaymentMethod = MockBuilder.buildPaymentMethod("visa")
        let paymentDataMock = MockBuilder.buildPaymentData(paymentMethod: visaPaymentMethod)
        paymentDataMock.issuer = MockBuilder.buildIssuer()
        paymentDataMock.payerCost = MockBuilder.buildPayerCost()
        paymentDataMock.token = MockBuilder.buildToken(withESC: true)
        mpCheckout.viewModel.updateCheckoutModel(paymentData: paymentDataMock)

        // 12. Display HOOK 3: Before payment
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_HOOK_BEFORE_PAYMENT, step)
        mpCheckout.viewModel.continueFrom(hook: .BEFORE_PAYMENT)

        // 13. Post Payment
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SERVICE_POST_PAYMENT, step)

        // 14. Simular pago error al momento de pago
        mpCheckout.viewModel.prepareForInvalidPaymentWithESC()
        customerCardOption = MockBuilder.buildCustomerPaymentMethod("customerCardId", paymentMethodId: "visa")
        mpCheckout.viewModel.paymentOptionSelected = customerCardOption as? PaymentMethodOption

        // 15. Mostrar SecCode (incluye creación de token)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_SECURITY_CODE, step)
        token = MockBuilder.buildToken(withESC: true)
        mpCheckout.viewModel.updateCheckoutModel(token: token)

        // Simular pago
        paymentDataMock.issuer = MockBuilder.buildIssuer()
        paymentDataMock.payerCost = MockBuilder.buildPayerCost()
        paymentDataMock.token = MockBuilder.buildToken(withESC: true)
        mpCheckout.viewModel.updateCheckoutModel(paymentData: paymentDataMock)

        // 16. Post Payment
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SERVICE_POST_PAYMENT, step)

        // 17. Simular pago completo => Congrats
        let paymentMock = MockBuilder.buildPayment("visa")
        mpCheckout.viewModel.updateCheckoutModel(payment: paymentMock)
        mpCheckout.viewModel.paymentResult = MockBuilder.buildPaymentResult(withESC: true)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYMENT_RESULT, step)
        XCTAssert(mpCheckout.viewModel.saveOrDeleteESC())

        // 18. Finish
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.ACTION_FINISH, step)

        // Ejecutar finish
        mpCheckout.executeNextStep()
    }

    func testNextStep_withCheckoutPreference_ticketWithHooks() {
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

        // 6. Payment option selected : ticket
        MPCheckoutTestAction.selectTicket(mpCheckout: mpCheckout)

        // 7. Display HOOK 1: After payment type selected
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_HOOK_BEFORE_PAYMENT_METHOD_CONFIG, step)
        mpCheckout.viewModel.continueFrom(hook: .BEFORE_PAYMENT_METHOD_CONFIG)

        // 8. Display HOOK 2: After payment method selected
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_HOOK_AFTER_PAYMENT_METHOD_CONFIG, step)
        mpCheckout.viewModel.continueFrom(hook: .AFTER_PAYMENT_METHOD_CONFIG)

        // 9. Display Review and Confirm y setear Payment data
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_REVIEW_AND_CONFIRM, step)

        let accountMoneyPm = MockBuilder.buildPaymentMethod("ticket", name: "Ticket", paymentTypeId: PXPaymentTypes.TICKET.rawValue)
        let paymentDataMock = MockBuilder.buildPaymentData(paymentMethod: accountMoneyPm)
        mpCheckout.viewModel.updateCheckoutModel(paymentData: paymentDataMock)

        // 10. Display HOOK 3: BeFore payment
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_HOOK_BEFORE_PAYMENT, step)
        mpCheckout.viewModel.continueFrom(hook: .BEFORE_PAYMENT)

        // 11 . Pagar
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SERVICE_POST_PAYMENT, step)

        // 12. Simular Pago realizado y se muestra congrats
        let paymentMock = MockBuilder.buildPayment("ticket")
        mpCheckout.viewModel.updateCheckoutModel(payment: paymentMock)
        mpCheckout.viewModel.paymentResult = MockBuilder.buildPaymentResult()
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYMENT_RESULT, step)

        // 13. Finish
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.ACTION_FINISH, step)
    }

    // MARK: Test Credit Card with Hooks, Hook 1 and 3 disable
    func testNextStep_withCheckoutPreference_masterCreditCardWithHooks_Hook1and3Disable() {

        let firstHook = MockedHookViewController(hookStep: PXHookStep.BEFORE_PAYMENT_METHOD_CONFIG, shouldSkipHook: true)
        let secondHook = MockedHookViewController(hookStep: PXHookStep.AFTER_PAYMENT_METHOD_CONFIG)
        let thirdHook = MockedHookViewController(hookStep: PXHookStep.BEFORE_PAYMENT, shouldSkipHook: true)

        mpCheckout.viewModel.hookService = HookService()

        mpCheckout.viewModel.hookService.addHookToFlow(hook: firstHook)
        mpCheckout.viewModel.hookService.addHookToFlow(hook: secondHook)
        mpCheckout.viewModel.hookService.addHookToFlow(hook: thirdHook)

        // Set access_token
        XCTAssertNotNil(mpCheckout.viewModel)

        // 0. Start
        var step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.START, step)
        mpCheckout.viewModel.initFlow?.finishFlow()

        MPCheckoutTestAction.loadGroupsInViewModel(mpCheckout: mpCheckout)

        // 5. Display payment methods (no exclusions) y payment option selected : tarjeta de credito =>
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYMENT_METHOD_SELECTION, step)
        MPCheckoutTestAction.selectCreditCardOption(mpCheckout: mpCheckout)

        // 6. Display Form Tarjeta
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_CARD_FORM, step)

        // Simular paymentMethod completo
        let paymentMethodMaster = MockBuilder.buildPaymentMethod("master")
        // Se necesita identification input
        paymentMethodMaster.additionalInfoNeeded = ["cardholder_identification_number"]
        mpCheckout.viewModel.paymentData.paymentMethod = paymentMethodMaster

        let cardToken = MockBuilder.buildCardToken()
        cardToken.cardholder?.identification?.number = ""
        mpCheckout.viewModel.cardToken = cardToken

        // 7. Buscar Identification
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SERVICE_GET_IDENTIFICATION_TYPES, step)
        mpCheckout.viewModel.identificationTypes = MockBuilder.buildIdentificationTypes()

        // 8. Identification
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_IDENTIFICATION, step)

        // Simular identificacion completa
        let identificationMock = MockBuilder.buildIdentification()
        mpCheckout.viewModel.updateCheckoutModel(identification: identificationMock)

        // 9. Crear token
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SERVICE_CREATE_CARD_TOKEN, step)

        // Simular token completo
        let mockToken = MockBuilder.buildToken()
        mpCheckout.viewModel.updateCheckoutModel(token: mockToken)

        // 10 . Get Issuers
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SERVICE_GET_ISSUERS, step)

        // Simular issuers
        let onlyIssuerAvailable = MockBuilder.buildIssuer()
        mpCheckout.viewModel.issuers = [onlyIssuerAvailable]
        mpCheckout.viewModel.updateCheckoutModel(issuer: onlyIssuerAvailable)

        // 11. Un solo banco disponible => Payer Costs
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SERVICE_GET_PAYER_COSTS, step)
        mpCheckout.viewModel.payerCosts = MockBuilder.buildInstallment().payerCosts

        // 12. Pantalla cuotas
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYER_COST, step)

        //Simular cuotas seleccionadas
        mpCheckout.viewModel.paymentData.payerCost = MockBuilder.buildPayerCost()

        // 13. Display HOOK 2: After payment method selected
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_HOOK_AFTER_PAYMENT_METHOD_CONFIG, step)
        mpCheckout.viewModel.continueFrom(hook: .AFTER_PAYMENT_METHOD_CONFIG)

        // 14. RyC
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_REVIEW_AND_CONFIRM, step)
        let paymentDataMock = MockBuilder.buildPaymentData(paymentMethod: paymentMethodMaster)
        paymentDataMock.issuer = MockBuilder.buildIssuer()
        paymentDataMock.payerCost = MockBuilder.buildPayerCost()
        paymentDataMock.token = MockBuilder.buildToken()
        mpCheckout.viewModel.updateCheckoutModel(paymentData: paymentDataMock)

        // 15. Simular pago
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SERVICE_POST_PAYMENT, step)

        // 16. Simular pago completo => Congrats
        let paymentMock = MockBuilder.buildPayment("master")
        mpCheckout.viewModel.updateCheckoutModel(payment: paymentMock)
        mpCheckout.viewModel.paymentResult = MockBuilder.buildPaymentResult()

        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYMENT_RESULT, step)

        // 17. Finish
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.ACTION_FINISH, step)

        // Ejecutar finish
        mpCheckout.executeNextStep()
    }

    // MARK: Test Account Money with Hooks with Hook Store
    func testNextStep_withCheckoutPreference_accountMoneyWithHooks_andHookStore() {

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

        // 7. Display HOOK 1: After payment type selected
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_HOOK_BEFORE_PAYMENT_METHOD_CONFIG, step)
        mpCheckout.viewModel.continueFrom(hook: .BEFORE_PAYMENT_METHOD_CONFIG)
        XCTAssertEqual(PXCheckoutStore.sharedInstance.paymentData.paymentMethod?.id, "account_money")

        // 8. Display HOOK 2: After payment method selected
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_HOOK_AFTER_PAYMENT_METHOD_CONFIG, step)
        mpCheckout.viewModel.continueFrom(hook: .AFTER_PAYMENT_METHOD_CONFIG)

        // 9. Display Review and Confirm y setear Payment data
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_REVIEW_AND_CONFIRM, step)

        let accountMoneyPm = MockBuilder.buildPaymentMethod("account_money", name: "Dinero en cuenta", paymentTypeId: PXPaymentTypes.ACCOUNT_MONEY.rawValue)
        let paymentDataMock = MockBuilder.buildPaymentData(paymentMethod: accountMoneyPm)
        mpCheckout.viewModel.updateCheckoutModel(paymentData: paymentDataMock)

        // 10. Display HOOK 3: BeFore payment
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_HOOK_BEFORE_PAYMENT, step)
        mpCheckout.viewModel.continueFrom(hook: .BEFORE_PAYMENT)
        XCTAssertEqual(PXCheckoutStore.sharedInstance.getPaymentData().getPaymentMethod()?.id, "account_money")

        // 11 . Pagar
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SERVICE_POST_PAYMENT, step)

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
