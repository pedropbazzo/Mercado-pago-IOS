//
//  UtilTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 23/3/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest

@testable import MercadoPagoSDKV4

class UtilsTest: BaseTest {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /** 
     *
     * getDateFromString
     * 
     **/
    func testDateFromStringRegularInput() {

        var dateExample = "2015-03-14"

        var dateComponents = DateComponents()
        dateComponents.year = 2015
        dateComponents.month = 3
        dateComponents.day = 14

        let expectedDate = NSCalendar.current.date(from: dateComponents)
        var date = Utils.getDateFromString(dateExample)
        XCTAssertEqual(expectedDate, date)

        dateExample = "2015/03/14"
        date = Utils.getDateFromString(dateExample)
        XCTAssertEqual(expectedDate, date)

    }

    func testDateFromStringInvalidInput() {

        //Invalid values
        var dateExample = "2015-22-22"
        var date = Utils.getDateFromString(dateExample)
        XCTAssertNil(date)

        dateExample = "2222222222-12222-2015"
        date = Utils.getDateFromString(dateExample)
        XCTAssertNil(date)

        dateExample = "2222-12-2015"
        date = Utils.getDateFromString(dateExample)
        XCTAssertNil(date)

        dateExample = "Esto es un test"
        date = Utils.getDateFromString(dateExample)
        XCTAssertNil(date)

        date = Utils.getDateFromString(nil)
        XCTAssertNil(date)
    }

    /**
     *
     * getStringFromDate
     *
     **/

    func testgGetStringFromDate() {

        var dateComponents = DateComponents()
        dateComponents.year = 2022
        dateComponents.month = 6
        dateComponents.day = 11

        var date = NSCalendar.current.date(from: dateComponents)
        var resultDate = Utils.getStringFromDate(date)

        XCTAssertEqual("2022-06-11", resultDate as! String)

        dateComponents.year = 2022
        dateComponents.month = 12
        dateComponents.day = 1

        date = NSCalendar.current.date(from: dateComponents)
        resultDate = Utils.getStringFromDate(date)

        XCTAssertEqual("2022-12-01", resultDate as! String)

    }

    func testgGetStringFromDateInvalidInput() {
        let resultDate = Utils.getStringFromDate(nil)
        XCTAssertTrue(resultDate is NSNull)
    }

    /**
     *
     * getExpirationMonthFromLabelText
     *
     **/
    func testGetExpirationMonthFromLabelText() {

        var text = "09/07"
        var result = Utils.getExpirationMonthFromLabelText(text)
        XCTAssertEqual(9, result)

        text = "12/70"
        result = Utils.getExpirationMonthFromLabelText(text)
        XCTAssertEqual(12, result)

        text = "99/1231231231231"
        result = Utils.getExpirationMonthFromLabelText(text)
        XCTAssertEqual(0, result)

        text = "999999999999/98"
        result = Utils.getExpirationMonthFromLabelText(text)
        XCTAssertEqual(0, result)

        text = "This is garbage data"
        result = Utils.getExpirationMonthFromLabelText(text)
        XCTAssertEqual(0, result)
    }

    /**
     *
     * getExpirationYearFromLabelText
     *
     **/
    func testGetExpirationYearFromLabelText() {

        var text = "09/07"
        var result = Utils.getExpirationYearFromLabelText(text)
        XCTAssertEqual(7, result)

        text = "09/70"
        result = Utils.getExpirationYearFromLabelText(text)
        XCTAssertEqual(70, result)

        //text = "09/1231231231231"
        //result = Utils.getExpirationYearFromLabelText(text)
        //XCTAssertEqual(0, result)

        text = "09/98"
        result = Utils.getExpirationYearFromLabelText(text)
        XCTAssertEqual(98, result)

        text = "This is a pretty ugly test"
        result = Utils.getExpirationYearFromLabelText(text)
        XCTAssertEqual(0, result)
    }

    /**
     *
     * findPaymentMethod
     *
     **/
    func testGetFindPaymentMethodInMLA() {

        let visaPM = MockBuilder.buildPaymentMethod("visa", name: "visa", paymentTypeId: "credit_card")
        let redlink = MockBuilder.buildPaymentMethod("redlink", name: "RedLink", paymentTypeId: "atm")
        let rapipago = MockBuilder.buildPaymentMethod("rapipago", name: "rapipago", paymentTypeId: "ticket")
        let pagofacil = MockBuilder.buildPaymentMethod("pagofacil", name: "pagofacil", paymentTypeId: "pagofacil")
        let mlaPaymentMethods = [visaPM, redlink, rapipago, pagofacil]

        let visaOutput = Utils.findPaymentMethod(mlaPaymentMethods, paymentMethodId: "visa")
        XCTAssertEqual(visaPM, visaOutput)

    }

    func testGetFindPaymentMethodInMLM() {

        let bancomer = MockBuilder.buildPaymentMethod("bancomer", name: "bancomer", paymentTypeId: "atm")
        let banamex = MockBuilder.buildPaymentMethod("banamex", name: "banamex", paymentTypeId: "atm")
        let oxxo = MockBuilder.buildPaymentMethod("oxxo", name: "oxxo", paymentTypeId: "ticket")
        let serfin = MockBuilder.buildPaymentMethod("serfin", name: "serfin", paymentTypeId: "atm")
        let visa = MockBuilder.buildPaymentMethod("visa", name: "visa", paymentTypeId: "credit_card")
        let debvisa = MockBuilder.buildPaymentMethod("debvisa", name: "visa", paymentTypeId: "debit_card")
        let accountMoney = MockBuilder.buildPaymentMethod("account_money", name: "account_money", paymentTypeId: "account_money")
        let mlmPaymentMethods = [bancomer, banamex, oxxo, serfin, visa, debvisa, accountMoney]

        let bancomerAtmOutput = Utils.findPaymentMethod(mlmPaymentMethods, paymentMethodId: "bancomer_atm")
        XCTAssertEqual(bancomer, bancomerAtmOutput)
        XCTAssertEqual("atm", bancomerAtmOutput.paymentTypeId)

        let bancomer7evelenAtmOutput = Utils.findPaymentMethod(mlmPaymentMethods, paymentMethodId: "bancomer_7eleven")
        XCTAssertEqual(bancomer, bancomer7evelenAtmOutput)
        XCTAssertEqual("7eleven", bancomerAtmOutput.paymentTypeId)

        let bancomerBankTransferOutput = Utils.findPaymentMethod(mlmPaymentMethods, paymentMethodId: "bancomer_bank_transfer")
        XCTAssertEqual(bancomer, bancomerBankTransferOutput)
        XCTAssertEqual("bank_transfer", bancomerAtmOutput.paymentTypeId)

        let accountMoneyOutput = Utils.findPaymentMethod(mlmPaymentMethods, paymentMethodId: "account_money")
        XCTAssertEqual(accountMoney, accountMoneyOutput)
        XCTAssertEqual("account_money", accountMoneyOutput.paymentTypeId)

        let oxxoOutput = Utils.findPaymentMethod(mlmPaymentMethods, paymentMethodId: "oxxo")
        XCTAssertEqual(oxxo, oxxoOutput)
        XCTAssertEqual("ticket", oxxoOutput.paymentTypeId)

        let debvisaOutput = Utils.findPaymentMethod(mlmPaymentMethods, paymentMethodId: "debvisa")
        XCTAssertEqual(debvisa, debvisaOutput)
        XCTAssertEqual("debit_card", debvisa.paymentTypeId)
    }

    /**
     *
     * getAmountDigits
     *
     **/
    func testGetAmountDigits() {
        var output = Utils.getAmountDigits("122.00", decimalSeparator: ".")
        XCTAssertEqual("122", output)

        output = Utils.getAmountDigits("00", decimalSeparator: ".")
        XCTAssertEqual("00", output)

        output = Utils.getAmountDigits("122.00", decimalSeparator: ",")
        XCTAssertEqual("122.00", output)

        output = Utils.getAmountDigits("7,57", decimalSeparator: ",")
        XCTAssertEqual("7", output)

        output = Utils.getAmountDigits("122342342322.99999", decimalSeparator: ".")
        XCTAssertEqual("122342342322", output)

        output = Utils.getAmountDigits("1221231435435345435435345345.3456789", decimalSeparator: ".")
        XCTAssertEqual("1221231435435345435435345345", output)

        output = Utils.getAmountDigits("ThisIsNotAValidString", decimalSeparator: ".")
        XCTAssertEqual("", output)

        output = Utils.getAmountDigits("12.000", decimalSeparator: "thisIsNotAValidSeparator")
        XCTAssertEqual("12.000", output)

        output = Utils.getAmountDigits("NothingHere", decimalSeparator: "isValidAtAll")
        XCTAssertEqual("", output)

    }

    /**
     *
     * getCentsFormatted
     *
     **/
    func testGetCentsFormatted() {
        SiteManager.shared.setSite(siteId: "MLA")
        var centsFormatted = Utils.getCentsFormatted("100.2", decimalSeparator: ".")
        XCTAssertEqual("20", centsFormatted)

        centsFormatted = Utils.getCentsFormatted("25", decimalSeparator: ".")
        XCTAssertEqual("00", centsFormatted)

        centsFormatted = Utils.getCentsFormatted("45.06", decimalSeparator: ".")
        XCTAssertEqual("06", centsFormatted)

        centsFormatted = Utils.getCentsFormatted("4.693458", decimalSeparator: ".")
        XCTAssertEqual("69", centsFormatted)
    }

    /**
     *
     * getAmountFormatted
     *
     **/
     func testGetAmountFormatted() {
        var amountFormatted = Utils.getAmountFormatted(MockBuilder.TEN, thousandSeparator: ",", decimalSeparator: ".")
        XCTAssertEqual(amountFormatted, "10")

        amountFormatted = Utils.getAmountFormatted(MockBuilder.HUNDRED, thousandSeparator: ",", decimalSeparator: ".")
        XCTAssertEqual(amountFormatted, "100")

        amountFormatted = Utils.getAmountFormatted(MockBuilder.THOUSAND, thousandSeparator: ",", decimalSeparator: ".")
        XCTAssertEqual(amountFormatted, "1,000")

        amountFormatted = Utils.getAmountFormatted(MockBuilder.TEN_THOUSAND, thousandSeparator: ",", decimalSeparator: ".")
        XCTAssertEqual(amountFormatted, "10,000")

        amountFormatted = Utils.getAmountFormatted(MockBuilder.MILLON, thousandSeparator: ",", decimalSeparator: ".")
        XCTAssertEqual(amountFormatted, "1,000,000")

        amountFormatted = Utils.getAmountFormatted(MockBuilder.OVER_MILLON, thousandSeparator: ",", decimalSeparator: ".")
        XCTAssertEqual(amountFormatted, "10,000,000,000")

        amountFormatted = Utils.getAmountFormatted(MockBuilder.MILLIONS, thousandSeparator: ",", decimalSeparator: ".")
        XCTAssertEqual(amountFormatted, "10,000,000,000,000,000")
     }

    /**
     *
     * findPaymentMethodSearchItemInGroups
     *
     **/
    func testFindPaymentMethodSearchItemInGroups() {

        let paymentMethodSearchitemRoot = MockBuilder.buildPaymentMethodSearchItem("id1")
        let paymentMethodSearchitemRootFirst = MockBuilder.buildPaymentMethodSearchItem("id1_1")
        let paymentMethodSearchitemRootSecond = MockBuilder.buildPaymentMethodSearchItem("id1_2")

        paymentMethodSearchitemRoot.children = [paymentMethodSearchitemRootFirst, paymentMethodSearchitemRootSecond]

        let paymentMethodSearchitemSecondRoot = MockBuilder.buildPaymentMethodSearchItem("id2")
        let paymentMethodSearchitemSecondRootFirst = MockBuilder.buildPaymentMethodSearchItem("id2_1")
        let paymentMethodSearchitemecondRootSecond = MockBuilder.buildPaymentMethodSearchItem("id2_2")

        paymentMethodSearchitemSecondRoot.children = [paymentMethodSearchitemSecondRootFirst, paymentMethodSearchitemecondRootSecond]

        var paymentMethodSearch = PXPaymentMethodSearch(paymentMethodSearchItem: [paymentMethodSearchitemRoot, paymentMethodSearchitemSecondRoot], customOptionSearchItems: [], paymentMethods: [], cards: [], defaultOption: nil, oneTap: nil)
        paymentMethodSearch.paymentMethodSearchItem = [paymentMethodSearchitemRoot, paymentMethodSearchitemSecondRoot]

        let rootFirst = Utils.findPaymentMethodSearchItemInGroups(paymentMethodSearch, paymentMethodId: "id1_1", paymentTypeId: nil)

        XCTAssertNotNil(rootFirst)
        XCTAssertEqual(paymentMethodSearchitemRootFirst.id, rootFirst?.id)

        let secondRoot = Utils.findPaymentMethodSearchItemInGroups(paymentMethodSearch, paymentMethodId: "id2", paymentTypeId: nil)
        XCTAssertNotNil(secondRoot)
        XCTAssertEqual(paymentMethodSearchitemSecondRoot.id, secondRoot?.id)

        paymentMethodSearch = PXPaymentMethodSearch(paymentMethodSearchItem: [], customOptionSearchItems: [], paymentMethods: [], cards: [], defaultOption: nil, oneTap: nil)

        let invalidData = Utils.findPaymentMethodSearchItemInGroups(paymentMethodSearch, paymentMethodId: "id2", paymentTypeId: nil)
        XCTAssertNil(invalidData)

    }

    func testAppendTwoJSONS() {
        var JSON1 = "{\n  \"hola\" : \"hola\"\n}"
        var JSON2 = "{\n  \"2\" : \"B\",\n  \"1\" : \"A\",\n  \"3\" : \"C\"\n}"

        XCTAssertEqual(Utils.append(firstJSON: JSON1, secondJSON: JSON2), "{\n  \"hola\" : \"hola\"\n\n  \"2\" : \"B\",\n  \"1\" : \"A\",\n  \"3\" : \"C\"\n}")

        JSON2 = ""
        XCTAssertEqual(Utils.append(firstJSON: JSON1, secondJSON: JSON2), "{\n  \"hola\" : \"hola\"\n}")

        JSON1 = ""
        XCTAssertEqual(Utils.append(firstJSON: JSON1, secondJSON: JSON2), "")

        JSON2 = "{\n  \"2\" : \"B\",\n  \"1\" : \"A\",\n  \"3\" : \"C\"\n}"
        XCTAssertEqual(Utils.append(firstJSON: JSON1, secondJSON: JSON2), "{\n  \"2\" : \"B\",\n  \"1\" : \"A\",\n  \"3\" : \"C\"\n}")
    }

}
