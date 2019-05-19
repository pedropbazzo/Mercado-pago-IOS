//
//  PaymentMethodTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 1/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest
@testable import MercadoPagoSDKV4
class PaymentMethodTest: BaseTest {

    //Test for PaymentMethod First Color
    func testGetPMDefaultFirstColor() {
        let paymentMethod = MockBuilder.buildPaymentMethod("sarasa")

        let color = paymentMethod.getColor(bin: nil)
        XCTAssertEqual(color, UIColor.cardDefaultColor())
    }

    func testGetPMFirstColor() {
        let paymentMethod = MockBuilder.buildPaymentMethod("visa", name: "Visa", paymentTypeId: "credit_card", multipleSettings: false)
        let cardNumber = "4242424242424242"
        let bin = cardNumber.substring(to: (cardNumber.characters.index(cardNumber.startIndex, offsetBy: 6)))
        let color = paymentMethod.getColor(bin: bin)
        XCTAssertEqual(color, ResourceManager.shared.getColorFor(paymentMethod, settings: nil))
    }

    func testGetPMFirstColorForMultipleSettings() {
        let paymentMethod = MockBuilder.buildPaymentMethod("maestro", name: "Maestro", paymentTypeId: "debit_card", multipleSettings: true)
        let firstSettingCardNumber = "501041456060594693"
        let secondSettingCardNumber = "5010811232093852985"
        let firstBin = firstSettingCardNumber.substring(to: (firstSettingCardNumber.characters.index(firstSettingCardNumber.startIndex, offsetBy: 6)))
        let secondBin = secondSettingCardNumber.substring(to: (secondSettingCardNumber.characters.index(firstSettingCardNumber.startIndex, offsetBy: 6)))

        let firstSetting: [PXSetting] = [paymentMethod.settings[0]]
        let secondSetting: [PXSetting] = [paymentMethod.settings[1]]

        let firstColor = paymentMethod.getColor(bin: firstBin)
        XCTAssertEqual(firstColor, ResourceManager.shared.getColorFor(paymentMethod, settings: firstSetting))

        let secondColor = paymentMethod.getColor(bin: secondBin)
        XCTAssertEqual(secondColor, ResourceManager.shared.getColorFor(paymentMethod, settings: secondSetting))
    }

    //Test for PaymentMethod Label Mask
    func testGetPMDefaultLabelMask() {
        let paymentMethod = MockBuilder.buildPaymentMethod("sarasa")

        let mask = paymentMethod.getLabelMask(bin: nil)
        XCTAssertEqual(mask, ResourceManager.shared.getLabelMaskFor(paymentMethod, settings: nil))
    }

    func testGetPMLabelMask() {
        let paymentMethod = MockBuilder.buildPaymentMethod("visa", name: "Visa", paymentTypeId: "credit_card", multipleSettings: false)
        let cardNumber = "4242424242424242"
        let bin = cardNumber.substring(to: (cardNumber.characters.index(cardNumber.startIndex, offsetBy: 6)))
        let mask = paymentMethod.getLabelMask(bin: bin)
        XCTAssertEqual(mask, ResourceManager.shared.getLabelMaskFor(paymentMethod, settings: nil))
    }

    func testGetPMLabelMaskForMultipleSettings() {
        let paymentMethod = MockBuilder.buildPaymentMethod("maestro", name: "Maestro", paymentTypeId: "debit_card", multipleSettings: true)
        let firstSettingCardNumber = "501041456060594693"
        let secondSettingCardNumber = "5010811232093852985"
        let firstBin = firstSettingCardNumber.substring(to: (firstSettingCardNumber.characters.index(firstSettingCardNumber.startIndex, offsetBy: 6)))
        let secondBin = secondSettingCardNumber.substring(to: (secondSettingCardNumber.characters.index(firstSettingCardNumber.startIndex, offsetBy: 6)))

        let firstSetting: [PXSetting] = [paymentMethod.settings[0]]
        let secondSetting: [PXSetting] = [paymentMethod.settings[1]]

        let firstMask = paymentMethod.getLabelMask(bin: firstBin)
        XCTAssertEqual(firstMask, ResourceManager.shared.getLabelMaskFor(paymentMethod, settings: firstSetting))

        let secondMask = paymentMethod.getLabelMask(bin: secondBin)
        XCTAssertEqual(secondMask, ResourceManager.shared.getLabelMaskFor(paymentMethod, settings: secondSetting))
    }

    //Test for PaymentMethod Edit Text Mask
    func testGetPMDefaultEditTextMask() {
        let paymentMethod = MockBuilder.buildPaymentMethod("sarasa")

        let mask = paymentMethod.getEditTextMask(bin: nil)
        XCTAssertEqual(mask, ResourceManager.shared.getEditTextMaskFor(paymentMethod, settings: nil))
    }

    func testGetPMEditTextMask() {
        let paymentMethod = MockBuilder.buildPaymentMethod("visa", name: "Visa", paymentTypeId: "credit_card", multipleSettings: false)
        let cardNumber = "4242424242424242"
        let bin = cardNumber.substring(to: (cardNumber.characters.index(cardNumber.startIndex, offsetBy: 6)))
        let editTextMask = paymentMethod.getEditTextMask(bin: bin)
        XCTAssertEqual(editTextMask, ResourceManager.shared.getEditTextMaskFor(paymentMethod, settings: nil))
    }

    func testGetPMEditTextMaskForMultipleSettings() {
        let paymentMethod = MockBuilder.buildPaymentMethod("maestro", name: "Maestro", paymentTypeId: "debit_card", multipleSettings: true)
        let firstSettingCardNumber = "501041456060594693"
        let secondSettingCardNumber = "5010811232093852985"
        let firstBin = firstSettingCardNumber.substring(to: (firstSettingCardNumber.characters.index(firstSettingCardNumber.startIndex, offsetBy: 6)))
        let secondBin = secondSettingCardNumber.substring(to: (secondSettingCardNumber.characters.index(firstSettingCardNumber.startIndex, offsetBy: 6)))

        let firstSetting: [PXSetting] = [paymentMethod.settings[0]]
        let secondSetting: [PXSetting] = [paymentMethod.settings[1]]

        let firstEditTextMask = paymentMethod.getEditTextMask(bin: firstBin)
        XCTAssertEqual(firstEditTextMask, ResourceManager.shared.getEditTextMaskFor(paymentMethod, settings: firstSetting))

        let secondEditTextMask = paymentMethod.getEditTextMask(bin: secondBin)
        XCTAssertEqual(secondEditTextMask, ResourceManager.shared.getEditTextMaskFor(paymentMethod, settings: secondSetting))
    }

    //Test for PaymentMethod Image
    func testGetPMImage() {
        let paymentMethod = MockBuilder.buildPaymentMethod("visa", name: "Visa", paymentTypeId: "credit_card", multipleSettings: false)
        let cardNumber = "4242424242424242"
        let bin = cardNumber.substring(to: (cardNumber.characters.index(cardNumber.startIndex, offsetBy: 6)))
        let image = paymentMethod.getImage()
        XCTAssertEqual(image, ResourceManager.shared.getImageFor(paymentMethod))

    }

}
