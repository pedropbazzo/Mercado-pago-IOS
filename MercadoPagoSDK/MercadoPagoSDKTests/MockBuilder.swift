//
//  MockBuilder.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 22/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import Foundation

@testable import MercadoPagoSDKV4

open class MockBuilder: NSObject {

    internal class var MOCK_PAYMENT_ID: Int64 {
        return 1826290155
    }

    class var PREF_ID_NO_EXCLUSIONS: String {
        return "NO_EXCLUSIONS"
    }

    class var PREF_ID_CC: String {
        return "ONLY_CREDIT_CARD"
    }

    class var PREF_ID_TICKET: String {
        return "ONLY_TICKET"
    }

    class var PREF_ID_PAGOFACIL: String {
        return "ONLY_PAGOFACIL"
    }

    class var MLA_PK: String {
        return "PK_MLA"
    }

    class var MLA_CURRENCY: String {
        return "ARS"
    }

    class var MLA_PAYMENT_TYPES: Set<String> {
        return [PXPaymentTypes.CREDIT_CARD.rawValue, PXPaymentTypes.TICKET.rawValue, PXPaymentTypes.BANK_TRANSFER.rawValue]
    }

    class var MERCHANT_ACCESS_TOKEN: String {
        return "MERCHANT_ACCESS_TOKEN"
    }

    class var CUSTOMER_ACCESS_TOKEN: String {
        return "ACCESS_TOKEN"
    }

    class var INSTALLMENT_AMOUNT: Double {
        return 100.0
    }

    class var AMEX_TEST_CARD_NUMBER: String {
        return "371180303257522"
    }

    class var MASTER_TEST_CARD_NUMBER: String {
        return "5031755734530604"
    }

    class var VISA_TEST_CARD_NUMBER: String {
        return "4170068810108020"
    }

    static let TEN = "10.00"
    static let HUNDRED = "100.00"
    static let THOUSAND = "1000.00"
    static let TEN_THOUSAND = "10000.00"
    static let MILLON = "1000000.00"
    static let OVER_MILLON = "10000000000.00"
    static let MILLIONS = "10000000000000000.00"

    static let HALF_HOUR_IN_MINS = 30 * 1000
    static let ONE_HOUR_IN_MINS = 60 * 1000
    static let TWENTY_HOURS_AND_FIFTEEN_MINS_IN_MINS = 1395 * 1000
    static let ONE_DAY_IN_MINS = 1440 * 1000
    static let TWO_DAY_IN_MINS = 2880 * 1000
    static let SEVEN_DAY_IN_MINS = 10080 * 1000
    static let HUNDRED_DAYS_IN_MINS = 144000 * 1000

    class func buildCheckoutPreference() -> PXCheckoutPreference {
        let items = [self.buildItem("itemId", quantity: 1, unitPrice: 2559), self.buildItem("itemId2", quantity: 2, unitPrice: 10)]
        let preference = PXCheckoutPreference(siteId: "MLA", payerEmail: "sarasa@gmail.com", items: items)
        preference.id = PREF_ID_NO_EXCLUSIONS
        return preference
    }

    class func buildItem(_ id: String, quantity: Int, unitPrice: Double, description: String? = "Description") -> PXItem {
        let item = PXItem(title: "item title", quantity: quantity, unitPrice: unitPrice)
        item.setDescription(description: description ?? "")
        return item
    }

    class func buildPayer() -> PXPayer {
        let payer = PXPayer(email: "thisisanem@il.com")
        return payer
    }

    class func buildPreferencePaymentMethods() -> PXPaymentPreference {
        return PXPaymentPreference(maxAcceptedInstallments: 1, defaultInstallments: 1, excludedPaymentMethodIds: ["amex"], excludedPaymentTypeIds: self.getMockPaymentTypeIds(), defaultPaymentMethodId: "visa", defaultPaymentTypeId: nil)
    }

    class func buildPaymentMethod(_ id: String, name: String = "", paymentTypeId: String = "credit_card", multipleSettings: Bool = false) -> PXPaymentMethod {
        let paymentMethod = PXPaymentMethod(additionalInfoNeeded: ["info"], id: id, name: name, paymentTypeId: paymentTypeId, status: nil, secureThumbnail: nil, thumbnail: nil, deferredCapture: nil, settings: [], minAllowedAmount: nil, maxAllowedAmount: nil, accreditationTime: nil, merchantAccountId: nil, financialInstitutions: nil, description: nil)

        if multipleSettings {
            paymentMethod.settings = [MockBuilder.buildSetting(), MockBuilder.buildSetting()]
        } else {
            paymentMethod.settings = [MockBuilder.buildSetting()]
        }

        return paymentMethod
    }

    class func buildSecurityCode() -> PXSecurityCode {
        let securityCode = PXSecurityCode(cardLocation: "back", mode: "mode", length: 3)
        return securityCode
    }

    class func buildSetting() -> PXSetting {
        let setting = PXSetting(bin: MockBuilder.buildBinMask(), cardNumber: MockBuilder.buildCardNumber(), securityCode: MockBuilder.buildSecurityCode())
        return setting
    }

    class func buildIdentification() -> PXIdentification {
        let identification = PXIdentification(number: "number", type: "type")
        return identification
    }

    class func buildIdentificationTypes() -> [PXIdentificationType] {
        let identificationType = PXIdentificationType(id: "String", name: nil, minLength: 0, maxLength: 0, type: nil)
        return [identificationType]
    }

    class func buildCard(paymentMethodId: String = "paymentMethodId") -> PXCard {
        let card = PXCard(cardHolder: buildCardholder(), customerId: "customer_id", dateCreated: nil, dateLastUpdated: nil, expirationMonth: 4, expirationYear: 20, firstSixDigits: "123456", id: "4", issuer: buildIssuer(), lastFourDigits: "1234", paymentMethod: MockBuilder.buildPaymentMethod(paymentMethodId), securityCode: buildSecurityCode())
        return card
    }

    class func buildCustomerPaymentMethod(paymentMethodId: String, paymentTypeId: String) -> CustomerPaymentMethod {
        let customerPm = CustomerPaymentMethod()
        let pm = MockBuilder.buildPaymentMethod(paymentMethodId)
        customerPm.paymentMethod = pm
        customerPm.paymentMethodId = paymentMethodId
        customerPm.paymentMethodTypeId = paymentTypeId
        customerPm.customerPaymentMethodDescription = paymentMethodId
        return customerPm
    }

    class func buildPayment(_ paymentMethodId: String, installments: Int = 1, status: String = "approved", statusDetail: String = "approved") -> PXPayment {
        let payment = PXPayment(id: MOCK_PAYMENT_ID, status: status)
        payment.paymentMethodId = paymentMethodId
        payment.paymentTypeId = "credit_card"
        payment.installments = installments
        payment.transactionDetails = PXTransactionDetails(externalResourceUrl: nil, financialInstitution: nil, installmentAmount: MockBuilder.INSTALLMENT_AMOUNT, netReivedAmount: nil, overpaidAmount: nil, totalPaidAmount: nil, paymentMethodReferenceId: nil)
        payment.statusDetail = statusDetail
        payment.payer = buildPayer()
        payment.card = buildCard()
        return payment
    }

    class func buildOffPayment(_ paymentMethodId: String, paymentTypeId: String? = "ticket") -> PXPayment {
        let payment = PXPayment(id: MOCK_PAYMENT_ID, status: "pending")
        payment.id = self.MOCK_PAYMENT_ID
        payment.paymentMethodId = paymentMethodId
        payment.paymentTypeId = paymentTypeId
        return payment
    }

    class func buildMastercardPayment(_ installments: Int = 1, status: String = "approved", statusDetail: String = "approved") -> PXPayment {
        return MockBuilder.buildPayment("master", installments: installments, status: status, statusDetail: statusDetail)
    }

    class func buildVisaPayment(_ installments: Int = 1, status: String = "approved", statusDetail: String = "approved") -> PXPayment {
        return MockBuilder.buildPayment("visa", installments: installments, status: status, statusDetail: statusDetail)
    }

    class func buildAmexPayment(_ installments: Int = 1, status: String = "approved", statusDetail: String = "approved") -> PXPayment {
        return MockBuilder.buildPayment("visa", installments: installments, status: status, statusDetail: statusDetail)
    }

    class func buildPaymentMethodSearchItem(_ paymentMethodId: String, type: PXPaymentMethodSearchItemType? = nil) -> PXPaymentMethodSearchItem {
        let paymentMethodSearchItem = PXPaymentMethodSearchItem(id: paymentMethodId, type: type.map { $0.rawValue }, description: paymentMethodId, comment: nil, children: [], childrenHeader: nil, showIcon: true)
        return paymentMethodSearchItem
    }

    class func buildPaymentMethodPlugin(id: String, name: String, displayOrder: PXPaymentMethodPlugin.DisplayOrder = .TOP, shouldSkipPaymentPlugin: Bool = false, configPaymentMethodPlugin: MockConfigPaymentMethodPlugin?) -> PXPaymentMethodPlugin {

        let plugin = PXPaymentMethodPlugin(paymentMethodPluginId: id, name: name, image: UIImage(), description: nil)

        if let configPaymentMethodPlugin = configPaymentMethodPlugin {
            plugin.setPaymentMethodConfig(config: configPaymentMethodPlugin)
        }

        plugin.setDisplayOrder(order: displayOrder)

        return plugin
    }

    class func buildPaymentPlugin() -> PXPaymentProcessor {
        return MockPaymentPluginViewController()
    }

    class func buildPaymentMethodSearch(groups: [PXPaymentMethodSearchItem]? = nil, paymentMethods: [PXPaymentMethod]? = nil, customOptions: [PXCardInformation]? = nil, oneTapItem: PXOneTapItem? = nil) -> PXPaymentMethodSearch {
        let paymentMethodSearch = PXPaymentMethodSearch(paymentMethodSearchItem: groups!, customOptionSearchItems: [], paymentMethods: paymentMethods!, cards: nil, defaultOption: nil, oneTap: oneTapItem)
        return paymentMethodSearch
    }

    class func buildPaymentMethodSearchComplete() -> PXPaymentMethodSearch {
        let accountMoneyOption = MockBuilder.buildCustomerPaymentMethod("account_money", paymentMethodId: "account_money")
        let customerCardOption = MockBuilder.buildCustomerPaymentMethod("customerCardId", paymentMethodId: "visa")
        let creditCardOption = MockBuilder.buildPaymentMethodSearchItem("credit_card", type: PXPaymentMethodSearchItemType(rawValue: PXPaymentMethodSearchItemTypes.PAYMENT_METHOD))
        let offlineOption = MockBuilder.buildPaymentMethodSearchItem("off", type: PXPaymentMethodSearchItemType(rawValue: PXPaymentMethodSearchItemTypes.PAYMENT_METHOD))
        let paymentMethodVisa = MockBuilder.buildPaymentMethod("visa")
        let paymentMethodMaster = MockBuilder.buildPaymentMethod("master")
        let paymentMethodTicket = MockBuilder.buildPaymentMethod("ticket", paymentTypeId: "off")
        let paymentMethodTicket2 = MockBuilder.buildPaymentMethod("ticket 2", paymentTypeId: "off")
        let paymentMethodAM = MockBuilder.buildPaymentMethod("account_money", paymentTypeId: "account_money")
        let offlinePaymentMethod = MockBuilder.buildPaymentMethod("off", paymentTypeId: PXPaymentTypes.TICKET.rawValue)

        let paymentMethodSearchMock = MockBuilder.buildPaymentMethodSearch(groups: [creditCardOption, offlineOption], paymentMethods: [paymentMethodVisa, paymentMethodMaster, paymentMethodAM, offlinePaymentMethod, paymentMethodTicket, paymentMethodTicket2], customOptions: [customerCardOption, accountMoneyOption])
        return paymentMethodSearchMock
    }

    class func getMockPaymentMethods() -> [PXPaymentMethod] {
        return [self.buildPaymentMethod("amex"), self.buildPaymentMethod("oxxo")]
    }

    class func getMockPaymentTypeIds() -> [String] {
        return [PXPaymentTypes.BITCOIN.rawValue, PXPaymentTypes.ACCOUNT_MONEY.rawValue]
    }

    class func buildPaymentType() -> PXPaymentType {
        return PXPaymentType()
    }

    class func buildToken(withESC: Bool = false) -> PXToken {
        let token = PXToken(id: "tokenId", publicKey: MLA_PK, cardId: "cardId", luhnValidation: true, status: "status", usedDate: nil, cardNumberLength: 16, dateCreated: Date(), securityCodeLength: 3, expirationMonth: 11, expirationYear: 22, dateLastUpdated: Date(), dueDate: Date(), firstSixDigits: "123456", lastFourDigits: "1234", cardholder: MockBuilder.buildCardholder(), esc: nil)
        if withESC {
            token.esc = "esc"
        }
        return token
    }

    class func buildCardToken() -> PXCardToken {
        let cardToken = PXCardToken()
        cardToken.cardholder = MockBuilder.buildCardholder()
        cardToken.cardholder?.identification?.number = ""
        return cardToken
    }

    class func buildCardholder() -> PXCardHolder {
        let cardHolder = PXCardHolder(name: "name", identification: buildIdentification())
        return cardHolder
    }

    class func buildCardNumber() -> PXCardNumber {
        let cardNumber = PXCardNumber(length: 4, validation: "luhn")
        return cardNumber
    }

    class func buildPXBankDeal() -> PXBankDeal {
        let id_ = "bankDealID"
        let dateExpired = Date()
        let dateStarted = Date()
        let installments = [1, 2]
        let issuer = MockBuilder.buildPXIssuer()
        let legals = "Legals Text"
        let picture = MockBuilder.buildPXPicture()
        let maxInstallments = 6
        let paymentMethods = [MockBuilder.buildPaymentMethod("idPaymentMethod")]
        let recommendedMessage = "Recommended Message"
        let totalFinancialCost = 86.0

        return PXBankDeal(id: id_, dateExpired: dateExpired, dateStarted: dateStarted, installments: installments, issuer: issuer, legals: legals, picture: picture, maxInstallments: maxInstallments, paymentMethods: paymentMethods, recommendedMessage: recommendedMessage, totalFinancialCost: totalFinancialCost)
    }

    class func buildPXIssuer() -> PXIssuer {
        return PXIssuer(id: "issuer ID", name: "Issuer Name")
    }

    class func buildPXPicture() -> PXPicture {
        return PXPicture(id: "pictureID", size: nil, url: "http://secure.mlstatic.com/openplatform/resources/images/issuers/ico_bank_1078.png", secureUrl: "https://secure.mlstatic.com/openplatform/resources/images/issuers/ico_bank_1078.png")
    }

    class func buildPXBin() -> PXBin {
        return PXBin(exclusionPattern: nil, installmentPattern: "^4", pattern: "^4")
    }

    class func buildPXCardNumber() -> PXCardNumber {
        return PXCardNumber(length: 16, validation: "standard")
    }

    class func buildPXSecurityCode(cvvOnTheBack: Bool = true) -> PXSecurityCode {
        var cardLocation = "back"
        if !cvvOnTheBack {
            cardLocation = "front"
        }
        return PXSecurityCode(cardLocation: cardLocation, mode: "mandatory", length: 3)
    }

    class func buildPXSetting() -> PXSetting {
        let bin = MockBuilder.buildPXBin()
        let cardNumber = MockBuilder.buildPXCardNumber()
        let securityCode = MockBuilder.buildPXSecurityCode()
        return PXSetting(bin: bin, cardNumber: cardNumber, securityCode: securityCode)
    }

    class func buildBinMask() -> PXBin {
        let bin = PXBin(exclusionPattern: "exclusion_pattern", installmentPattern: "installments_pattern", pattern: "pattern")
        return bin
    }

    class func buildPayerCost(installments: Int = 1, installmentRate: Double = 10, hasCFT: Bool = false) -> PXPayerCost {
        let payerCost = PXPayerCost(installmentRate: installmentRate, labels: ["label"], minAllowedAmount: 10, maxAllowedAmount: 100, recommendedMessage: "", installmentAmount: 10, totalAmount: 10, installments: installments)

        if hasCFT {
            payerCost.labels = ["CFT_0,00%|TEA_0,00%"]
        }

        return payerCost
    }

    class func buildIssuer() -> PXIssuer {
        let issuer = PXIssuer(id: "id", name: "name")
        return issuer
    }

    class func buildPaymentOptionSelected(_ id: String) -> PaymentMethodOption {
        let option = PXPaymentMethodSearchItem(id: id, type: nil, description: "description", comment: nil, children: [], childrenHeader: nil, showIcon: true)
        return option
    }

    class func buildCustomerPaymentMethod(_ id: String, paymentMethodId: String) -> PXCardInformation {
        let customOption = CustomerPaymentMethod()
        customOption.customerPaymentMethodId = id
        customOption.paymentMethodId = paymentMethodId
        customOption.paymentMethodTypeId = paymentMethodId
        return customOption
    }

    class func buildCustomerPaymentMethodWithESC(paymentMethodId: String) -> PXCardInformation {
        let customOption = CustomerPaymentMethod()
        customOption.customerPaymentMethodId = "esc"
        customOption.paymentMethodId = paymentMethodId
        return customOption
    }

    class func buildPaymentData(paymentMethod: PXPaymentMethod) -> PXPaymentData {
        let paymentData = PXPaymentData()
        paymentData.paymentMethod = paymentMethod
        paymentData.token = MockBuilder.buildToken()
        paymentData.issuer = MockBuilder.buildIssuer()
        paymentData.payerCost = MockBuilder.buildPayerCost()
        return paymentData
    }

    class func buildInstructionsInfo(paymentMethod: PXPaymentMethod) -> PXInstructions {
        let amountInfo = PXAmountInfo()
        amountInfo.amount = 22.0
        amountInfo.currency = MockBuilder.buildCurrency()
        let intructionsInfo = PXInstructions(amountInfo: amountInfo, instructions: [MockBuilder.buildInstruction()])
        return intructionsInfo
    }

    class func buildCurrency() -> PXCurrency {
        let currency = PXCurrency(id: "id", description: "description", symbol: "$", decimalPlaces: 1, decimalSeparator: ".", thousandSeparator: ",")
        return currency
    }

    class func buildInstruction() -> PXInstruction {
        let instruction = PXInstruction(title: "", subtitle: "Veja como é fácil pagar o seu produto", accreditationMessage: "Assim que você pagar, será aprovado automaticamente entre 1 e 2 dias úteis, mas considere: Em caso de feriados, será identificado até às 18h do segundo dia útil subsequente ao feriado.", accreditationComments: [], actions: nil, type: nil, references: [MockBuilder.buildInstructionReferenceNumber()], secondaryInfo: ["Uma cópia desse boleto foi enviada ao seu e-mail -payer.email- caso você precise realizar o pagamento depois."], tertiaryInfo: nil, info: ["1. Acesse o seu Internet Banking ou abra o aplicativo do seu banco.", "2. Utilize o código abaixo para realizar o pagamento."])
        return instruction
    }

    class func builCompletedInstruction() -> PXInstruction {
        let instruction = PXInstruction(title: "", subtitle: "Paga con estos datos", accreditationMessage: "Assim que você pagar, será aprovado automaticamente entre 1 e 2 dias úteis, mas considere: Em caso de feriados, será identificado até às 18h do segundo dia útil subsequente ao feriado.", accreditationComments: ["Pagamentos realizados em correspondentes bancários podem ultrapassar este prazo."], actions: [MockBuilder.buildInstructionAction()], type: nil, references: [MockBuilder.buildInstructionReferenceNumber(), MockBuilder.buildInstructionReference(label: "Concepto", value: ["MPAGO:COMPRA"]), MockBuilder.buildInstructionReference(label: "Empresa", value: ["Mercado Libre - Mercado Pago"])], secondaryInfo: ["También enviamos estos datos a tu email"], tertiaryInfo: ["Si pagas un fin de semana o feriado, será al siguiente día hábil."], info: ["Primero sigue estos pasos en el cajero", "", "1. Ingresa a Pagos", "2. Pagos de impuestos y servicios", "3. Rubro cobranzas", "", "Luego te irá pidiendo estos datos"])
        return instruction
    }

    class func buildInstructionReferenceNumber() -> PXInstructionReference {
        let instructionReference = PXInstructionReference(label: "Número", fieldValue: ["2379", "1729", "0000", "0400", "1003", "3802", "6025", "4607", "2909", "0063", "3330"], separator: " ", comment: "Você pode copiar e colar o código no fluxo de pagamento do seu aplicativo para torná-lo mais simples e cômodo")
        return instructionReference
    }

    class func buildInstructionReference(label: String, value: [String]) -> PXInstructionReference {
        let instructionReference = PXInstructionReference(label: label, fieldValue: value, separator: " ", comment: "")
        return instructionReference
    }

    class func buildInstructionAction() -> PXInstructionAction {
        let instructionAction = PXInstructionAction()
        instructionAction.label = "Ir a banca en línea"
        instructionAction.tag = "link"
        instructionAction.url = "http://www.bancomer.com.mx"
        return instructionAction
    }

    class func buildCompleteInstructionsInfo() -> PXInstructions {
        let amountInfo = PXAmountInfo()
        amountInfo.amount = 22.0
        amountInfo.currency = MockBuilder.buildCurrency()
        let intructionsInfo = PXInstructions(amountInfo: amountInfo, instructions: [MockBuilder.builCompletedInstruction()])
        return intructionsInfo
    }

    class func buildPaymentData(paymentMethodId: String, paymentMethodName: String, paymentMethodTypeId: String?) -> PXPaymentData {
        let paymentData = PXPaymentData()
        paymentData.paymentMethod = MockBuilder.buildPaymentMethod(paymentMethodId, name: paymentMethodName, paymentTypeId: paymentMethodTypeId!, multipleSettings: false)
        return paymentData
    }

    class func buildPaymentData(paymentMethodId: String = "visa", installments: Int = 0, installmentRate: Double = 0, withESC: Bool = false) -> PXPaymentData {
        let paymentData = PXPaymentData()
        paymentData.paymentMethod = MockBuilder.buildPaymentMethod(paymentMethodId)
        paymentData.issuer = MockBuilder.buildIssuer()
        paymentData.payer = buildPayer()
        paymentData.payerCost = MockBuilder.buildPayerCost(installments: installments, installmentRate: installmentRate)
        paymentData.token = MockBuilder.buildToken(withESC: withESC)
        return paymentData
    }

    class func buildPaymentResult(_ status: String? = "status", statusDetail: String = "detail", paymentMethodId: String, paymentTypeId: String = "credit_card") -> PaymentResult {
        let pm = MockBuilder.buildPaymentMethod(paymentMethodId, name: paymentMethodId, paymentTypeId: paymentTypeId)
        let paymentData = MockBuilder.buildPaymentData(paymentMethod: pm)
        let paymentResult = PaymentResult(status: status!, statusDetail: statusDetail, paymentData: paymentData, payerEmail: "email", paymentId: "id", statementDescription: "description")
        return paymentResult
    }

    class func buildInstallment() -> PXInstallment {
        let installment = PXInstallment(issuer: nil, payerCosts: [MockBuilder.buildPayerCost(), MockBuilder.buildPayerCost()], paymentMethodId: nil, paymentTypeId: nil)
        return installment
    }

    class func buildDiscount() -> PXDiscount {
        let discount = PXDiscount(id: "123", name: nil, percentOff: 0, amountOff: 20, couponAmount: 20, currencyId: nil)
        return discount
    }

    class func buildCampaign() -> PXCampaign {
        let campaign = PXCampaign(id: 1, code: nil, name: nil, maxCouponAmount: 1)
        return campaign
    }

    class func buildPaymentResult(withESC: Bool = false) -> PaymentResult {
        return PaymentResult(payment: MockBuilder.buildPayment("visa"), paymentData: MockBuilder.buildPaymentData(withESC: withESC))
    }

    class func buildAddress() -> PXAddress {
        let address = PXAddress(streetName: "street_name", streetNumber: 0, zipCode: "zip_code")
        return address
    }

    class func buildCustomer() -> PXCustomer {
        let customer = PXCustomer(address: buildAddress(), cards: [MockBuilder.buildCard(paymentMethodId: "visa")], defaultCard: "0", description: "description", dateCreated: nil, dateLastUpdated: nil, email: "email", firstName: "first_name", id: "id", identification: buildIdentification(), lastName: "last_name", liveMode: true, metadata: nil, phone: nil, registrationDate: nil)
        customer.cards = [MockBuilder.buildCard(paymentMethodId: "visa")]

        return customer
    }

    class func buildApiException(code: String) -> ApiException? {

        if code == ApiUtil.ErrorCauseCodes.INVALID_IDENTIFICATION_NUMBER.rawValue {
            return buildInvalidIdNumberApiException()
        }

        return nil
    }

    class func buildInvalidIdNumberApiException() -> ApiException {
        let apiException = ApiException()
        apiException.message = "Invalid cardholder.identification.number: 312322222 in site_id: MLV"
        apiException.error = "bad_request"
        apiException.status = 400

        var cause = [Cause]()
        let invalidIdCause = Cause()
        invalidIdCause.causeDescription = "Invalid parameter 'cardholder.identification.number'"
        invalidIdCause.code = "324"

        cause.append(invalidIdCause)
        apiException.cause = cause
        return apiException
    }

    class func buildPXPaymentConfiguration(paymentPluginId: String = "account_money") -> PXPaymentConfiguration {
        let paymentConfiguration = PXPaymentConfiguration(paymentProcessor: buildPaymentPlugin())
        paymentConfiguration.addPaymentMethodPlugin(plugin: buildPaymentMethodPlugin(id: paymentPluginId, name: "account_money", configPaymentMethodPlugin: nil))
        return paymentConfiguration
    }

    class func buildMercadoPagoServicesAdapter() -> MercadoPagoServicesAdapter {
        return MercadoPagoServicesAdapter(publicKey: "", privateKey: "")
    }

    class func buildAmountHelper() -> PXAmountHelper {
        return PXAmountHelper(preference: MockBuilder.buildCheckoutPreference(), paymentData: MockBuilder.buildPaymentData(), discount: nil, campaign: nil, chargeRules: [], consumedDiscount: false)
    }

}
