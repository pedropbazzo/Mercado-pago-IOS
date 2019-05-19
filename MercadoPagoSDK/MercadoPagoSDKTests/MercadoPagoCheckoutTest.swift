//
//  MercadoPagoCheckoutTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 3/17/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import XCTest
@testable import MercadoPagoSDKV4

class MercadoPagoCheckoutTest: BaseTest {

    var mpCheckout: MercadoPagoCheckout?

    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
        // Use v1 urls
        URLConfigs.MP_ENVIROMENT = URLConfigs.MP_PROD_ENV  + "/checkout"
        URLConfigs.API_VERSION = "API_VERSION"
    }

    override func tearDown() {
        super.tearDown()
        self.mpCheckout = nil
    }

    /********************************/
    /***** Init checkout tests ******/
    /********************************/

    func testInit_withCheckoutPreference() {
        let navControllerInstance = UINavigationController()

        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)
        mpCheckout?.start(navigationController: navControllerInstance)
        XCTAssertNotNil(self.mpCheckout!.viewModel)
        XCTAssertNotNil(self.mpCheckout!.viewModel.checkoutPreference)
        XCTAssertFalse(self.mpCheckout!.viewModel.paymentData.isComplete())
        XCTAssertNil(self.mpCheckout!.viewModel.paymentResult)
        XCTAssertEqual(self.mpCheckout!.viewModel.pxNavigationHandler.navigationController, navControllerInstance)
        XCTAssertEqual(mpCheckout?.viewModel.publicKey, "public_key")
        XCTAssertEqual(mpCheckout?.viewModel.privateKey, "acess_token")

    }

    /*******************************************/
    /***** Display view controllers tests ******/
    /*******************************************/

    func testCollectPaymentMethods() {

        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        MPCheckoutTestAction.loadGroupsInViewModel(mpCheckout: self.mpCheckout!)

        self.mpCheckout?.showPaymentMethodsScreen()

        XCTAssertNil(self.mpCheckout?.viewModel.paymentData.paymentMethod)
        XCTAssertNil(self.mpCheckout?.viewModel.paymentData.payerCost)
        XCTAssertNil(self.mpCheckout?.viewModel.paymentData.token)
        XCTAssertNil(self.mpCheckout?.viewModel.paymentData.issuer)
        XCTAssertEqual(self.mpCheckout?.viewModel.pxNavigationHandler.navigationController.viewControllers.count, 1)
        let lastVC = self.mpCheckout!.viewModel.pxNavigationHandler.navigationController.viewControllers[0]
        XCTAssertTrue(lastVC.isKind(of: PaymentVaultViewController.self))
    }

    func testCollectCard() {

        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        self.mpCheckout?.showCardForm()

        XCTAssertNil(self.mpCheckout?.viewModel.paymentData.paymentMethod)
        XCTAssertNil(self.mpCheckout?.viewModel.paymentData.payerCost)
        XCTAssertNil(self.mpCheckout?.viewModel.paymentData.token)
        XCTAssertNil(self.mpCheckout?.viewModel.paymentData.issuer)
        XCTAssertEqual(self.mpCheckout?.viewModel.pxNavigationHandler.navigationController.viewControllers.count, 1)
        let lastVC = self.mpCheckout!.viewModel.pxNavigationHandler.navigationController.viewControllers[0]
        XCTAssertTrue(lastVC.isKind(of: CardFormViewController.self))
    }

    func testCollectIdentification() {
        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        mpCheckout!.viewModel.identificationTypes = MockBuilder.buildIdentificationTypes()
        self.mpCheckout?.showIdentificationScreen()

        XCTAssertNil(self.mpCheckout?.viewModel.paymentData.paymentMethod)
        XCTAssertNil(self.mpCheckout?.viewModel.paymentData.payerCost)
        XCTAssertNil(self.mpCheckout?.viewModel.paymentData.token)
        XCTAssertNil(self.mpCheckout?.viewModel.paymentData.issuer)
        XCTAssertEqual(self.mpCheckout?.viewModel.pxNavigationHandler.navigationController.viewControllers.count, 1)
        let lastVC = self.mpCheckout!.viewModel.pxNavigationHandler.navigationController.viewControllers[0]
        XCTAssertTrue(lastVC.isKind(of: IdentificationViewController.self))
    }

    func testStartIssuersScreen() {
        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        let issuers = [MockBuilder.buildIssuer()]
        self.mpCheckout?.viewModel.issuers = issuers
        self.mpCheckout?.viewModel.paymentData.paymentMethod = MockBuilder.buildPaymentMethod("id")

        self.mpCheckout?.showIssuersScreen()

        XCTAssertNotNil(self.mpCheckout?.viewModel.paymentData.paymentMethod)
        XCTAssertNil(self.mpCheckout?.viewModel.paymentData.payerCost)
        XCTAssertNil(self.mpCheckout?.viewModel.paymentData.token)
        XCTAssertNil(self.mpCheckout?.viewModel.paymentData.issuer)
        XCTAssertEqual(self.mpCheckout?.viewModel.pxNavigationHandler.navigationController.viewControllers.count, 1)
        let lastVC = self.mpCheckout!.viewModel.pxNavigationHandler.navigationController.viewControllers[0]
        XCTAssertTrue(lastVC.isKind(of: AdditionalStepViewController.self))
    }

    func testStartPayerCostScreen() {

        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        let payerCost = [MockBuilder.buildPayerCost(installments: 1, installmentRate: 0, hasCFT: false)]
        self.mpCheckout?.viewModel.payerCosts = payerCost
        self.mpCheckout?.viewModel.paymentData.paymentMethod = MockBuilder.buildPaymentMethod("id")

        self.mpCheckout?.showPayerCostScreen()

        XCTAssertNotNil(self.mpCheckout?.viewModel.paymentData.paymentMethod)
        XCTAssertNil(self.mpCheckout?.viewModel.paymentData.payerCost)
        XCTAssertNil(self.mpCheckout?.viewModel.paymentData.token)
        XCTAssertNil(self.mpCheckout?.viewModel.paymentData.issuer)
        XCTAssertEqual(self.mpCheckout?.viewModel.pxNavigationHandler.navigationController.viewControllers.count, 1)
        let lastVC = self.mpCheckout!.viewModel.pxNavigationHandler.navigationController.viewControllers[0]
        XCTAssertTrue(lastVC.isKind(of: AdditionalStepViewController.self))
    }

    func testCollectPaymentData() {
        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        MPCheckoutTestAction.loadGroupsInViewModel(mpCheckout: self.mpCheckout!)
        MPCheckoutTestAction.selectAccountMoney(mpCheckout: self.mpCheckout!)

        self.mpCheckout?.showReviewAndConfirmScreen()

        XCTAssertNotNil(self.mpCheckout?.viewModel.paymentData.paymentMethod)
        XCTAssertEqual(self.mpCheckout?.viewModel.pxNavigationHandler.navigationController.viewControllers.count, 1)
        let lastVC = self.mpCheckout!.viewModel.pxNavigationHandler.navigationController.viewControllers[0]
        XCTAssertTrue(lastVC.isKind(of: PXReviewViewController.self))
    }

    func testDisplayPaymentResult_onlinePayment() {
        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        let paymentMethod = MockBuilder.buildPaymentMethod("visa")
        self.mpCheckout!.viewModel.payment = MockBuilder.buildPayment("visa")
        self.mpCheckout!.viewModel.paymentData = MockBuilder.buildPaymentData(paymentMethod: paymentMethod)

        self.mpCheckout!.showPaymentResultScreen()
        XCTAssertNotNil(self.mpCheckout?.viewModel.paymentResult)
        XCTAssertEqual(self.mpCheckout?.viewModel.pxNavigationHandler.navigationController.viewControllers.count, 1)
        let lastVC = self.mpCheckout!.viewModel.pxNavigationHandler.navigationController.viewControllers[0]
        XCTAssertTrue(lastVC.isKind(of: PXResultViewController.self))

    }

    func testDisplayPaymentResult_offlinePayment() {

        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        let paymentMethod = MockBuilder.buildPaymentMethod("bolbradesco", paymentTypeId: "bank_transfer")
        self.mpCheckout!.viewModel.payment = MockBuilder.buildPayment("bolbradesco")
        self.mpCheckout!.viewModel.paymentData = MockBuilder.buildPaymentData(paymentMethod: paymentMethod)
        self.mpCheckout?.viewModel.instructionsInfo = MockBuilder.buildInstructionsInfo(paymentMethod: paymentMethod)

        self.mpCheckout!.showPaymentResultScreen()

        XCTAssertNotNil(self.mpCheckout?.viewModel.paymentResult)
        XCTAssertEqual(self.mpCheckout?.viewModel.pxNavigationHandler.navigationController.viewControllers.count, 1)
        let lastVC = self.mpCheckout!.viewModel.pxNavigationHandler.navigationController.viewControllers[0]
        XCTAssertTrue(lastVC.isKind(of: PXResultViewController.self))

    }

    func testShowBankInterestWarning() {
        var site = "MCO"
        SiteManager.shared.setSite(siteId: site)
        XCTAssertEqual(true, MercadoPagoCheckout.showBankInterestWarning())

        site = "MLA"
        SiteManager.shared.setSite(siteId: site)
        XCTAssertEqual(false, MercadoPagoCheckout.showBankInterestWarning())
    }

    func testShowPayerCostDescription() {
        var site = "MCO"
        SiteManager.shared.setSite(siteId: site)
        XCTAssertEqual(false, MercadoPagoCheckout.showPayerCostDescription())

        site = "MLA"
        SiteManager.shared.setSite(siteId: site)
        XCTAssertEqual(true, MercadoPagoCheckout.showPayerCostDescription())
    }

    func testSetBinaryMode() {
        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        //Test Default Binary Mode
        XCTAssertEqual(false, self.mpCheckout?.viewModel.checkoutPreference.isBinaryMode())

        //Test setBinaryMode Method
        self.mpCheckout?.viewModel.checkoutPreference.setBinaryMode(isBinaryMode: true)
        XCTAssertEqual(true, self.mpCheckout?.viewModel.checkoutPreference.isBinaryMode())

        self.mpCheckout?.viewModel.checkoutPreference.setBinaryMode(isBinaryMode: false)
        XCTAssertEqual(false, self.mpCheckout?.viewModel.checkoutPreference.isBinaryMode())
    }

    func testWhenCreateNewCardTokenFailsWithInvalidIdNumberThenDoNotExecuteNextStep() {
        MercadoPagoCheckoutViewModel.error = nil

        let mercadoPagoBuilder = MercadoPagoCheckoutBuilder(publicKey: "public_key", checkoutPreference: MockBuilder.buildCheckoutPreference(), paymentConfiguration: MockBuilder.buildPXPaymentConfiguration())

        mercadoPagoBuilder.setPrivateKey(key: "acess_token")

        mpCheckout = MercadoPagoCheckout(builder: mercadoPagoBuilder)

        mpCheckout?.viewModel.updateCheckoutModel(paymentMethods: [MockBuilder.buildPaymentMethod("visa")], cardToken: MockBuilder.buildCardToken())

        mpCheckout?.viewModel.cardToken?.cardNumber = "invalid_identification_number"

        mpCheckout?.createNewCardToken()
        XCTAssertNil(MercadoPagoCheckoutViewModel.error)
    }
}

open class MercadoPagoCheckoutMock: MercadoPagoCheckout {
    var executedNextStep: Bool = false
    override open func executeNextStep() {
        executedNextStep = true
    }
}
