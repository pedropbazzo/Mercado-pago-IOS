//
//  TestAction.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 3/13/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit
@testable import MercadoPagoSDKV4

class MPCheckoutTestAction: NSObject {

    static func loadGroupsInViewModel(mpCheckout: MercadoPagoCheckout) {
        MPCheckoutTestAction.loadGroupsInViewModel(mpCheckoutViewModel: mpCheckout.viewModel)
    }

    static func loadGroupsWithOneTapInViewModel(mpCheckout: MercadoPagoCheckout) {
        MPCheckoutTestAction.loadGroupsWithOneTapInViewModel(mpCheckoutViewModel: mpCheckout.viewModel)
    }

    static func selectAccountMoney(mpCheckout: MercadoPagoCheckout) {
        MPCheckoutTestAction.selectAccountMoney(mpCheckoutViewModel: mpCheckout.viewModel)
    }

    static func selectCreditCardOption(mpCheckout: MercadoPagoCheckout) {
        MPCheckoutTestAction.selectCreditCardOption(mpCheckoutViewModel: mpCheckout.viewModel)
    }

    static func selectCustomerCardOption(mpCheckout: MercadoPagoCheckout) {
        MPCheckoutTestAction.selectCustomerCardOption(mpCheckoutViewModel: mpCheckout.viewModel)
    }

    static func selectTicket(mpCheckout: MercadoPagoCheckout) {
        MPCheckoutTestAction.selectTicket(mpCheckoutViewModel: mpCheckout.viewModel)
    }

    static func selectAccountMoney(mpCheckoutViewModel: MercadoPagoCheckoutViewModel) {
        let accountMoneyOption = MockBuilder.buildCustomerPaymentMethod("account_money", paymentMethodId: "account_money")
        mpCheckoutViewModel.updateCheckoutModel(paymentOptionSelected: accountMoneyOption as! PaymentMethodOption)
    }

    static func selectCreditCardOption(mpCheckoutViewModel: MercadoPagoCheckoutViewModel) {
        let creditCardOption = MockBuilder.buildPaymentMethodSearchItem("credit_card", type: PXPaymentMethodSearchItemType(rawValue: PXPaymentMethodSearchItemTypes.PAYMENT_TYPE))
        mpCheckoutViewModel.paymentOptionSelected = creditCardOption
    }

    static func selectCustomerCardOption(mpCheckoutViewModel: MercadoPagoCheckoutViewModel) {
        let customerCardOption = MockBuilder.buildCustomerPaymentMethod("customerCardId", paymentMethodId: "visa")
        mpCheckoutViewModel.updateCheckoutModel(paymentOptionSelected: customerCardOption as! PaymentMethodOption)
    }

    static func selectTicket(mpCheckoutViewModel: MercadoPagoCheckoutViewModel) {
        let ticketOption = MockBuilder.buildPaymentMethodSearchItem("off", type: PXPaymentMethodSearchItemType(rawValue: PXPaymentMethodSearchItemTypes.PAYMENT_TYPE))
       mpCheckoutViewModel.updateCheckoutModel(paymentOptionSelected: ticketOption as! PaymentMethodOption)
    }

    static func loadGroupsInViewModel(mpCheckoutViewModel: MercadoPagoCheckoutViewModel) {

        let accountMoneyOption = MockBuilder.buildCustomerPaymentMethod("account_money", paymentMethodId: "account_money")
        let customerCardOption = MockBuilder.buildCustomerPaymentMethod("customerCardId", paymentMethodId: "visa")
        let creditCardOption = MockBuilder.buildPaymentMethodSearchItem("credit_card", type: PXPaymentMethodSearchItemType(rawValue: PXPaymentMethodSearchItemTypes.PAYMENT_TYPE))
        let offlineOption = MockBuilder.buildPaymentMethodSearchItem("off", type: PXPaymentMethodSearchItemType(rawValue: PXPaymentMethodSearchItemTypes.PAYMENT_METHOD))
        let paymentMethodVisa = MockBuilder.buildPaymentMethod("visa")
        let paymentMethodMaster = MockBuilder.buildPaymentMethod("master")
        let paymentMethodTicket = MockBuilder.buildPaymentMethod("ticket", paymentTypeId: "off")
        let paymentMethodTicket2 = MockBuilder.buildPaymentMethod("ticket 2", paymentTypeId: "off")
        let paymentMethodAM = MockBuilder.buildPaymentMethod("account_money", paymentTypeId: "account_money")
        let offlinePaymentMethod = MockBuilder.buildPaymentMethod("off", paymentTypeId: PXPaymentTypes.TICKET.rawValue)

        let paymentMethodSearchMock = MockBuilder.buildPaymentMethodSearch(groups: [creditCardOption, offlineOption], paymentMethods: [paymentMethodVisa, paymentMethodMaster, paymentMethodAM, offlinePaymentMethod, paymentMethodTicket, paymentMethodTicket2], customOptions: [customerCardOption, accountMoneyOption])
        mpCheckoutViewModel.customPaymentOptions = [customerCardOption, accountMoneyOption] as? [CustomerPaymentMethod]
        mpCheckoutViewModel.updateCheckoutModel(paymentMethodSearch: paymentMethodSearchMock)
    }

    static func loadGroupsWithOneTapInViewModel(mpCheckoutViewModel: MercadoPagoCheckoutViewModel) {

        let accountMoneyOption = MockBuilder.buildCustomerPaymentMethod("account_money", paymentMethodId: "account_money")
        let customerCardOption = MockBuilder.buildCustomerPaymentMethod("customerCardId", paymentMethodId: "visa")
        let creditCardOption = MockBuilder.buildPaymentMethodSearchItem("credit_card", type: PXPaymentMethodSearchItemType(rawValue: PXPaymentMethodSearchItemTypes.PAYMENT_TYPE))
        let offlineOption = MockBuilder.buildPaymentMethodSearchItem("off", type: PXPaymentMethodSearchItemType(rawValue: PXPaymentMethodSearchItemTypes.PAYMENT_METHOD))
        let paymentMethodVisa = MockBuilder.buildPaymentMethod("visa")
        let paymentMethodMaster = MockBuilder.buildPaymentMethod("master")
        let paymentMethodTicket = MockBuilder.buildPaymentMethod("ticket", paymentTypeId: "off")
        let paymentMethodTicket2 = MockBuilder.buildPaymentMethod("ticket 2", paymentTypeId: "off")
        let paymentMethodAM = MockBuilder.buildPaymentMethod("account_money", paymentTypeId: "account_money")
        let offlinePaymentMethod = MockBuilder.buildPaymentMethod("off", paymentTypeId: PXPaymentTypes.TICKET.rawValue)
        let oneTapItem = PXOneTapItem(paymentMethodId: "account_money", paymentTypeId: "account_money", oneTapCard: nil)

        let paymentMethodSearchMock = MockBuilder.buildPaymentMethodSearch(groups: [creditCardOption, offlineOption], paymentMethods: [paymentMethodVisa, paymentMethodMaster, paymentMethodAM, offlinePaymentMethod, paymentMethodTicket, paymentMethodTicket2], customOptions: [customerCardOption, accountMoneyOption], oneTapItem: oneTapItem)
        mpCheckoutViewModel.customPaymentOptions = [customerCardOption, accountMoneyOption] as? [CustomerPaymentMethod]
        mpCheckoutViewModel.updateCheckoutModel(paymentMethodSearch: paymentMethodSearchMock)
    }

}
