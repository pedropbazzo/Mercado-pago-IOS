//
//  MercadoPagoCheckoutViewModelTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 3/9/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit
import XCTest
@testable import MercadoPagoSDKV4

class MercadoPagoCheckoutViewModelTest: BaseTest {

    func testNextStep_withCheckoutPreference_accountMoney() {

        // Set access_token
        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        let mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        XCTAssertNotNil(mpCheckout.viewModel)

        // 0. Start
        var step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.START, step)
        mpCheckout.viewModel.initFlow?.finishFlow()

        MPCheckoutTestAction.loadGroupsInViewModel(mpCheckout: mpCheckout)

        // 5. Display payment methods (no exclusions)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYMENT_METHOD_SELECTION, step)

        // 6. Payment option selected : account_money => RyC
        MPCheckoutTestAction.selectAccountMoney(mpCheckout: mpCheckout)

        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_REVIEW_AND_CONFIRM, step)

        // 7 . Simular paymentData y pagar
        let accountMoneyPm = MockBuilder.buildPaymentMethod("account_money", name: "Dinero en cuenta", paymentTypeId: PXPaymentTypes.ACCOUNT_MONEY.rawValue)
        let paymentDataMock = MockBuilder.buildPaymentData(paymentMethod: accountMoneyPm)
        mpCheckout.viewModel.updateCheckoutModel(paymentData: paymentDataMock)

        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SERVICE_POST_PAYMENT, step)

        // 8. Simular Pago realizado y se muestra congrats
        let paymentMock = MockBuilder.buildPayment("account_money")
        mpCheckout.viewModel.updateCheckoutModel(payment: paymentMock)
        mpCheckout.viewModel.paymentResult = MockBuilder.buildPaymentResult()
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYMENT_RESULT, step)

        // 7. Finish
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.ACTION_FINISH, step)

    }

    func testFilterPaymentMethods() {

        // Set access_token
        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        let mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)
        XCTAssertNotNil(mpCheckout.viewModel)

        // 0. Start
        let step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.START, step)
        mpCheckout.viewModel.initFlow?.finishFlow()

        MPCheckoutTestAction.loadGroupsInViewModel(mpCheckout: mpCheckout)
        mpCheckout.viewModel.paymentOptionSelected = mpCheckout.viewModel.search?.paymentMethodSearchItem[0]
        let pmsForSelectionCards = mpCheckout.viewModel.getPaymentMethodsForSelection()
        XCTAssertEqual(pmsForSelectionCards[0].paymentTypeId, "credit_card")
        XCTAssertEqual(pmsForSelectionCards[1].paymentTypeId, "credit_card")
        XCTAssertEqual(pmsForSelectionCards[0].id, "visa")
        XCTAssertEqual(pmsForSelectionCards[1].id, "master")
        XCTAssertEqual(pmsForSelectionCards.count, 2)

        mpCheckout.viewModel.paymentOptionSelected = mpCheckout.viewModel.search?.paymentMethodSearchItem[1]
        let pmsForSelectionOff = mpCheckout.viewModel.getPaymentMethodsForSelection()
        XCTAssertEqual(pmsForSelectionOff[0].paymentTypeId, "off")
        XCTAssertEqual(pmsForSelectionOff[1].paymentTypeId, "off")
        XCTAssertEqual(pmsForSelectionOff[0].id, "ticket")
        XCTAssertEqual(pmsForSelectionOff[1].id, "ticket 2")
        XCTAssertEqual(pmsForSelectionOff.count, 2)
    }

    func testNextStep_withCheckoutPreference_masterCreditCard() {

        // Set access_token
        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        let mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        XCTAssertNotNil(mpCheckout.viewModel)

        // 0. Start
        var step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.START, step)
        mpCheckout.viewModel.initFlow?.finishFlow()

        MPCheckoutTestAction.loadGroupsInViewModel(mpCheckout: mpCheckout)

        // 5. Display payment methods (no exclusions)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYMENT_METHOD_SELECTION, step)

        // 6. Payment option selected : tarjeta de credito => Form Tarjeta
        MPCheckoutTestAction.selectCreditCardOption(mpCheckout: mpCheckout)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_CARD_FORM, step)

        // Simular paymentMethod completo
        let paymentMethodMaster = MockBuilder.buildPaymentMethod("master")
        // Se necesita identification input
        paymentMethodMaster.additionalInfoNeeded = ["cardholder_identification_number"]
        mpCheckout.viewModel.paymentData.paymentMethod = paymentMethodMaster

        let cardToken = MockBuilder.buildCardToken()
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

        // 13. RyC
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_REVIEW_AND_CONFIRM, step)

        // 14. Simular pago
        let paymentDataMock = MockBuilder.buildPaymentData(paymentMethod: paymentMethodMaster)
        paymentDataMock.issuer = MockBuilder.buildIssuer()
        paymentDataMock.payerCost = MockBuilder.buildPayerCost()
        paymentDataMock.token = MockBuilder.buildToken()
        mpCheckout.viewModel.updateCheckoutModel(paymentData: paymentDataMock)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SERVICE_POST_PAYMENT, step)

        // 15. Simular pago completo => Congrats
        let paymentMock = MockBuilder.buildPayment("master")
        mpCheckout.viewModel.updateCheckoutModel(payment: paymentMock)
        mpCheckout.viewModel.paymentResult = MockBuilder.buildPaymentResult()

        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYMENT_RESULT, step)

        // 16. Finish
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.ACTION_FINISH, step)

        // Ejecutar finish
        mpCheckout.executeNextStep()

    }

    func testNextStep_withCustomerCard() {

        // Set access_token

        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        let mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        XCTAssertNotNil(mpCheckout.viewModel)

        // 0. Start
        var step = mpCheckout.viewModel.nextStep()

        XCTAssertEqual(CheckoutStep.START, step)
        mpCheckout.viewModel.initFlow?.finishFlow()

        // 1. Search Preference
        step = mpCheckout.viewModel.nextStep()

        // Simular api call a grupos
        let customerCardOption = MockBuilder.buildCustomerPaymentMethod("customerCardId", paymentMethodId: "visa")
        let creditCardOption = MockBuilder.buildPaymentMethodSearchItem("credit_card", type: PXPaymentMethodSearchItemType.PAYMENT_TYPE)
        let paymentMethodVisa = MockBuilder.buildPaymentMethod("visa")
        let paymentMethodSearchMock = MockBuilder.buildPaymentMethodSearch(groups: [creditCardOption], paymentMethods: [paymentMethodVisa], customOptions: [customerCardOption])
        mpCheckout.viewModel.updateCheckoutModel(paymentMethodSearch: paymentMethodSearchMock)

        // 5. Display payment methods (no exclusions)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYMENT_METHOD_SELECTION, step)

        // 6. Payment option selected : customer card visa => Cuotas
        mpCheckout.viewModel.updateCheckoutModel(paymentOptionSelected: customerCardOption as! PaymentMethodOption)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SERVICE_GET_PAYER_COSTS, step)
        mpCheckout.viewModel.payerCosts = MockBuilder.buildInstallment().payerCosts

        // 7. Mostrar cuotas
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYER_COST, step)

        //Simular cuotas seleccionadas
        mpCheckout.viewModel.paymentData.payerCost = MockBuilder.buildPayerCost()

        // 8. Mostrar SecCode (incluye creación de token)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_SECURITY_CODE, step)
        let token = MockBuilder.buildToken()
        mpCheckout.viewModel.updateCheckoutModel(token: token)

        // 9. RyC
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_REVIEW_AND_CONFIRM, step)

        // Simular pago
        let visaPaymentMethod = MockBuilder.buildPaymentMethod("visa")
        let paymentDataMock = MockBuilder.buildPaymentData(paymentMethod: visaPaymentMethod)
        paymentDataMock.issuer = MockBuilder.buildIssuer()
        paymentDataMock.payerCost = MockBuilder.buildPayerCost()
        paymentDataMock.token = MockBuilder.buildToken()
        mpCheckout.viewModel.updateCheckoutModel(paymentData: paymentDataMock)

        // 8. Post Payment
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SERVICE_POST_PAYMENT, step)

        // 9. Simular pago completo => Congrats
        let paymentMock = MockBuilder.buildPayment("visa")
        mpCheckout.viewModel.updateCheckoutModel(payment: paymentMock)
        mpCheckout.viewModel.paymentResult = MockBuilder.buildPaymentResult()

        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYMENT_RESULT, step)

        // 10. Finish
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.ACTION_FINISH, step)

        // Ejecutar finish
        mpCheckout.executeNextStep()

    }

    /****************************************************/
    /********** ViewModel Builders Tests ****************/
    /****************************************************/

    func testHasError() {
        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        let mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        XCTAssertFalse(mpCheckout.viewModel.hasError())

        let error = MPSDKError()
        MercadoPagoCheckoutViewModel.error = error

        XCTAssertTrue(mpCheckout.viewModel.hasError())

        MercadoPagoCheckoutViewModel.error = nil

    }

    func testPaymentVaultViewModel() {
        let checkoutPreference = MockBuilder.buildCheckoutPreference()
        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: checkoutPreference, paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        let mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        MPCheckoutTestAction.loadGroupsInViewModel(mpCheckout: mpCheckout)

        let paymentVaultVM = mpCheckout.viewModel.paymentVaultViewModel()

        XCTAssertTrue(paymentVaultVM.isKind(of: PaymentVaultViewModel.self))
        XCTAssertEqual(paymentVaultVM.amountHelper.amountToPay, checkoutPreference.getTotalAmount())
        XCTAssertEqual(paymentVaultVM.amountHelper.preference.paymentPreference, checkoutPreference.paymentPreference)

    }

    func testIssuerViewModel() {
        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        let mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        // Simular installments
        let issuer = MockBuilder.buildIssuer()
        mpCheckout.viewModel.issuers = [issuer]
        mpCheckout.viewModel.paymentData.paymentMethod = MockBuilder.buildPaymentMethod("id")

        let issuerVM = mpCheckout.viewModel.issuerViewModel()
        XCTAssertEqual(issuerVM.amountHelper.amountToPay, MockBuilder.buildCheckoutPreference().getTotalAmount())

    }

    func testPayerCostViewModel() {
        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        let mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        let issuer = MockBuilder.buildIssuer()
        mpCheckout.viewModel.issuers = [issuer]
        mpCheckout.viewModel.paymentData.paymentMethod = MockBuilder.buildPaymentMethod("id")

        mpCheckout.viewModel.payerCosts = [MockBuilder.buildPayerCost()]

        let payerCostVM = mpCheckout.viewModel.payerCostViewModel()
        XCTAssertEqual(payerCostVM.amountHelper.amountToPay, MockBuilder.buildCheckoutPreference().getTotalAmount())

    }

    /************************************************************/
    /********** Update View Model Behavior Tests ****************/
    /************************************************************/

    func testUpdateCheckoutModel_paymentMethodSearch() {
        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        let mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        let accountMoneyOption = MockBuilder.buildCustomerPaymentMethod("account_money", paymentMethodId: "account_money")
        let customerCardOption = MockBuilder.buildCustomerPaymentMethod("customerCardId", paymentMethodId: "visa")
        let creditCardOption = MockBuilder.buildPaymentMethodSearchItem("credit_card", type: PXPaymentMethodSearchItemType.PAYMENT_TYPE)
        let paymentMethodVisa = MockBuilder.buildPaymentMethod("visa")
        let paymentMethodAM = MockBuilder.buildPaymentMethod("account_money", paymentTypeId: "account_money")

        let paymentMethodSearchMock = MockBuilder.buildPaymentMethodSearch(groups: [creditCardOption], paymentMethods: [paymentMethodVisa, paymentMethodAM], customOptions: [customerCardOption, accountMoneyOption])

        mpCheckout.viewModel.updateCheckoutModel(paymentMethodSearch: paymentMethodSearchMock)

        XCTAssertNotNil(mpCheckout.viewModel.search)
        XCTAssertEqual(mpCheckout.viewModel.search, paymentMethodSearchMock)
        XCTAssertEqual(mpCheckout.viewModel.availablePaymentMethods!, paymentMethodSearchMock.paymentMethods)
    }

    func testUpdateCheckoutModel_paymentMethods() {
        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        let mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        let paymentMethods = [MockBuilder.buildPaymentMethod("visa"), MockBuilder.buildPaymentMethod("amex")]

        mpCheckout.viewModel.updateCheckoutModel(paymentMethods: paymentMethods, cardToken: nil)

        XCTAssertEqual(mpCheckout.viewModel.paymentData.paymentMethod, paymentMethods[0])
        XCTAssertNil(mpCheckout.viewModel.cardToken)

        let cardToken = MockBuilder.buildCardToken()
        mpCheckout.viewModel.updateCheckoutModel(paymentMethods: paymentMethods, cardToken: cardToken)
        XCTAssertEqual(mpCheckout.viewModel.paymentData.paymentMethod, paymentMethods[0])
        XCTAssertEqual(mpCheckout.viewModel.cardToken, cardToken)

    }

    func testUpdateCheckoutModel_paymentMethodSearchOneOption() {
        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        let mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        let creditCardOption = MockBuilder.buildPaymentMethodSearchItem("credit_card", type: PXPaymentMethodSearchItemType.PAYMENT_TYPE)
        let paymentMethodVisa = MockBuilder.buildPaymentMethod("visa")

        let paymentMethodSearchMock = MockBuilder.buildPaymentMethodSearch(groups: [creditCardOption], paymentMethods: [paymentMethodVisa])

        // Clear payment method plugin
        mpCheckout.viewModel.paymentMethodPluginsToShow = []
        mpCheckout.viewModel.paymentMethodPlugins = []

        mpCheckout.viewModel.updateCheckoutModel(paymentMethodSearch: paymentMethodSearchMock)

        XCTAssertNotNil(mpCheckout.viewModel.search)
        XCTAssertEqual(mpCheckout.viewModel.search, paymentMethodSearchMock)
        XCTAssertEqual(mpCheckout.viewModel.availablePaymentMethods!, paymentMethodSearchMock.paymentMethods)
        XCTAssertNil(mpCheckout.viewModel.customPaymentOptions)

        XCTAssertEqual(mpCheckout.viewModel.paymentOptionSelected!.getId(), creditCardOption.getId())

    }

    func testUpdateCheckoutModel_paymentMethod() {
        let paymentMethod = MockBuilder.buildPaymentMethod("paymentMethodId")
        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        let mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        mpCheckout.viewModel.updateCheckoutModel(paymentMethod: paymentMethod)

        XCTAssertNotNil(mpCheckout.viewModel.paymentData.paymentMethod)
        XCTAssertEqual(mpCheckout.viewModel.paymentData.paymentMethod, paymentMethod)
    }

    func testUpdateCheckoutModel_paymentMethodSearchCustomOption() {
        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        let mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        let accountMoneyOption = MockBuilder.buildCustomerPaymentMethod("account_money", paymentMethodId: "account_money")
        let paymentMethodAM = MockBuilder.buildPaymentMethod("account_money", paymentTypeId: "account_money")

        let paymentMethodSearchMock = MockBuilder.buildPaymentMethodSearch(groups: [], paymentMethods: [paymentMethodAM], customOptions: [accountMoneyOption])

        mpCheckout.viewModel.updateCheckoutModel(paymentMethodSearch: paymentMethodSearchMock)

        XCTAssertNotNil(mpCheckout.viewModel.search)
        XCTAssertEqual(mpCheckout.viewModel.search, paymentMethodSearchMock)
        XCTAssertEqual(mpCheckout.viewModel.availablePaymentMethods!, paymentMethodSearchMock.paymentMethods)
        XCTAssertEqual(mpCheckout.viewModel.paymentOptionSelected!.getId(), accountMoneyOption.getCardId())

    }

    func testUpdateCheckoutModel_paymentData() {
        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        let mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        let paymentMethod = MockBuilder.buildPaymentMethod("visa")
        let paymentData = MockBuilder.buildPaymentData(paymentMethod: paymentMethod)
        mpCheckout.viewModel.updateCheckoutModel(paymentData: paymentData)

        XCTAssertTrue(mpCheckout.viewModel.readyToPay)

        paymentData.paymentMethod = nil
        mpCheckout.viewModel.updateCheckoutModel(paymentData: paymentData)

        XCTAssertNil(mpCheckout.viewModel.paymentOptionSelected)
        XCTAssertNil(mpCheckout.viewModel.search)
        XCTAssertNil(mpCheckout.viewModel.issuers)
        XCTAssertNil(mpCheckout.viewModel.cardToken)
        XCTAssertTrue(mpCheckout.viewModel.rootVC)
        XCTAssertFalse(mpCheckout.viewModel.initWithPaymentData)

    }

    func testHandleCustomerPaymentMethod() {
        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        let mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        MPCheckoutTestAction.loadGroupsInViewModel(mpCheckoutViewModel: mpCheckout.viewModel)

        MPCheckoutTestAction.selectAccountMoney(mpCheckoutViewModel: mpCheckout.viewModel)

        mpCheckout.viewModel.handleCustomerPaymentMethod()

        XCTAssertEqual(mpCheckout.viewModel.paymentData.paymentMethod!.id, "account_money")

        MPCheckoutTestAction.selectCustomerCardOption(mpCheckoutViewModel: mpCheckout.viewModel)

        mpCheckout.viewModel.handleCustomerPaymentMethod()

        XCTAssertEqual(mpCheckout.viewModel.paymentData.paymentMethod!.id, "visa")
    }

    func testResetGroupSelection() {
        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        let mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        MPCheckoutTestAction.loadGroupsInViewModel(mpCheckoutViewModel: mpCheckout.viewModel)

        MPCheckoutTestAction.selectAccountMoney(mpCheckoutViewModel: mpCheckout.viewModel)

        mpCheckout.viewModel.resetGroupSelection()

        XCTAssertNil(mpCheckout.viewModel.paymentOptionSelected)

    }

    func testResetInformation() {
        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        let mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        MPCheckoutTestAction.loadGroupsInViewModel(mpCheckoutViewModel: mpCheckout.viewModel)

        MPCheckoutTestAction.selectAccountMoney(mpCheckoutViewModel: mpCheckout.viewModel)

        mpCheckout.viewModel.resetInformation()

        XCTAssertNil(mpCheckout.viewModel.cardToken)
        XCTAssertNil(mpCheckout.viewModel.issuers)
        XCTAssertNil(mpCheckout.viewModel.payerCosts)
        XCTAssertNil(mpCheckout.viewModel.paymentData.paymentMethod)
        XCTAssertNil(mpCheckout.viewModel.paymentData.issuer)
        XCTAssertNil(mpCheckout.viewModel.paymentData.payerCost)
        XCTAssertNil(mpCheckout.viewModel.paymentData.token)

    }

    func testCleanPaymentResult() {
        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        let mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        mpCheckout.viewModel.cleanPaymentResult()

        XCTAssertNil(mpCheckout.viewModel.payment)
        XCTAssertNil(mpCheckout.viewModel.paymentResult)
        XCTAssertFalse(mpCheckout.viewModel.readyToPay)

    }

    func testPrepareForClone() {
        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        let mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        mpCheckout.viewModel.prepareForClone()

        XCTAssertFalse(mpCheckout.viewModel.isCheckoutComplete())
        XCTAssertNil(mpCheckout.viewModel.payment)
        XCTAssertNil(mpCheckout.viewModel.paymentResult)
        XCTAssertFalse(mpCheckout.viewModel.readyToPay)
    }

    func testPrepareForNewSelection() {
        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        let mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        mpCheckout.viewModel.prepareForNewSelection()

        XCTAssertFalse(mpCheckout.viewModel.isCheckoutComplete())

    }

    func testEntireFlowWithCustomerCardWithESErrorInPaymentAndInTokenCreation() {
        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        let mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)
        mpCheckout.viewModel.mpESCManager = MercadoPagoESCImplementationTest(escEnable: true)

        XCTAssertNotNil(mpCheckout.viewModel)

        // 1. Start
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

        // 5. Display payment methods (no exclusions)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYMENT_METHOD_SELECTION, step)

        // 6. Payment option selected : customer card visa => Cuotas
        mpCheckout.viewModel.updateCheckoutModel(paymentOptionSelected: customerCardOption as! PaymentMethodOption)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SERVICE_GET_PAYER_COSTS, step)
        mpCheckout.viewModel.payerCosts = MockBuilder.buildInstallment().payerCosts

        // 7. Mostrar cuotas
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYER_COST, step)

        // Simular cuotas seleccionadas
        mpCheckout.viewModel.paymentData.payerCost = MockBuilder.buildPayerCost()

        // 8. Creacion de token (No pasa por security code)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SERVICE_CREATE_CARD_TOKEN, step)

        // Simulate error creating token with esc
        customerCardOption = MockBuilder.buildCustomerPaymentMethod("customerCardId", paymentMethodId: "visa")
        mpCheckout.viewModel.paymentOptionSelected = customerCardOption as? PaymentMethodOption

        // 9. Mostrar SecCode (incluye creación de token)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_SECURITY_CODE, step)
        var token = MockBuilder.buildToken(withESC: true)
        mpCheckout.viewModel.updateCheckoutModel(token: token)

        // 10. RyC
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_REVIEW_AND_CONFIRM, step)

        // Simular pago
        let visaPaymentMethod = MockBuilder.buildPaymentMethod("visa")
        let paymentDataMock = MockBuilder.buildPaymentData(paymentMethod: visaPaymentMethod)
        paymentDataMock.issuer = MockBuilder.buildIssuer()
        paymentDataMock.payerCost = MockBuilder.buildPayerCost()
        paymentDataMock.token = MockBuilder.buildToken(withESC: true)
        mpCheckout.viewModel.updateCheckoutModel(paymentData: paymentDataMock)

        // 11. Post Payment
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SERVICE_POST_PAYMENT, step)

        // 12. Simular pago error al momento de pago
        mpCheckout.viewModel.prepareForInvalidPaymentWithESC()

        // 13. Mostrar SecCode (incluye creación de token)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_SECURITY_CODE, step)
        token = MockBuilder.buildToken(withESC: true)
        mpCheckout.viewModel.updateCheckoutModel(token: token)

        // Simular pago
        paymentDataMock.issuer = MockBuilder.buildIssuer()
        paymentDataMock.payerCost = MockBuilder.buildPayerCost()
        paymentDataMock.token = MockBuilder.buildToken(withESC: true)
        mpCheckout.viewModel.updateCheckoutModel(paymentData: paymentDataMock)

        // 14. Post Payment
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SERVICE_POST_PAYMENT, step)

        // 15. Simular pago completo => Congrats
        let paymentMock = MockBuilder.buildPayment("visa")
        mpCheckout.viewModel.updateCheckoutModel(payment: paymentMock)
        mpCheckout.viewModel.paymentResult = MockBuilder.buildPaymentResult(withESC: true)
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.SCREEN_PAYMENT_RESULT, step)
        XCTAssert(mpCheckout.viewModel.saveOrDeleteESC())

        // 16. Finish
        step = mpCheckout.viewModel.nextStep()
        XCTAssertEqual(CheckoutStep.ACTION_FINISH, step)

        // Ejecutar finish
        mpCheckout.executeNextStep()
    }

}
