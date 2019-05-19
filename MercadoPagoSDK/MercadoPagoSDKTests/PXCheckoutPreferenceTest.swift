//
//  CheckoutPreferenceTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 21/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest
@testable import MercadoPagoSDKV4

class PXCheckoutPreferenceTest: XCTestCase {

    var preference: PXCheckoutPreference!

    override func setUp() {
        super.setUp()
        self.preference = MockBuilder.buildCheckoutPreference()
    }

    func testGetAmount() {
        preference.items.removeAll()
        XCTAssertEqual(preference.getTotalAmount(), 0)
        let item1 = PXItem(title: "item 1 title", quantity: 1, unitPrice: 10)
        let item2 = PXItem(title: "item 2 title", quantity: 3, unitPrice: 5)
        let item3 = PXItem(title: "item 3 title", quantity: 2, unitPrice: 2)
        self.preference.items = [item1, item2, item3]

        XCTAssertEqual(preference.getTotalAmount(), 29)
        preference.items.remove(at: 1)
        XCTAssertEqual(preference.getTotalAmount(), 14)

    }

    func testSetMaxInstallments() {
        XCTAssertEqual(preference.getMaxAcceptedInstallments(), 0)
        preference.setMaxInstallments(5)
        XCTAssertEqual(preference.getMaxAcceptedInstallments(), 5)
    }

    func testSetDefaultInstallments() {
        XCTAssertEqual(preference.getDefaultInstallments(), 0)
        preference.setDefaultInstallments(5)
        XCTAssertEqual(preference.getDefaultInstallments(), 5)
    }

    func testAddExcludedPaymentTypes() {
        XCTAssertEqual(preference.getExcludedPaymentTypesIds(), [])
        preference.setExcludedPaymentTypes(["credit_card"])
        XCTAssertEqual(preference.getExcludedPaymentTypesIds(), ["credit_card"])
    }

    func testAddExcludedPaymentType() {
        XCTAssertEqual(preference.getExcludedPaymentTypesIds(), [])
        preference.addExcludedPaymentType("credit_card")
        XCTAssertEqual(preference.getExcludedPaymentTypesIds(), ["credit_card"])
        preference.addExcludedPaymentType("debit_card")
        XCTAssertEqual(preference.getExcludedPaymentTypesIds(), ["credit_card", "debit_card"])
    }

    func testAddExcludedPaymentMethods() {
        XCTAssertEqual(preference.getExcludedPaymentMethodsIds(), [])
        preference.setExcludedPaymentMethods(["credit_card"])
        XCTAssertEqual(preference.getExcludedPaymentMethodsIds(), ["credit_card"])
    }

    func testAddExcludedPaymentMethod() {
        XCTAssertEqual(preference.getExcludedPaymentMethodsIds(), [])
        preference.addExcludedPaymentMethod("credit_card")
        XCTAssertEqual(preference.getExcludedPaymentMethodsIds(), ["credit_card"])
        preference.addExcludedPaymentMethod("debit_card")
        XCTAssertEqual(preference.getExcludedPaymentMethodsIds(), ["credit_card", "debit_card"])
    }

    func testSetDefaultPaymentMethodId() {
        preference.setDefaultPaymentMethodId("visa")
        XCTAssertEqual(preference.getDefaultPaymentMethodId(), "visa")
    }

    func testSetExpirationDate() {
        let date = Date()
        preference.setExpirationDate(date)
        XCTAssertEqual(preference.getExpirationDate(), date)
    }
    func testSetActiveFromDate() {
        let date = Date()
        preference.setActiveFromDate(date)
        XCTAssertEqual(preference.getActiveFromDate(), date)
    }

    func testIsExpired() {
        XCTAssertFalse(preference.isExpired())
        var date = Date(timeIntervalSinceNow: TimeInterval(200.0))
        preference.setExpirationDate(date)
        XCTAssertFalse(preference.isExpired())
        date = Date(timeIntervalSinceReferenceDate: TimeInterval(200.0))
        preference.setExpirationDate(date)
        XCTAssert(preference.isExpired())
    }

    func testIsActive() {
        XCTAssert(preference.isActive())
        var date = Date(timeIntervalSinceNow: TimeInterval(200.0))
        preference.setActiveFromDate(date)
        XCTAssertFalse(preference.isActive())
        date = Date(timeIntervalSinceReferenceDate: TimeInterval(200.0))
        preference.setActiveFromDate(date)
        XCTAssert(preference.isActive())
    }

    func testIsItemValid() {
        preference.items.removeAll()
        XCTAssertEqual(preference.itemsValid(), "No hay items")

        let item1 = PXItem(title: "item 1 title", quantity: 0, unitPrice: 10)
        preference.items.append(item1)
        XCTAssertEqual(preference.itemsValid(), "La cantidad de items no es valida")
    }

    func testValidateGreaterThanZeroAmount() {
        let item1 = PXItem(title: "item 1 title", quantity: 1, unitPrice: 10)
        let item2 = PXItem(title: "item 1 title", quantity: 4, unitPrice: -10)
        preference.items = [item1, item2]
        XCTAssertEqual(preference.validate(), "El monto de la compra no es válido")
    }

    func testValidateGreaterThanZeroAmount_OneItem() {
        let item2 = PXItem(title: "item 1 title", quantity: 4, unitPrice: -10)
        preference.items = [item2]
        XCTAssertEqual(preference.validate(), "El monto de la compra no es válido")
    }

}
