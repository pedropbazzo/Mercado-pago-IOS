//
//  AdditionalStepViewModel.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 4/24/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import XCTest
@testable import MercadoPagoSDKV4

class PayerCostAdditionalStepViewModelTest: BaseTest {
    var instance: PayerCostAdditionalStepViewModel!

    override func setUp() {
        super.setUp()
        let payerCosts = MockBuilder.buildInstallment().payerCosts
        let cardToken = MockBuilder.buildCardToken()
        let paymentMethod = MockBuilder.buildPaymentMethod("visa")
        let amountHelper = PXAmountHelper(preference: MockBuilder.buildCheckoutPreference(), paymentData: MockBuilder.buildPaymentData(), discount: nil, campaign: nil, chargeRules: [], consumedDiscount: false)
        self.instance = PayerCostAdditionalStepViewModel(amountHelper: amountHelper, token: cardToken, paymentMethod: paymentMethod, dataSource: payerCosts, email: nil, mercadoPagoServicesAdapter: MockBuilder.buildMercadoPagoServicesAdapter())
    }

    func testTitle() {
        XCTAssertEqual(self.instance!.getTitle(), "¿En cuántas cuotas?".localized)
        XCTAssertEqual(self.instance!.maxFontSize, 24)
    }

    func testBankInterestCell() {
        var site = "MCO"
        SiteManager.shared.setSite(siteId: site)
        XCTAssertEqual(self.instance!.showBankInsterestCell(), true)

        site = "MLA"
        SiteManager.shared.setSite(siteId: site)
        XCTAssertEqual(self.instance!.showBankInsterestCell(), false)
    }

    func testScreenName() {
        XCTAssertEqual(self.instance!.getScreenName(), "CARD_INSTALLMENTS")
    }

    func testScreenId() {
        XCTAssertEqual(self.instance!.screenId, "/card" + "/installments")
    }

    func testNumberOfSections() {
        XCTAssertEqual(self.instance!.numberOfSections(), 4)
    }
    func testCardSectionView() {
        XCTAssertTrue(self.instance.getCardSectionView() is CardFrontView)
    }

    func testRowsWithDiscount() {
        /// Screen:
        /// ¿ En cuantas Cuotas?
        /// (Tarjeta)
        /// (Descuento)
        /// (Cuotas)

        // Title
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 0), 1)
        // Card
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 1), 1)
        // Payer Costs
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 2), self.instance!.numberOfCellsInBody())

        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 6), 0)
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 6)), 0)

        // Title Cell
        XCTAssertTrue(self.instance!.isTitleCellFor(indexPath: IndexPath(row: 0, section: 0)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 0)), 40)

        // Card Cell
        XCTAssertTrue(self.instance!.isCardCellFor(indexPath: IndexPath(row: 0, section: 1)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 1)), UIScreen.main.bounds.width * 0.50)
        XCTAssertTrue(self.instance!.showCardSection())
        XCTAssertFalse(self.instance!.isBankInterestCellFor(indexPath: IndexPath(row: 1, section: 1)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 1, section: 1)), 0)

        // Payer Costs
        XCTAssertTrue(self.instance!.showPayerCostDescription())
        XCTAssertTrue(self.instance!.isBodyCellFor(indexPath: IndexPath(row: 0, section: 2)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 2)), 60)
    }

    func testRowsWithDiscountAndBankInterest() {
        /// Screen:
        /// ¿ En cuantas Cuotas?
        /// (Tarjeta)
        /// (Intereses Bancarios)
        /// (Descuento)
        /// (Cuotas)

       SiteManager.shared.setSite(siteId: "MCO")

        // Title
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 0), 1)
        // Card
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 1), 2)
        // Payer Costs
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 2), self.instance!.numberOfCellsInBody())

        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 6), 0)
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 6)), 0)

        // Title Cell
        XCTAssertTrue(self.instance!.isTitleCellFor(indexPath: IndexPath(row: 0, section: 0)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 0)), 40)

        // Card Cell
        XCTAssertTrue(self.instance!.isCardCellFor(indexPath: IndexPath(row: 0, section: 1)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 1)), UIScreen.main.bounds.width * 0.50)
        XCTAssertTrue(self.instance!.showCardSection())
        XCTAssertTrue(self.instance!.isBankInterestCellFor(indexPath: IndexPath(row: 1, section: 1)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 1, section: 1)), BankInsterestTableViewCell.cellHeight)

        // Payer Costs
        XCTAssertFalse(self.instance!.showPayerCostDescription())
        XCTAssertTrue(self.instance!.isBodyCellFor(indexPath: IndexPath(row: 0, section: 2)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 2)), 60)

        SiteManager.shared.setSite(siteId: "MLA")
    }

    func testRowsNoDiscount() {
        /// Screen:
        /// ¿En cuantas Cuotas?
        /// (Tarjeta)
        /// (Total)
        /// (Cuotas)

//        let flowPreference = FlowPreference()
//        flowPreference.disableDiscount()
//        MercadoPagoCheckout.setFlowPreference(flowPreference)

        SiteManager.shared.setSite(siteId: "MLA")

        // Title
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 0), 1)
        // Card
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 1), 1)

        // Payer Costs
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 2), self.instance!.numberOfCellsInBody())

        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 6), 0)
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 6)), 0)

        // Title Cell
        XCTAssertTrue(self.instance!.isTitleCellFor(indexPath: IndexPath(row: 0, section: 0)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 0)), 40)

        // Card Cell
        XCTAssertTrue(self.instance!.isCardCellFor(indexPath: IndexPath(row: 0, section: 1)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 1)), UIScreen.main.bounds.width * 0.50)
        XCTAssertTrue(self.instance!.showCardSection())
        XCTAssertFalse(self.instance!.isBankInterestCellFor(indexPath: IndexPath(row: 1, section: 1)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 1, section: 1)), 0)

        // Payer Costs
        XCTAssertTrue(self.instance!.showPayerCostDescription())
        XCTAssertTrue(self.instance!.isBodyCellFor(indexPath: IndexPath(row: 0, section: 2)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 2)), 60)

    }
}

class IssuerAdditionalStepViewModelTest: BaseTest {
    var instance: IssuerAdditionalStepViewModel!

    override func setUp() {
        super.setUp()
        let issuer = MockBuilder.buildIssuer()
        let cardToken = MockBuilder.buildCardToken()
        let paymentMethod = MockBuilder.buildPaymentMethod("visa")

        self.instance = IssuerAdditionalStepViewModel(amountHelper: MockBuilder.buildAmountHelper(), token: cardToken, paymentMethod: paymentMethod, dataSource: [issuer], mercadoPagoServicesAdapter: MockBuilder.buildMercadoPagoServicesAdapter())
    }

    func testTitle() {
        XCTAssertEqual(self.instance!.getTitle(), "¿Quién emitió tu tarjeta?".localized)
        XCTAssertEqual(self.instance!.maxFontSize, 24)
    }

    func testBankInterestCell() {
        XCTAssertEqual(self.instance!.showBankInsterestCell(), false)
    }

    func testScreenName() {
        XCTAssertEqual(self.instance!.getScreenName(), "CARD_ISSUERS")
    }

    func testScreenId() {
        XCTAssertEqual(self.instance!.screenId, "/card" + "/issuer")
    }

    func testNumberOfSections() {
        XCTAssertEqual(self.instance!.numberOfSections(), 4)
    }

    func testCardSectionView() {
        XCTAssertTrue(self.instance.getCardSectionView() is CardFrontView)
    }

    func testRows() {
        /// Screen:
        /// ¿Cual es tu banco?
        /// (Tarjeta)
        /// (Bancos)

        // Title
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 0), 1)
        // Card
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 1), 1)
        // Issuers
        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 2), self.instance!.numberOfCellsInBody())

        XCTAssertEqual(self.instance!.numberOfRowsInSection(section: 6), 0)
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 6)), 0)

        // Title Cell
        XCTAssertTrue(self.instance!.isTitleCellFor(indexPath: IndexPath(row: 0, section: 0)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 0)), 40)

        // Card Cell
        XCTAssertTrue(self.instance!.isCardCellFor(indexPath: IndexPath(row: 0, section: 1)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 1)), UIScreen.main.bounds.width * 0.50)
        XCTAssertTrue(self.instance!.showCardSection())
        XCTAssertFalse(self.instance!.isBankInterestCellFor(indexPath: IndexPath(row: 1, section: 1)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 1, section: 1)), 0)

        // Issuers
        XCTAssertTrue(self.instance!.showPayerCostDescription())
        XCTAssertTrue(self.instance!.isBodyCellFor(indexPath: IndexPath(row: 0, section: 2)))
        XCTAssertEqual(self.instance!.heightForRowAt(indexPath: IndexPath(row: 0, section: 2)), 80)

    }
}
