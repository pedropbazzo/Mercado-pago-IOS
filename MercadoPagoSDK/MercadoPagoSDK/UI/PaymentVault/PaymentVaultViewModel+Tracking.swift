//
//  PaymentVaultViewModel+Tracking.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 26/11/2018.
//

import Foundation
// MARK: Tracking
extension PaymentVaultViewModel {
    func getAvailablePaymentMethodForTracking() -> [Any] {
        var dic: [Any] = []
        if isRoot {
            for plugin in paymentMethodPlugins {
                var pluginDic: [String: Any] = [:]
                pluginDic["payment_method_type"] = plugin.paymentMethodPluginId
                pluginDic["payment_method_id"] = plugin.paymentMethodPluginId
                dic.append(pluginDic)
            }
            if let customerPaymentOptions = customerPaymentOptions {
                for savedCard in customerPaymentOptions {
                    if let customerPM = savedCard as? CustomerPaymentMethod {
                        dic.append(customerPM.getCustomerPaymentMethodForTrancking())
                    }
                }
            }
        }
        for paymentOption in paymentMethodOptions {
            var paymentOptionDic: [String: Any] = [:]
            if paymentOption.getPaymentType() == PXPaymentMethodSearchItemTypes.PAYMENT_METHOD {
                let filterPaymentMethods = paymentMethods.filter { paymentOption.getId().startsWith($0.id) }
                if let paymentMethod = filterPaymentMethods.first {
                    paymentOptionDic["payment_method_id"] = paymentOption.getId()
                    paymentOptionDic["payment_method_type"] = paymentMethod.paymentTypeId
                }
            } else {
                paymentOptionDic["payment_method_type"] = paymentOption.getId()
            }
            dic.append(paymentOptionDic)
        }
        return dic
    }

    func getScreenProperties() -> [String: Any] {
        var properties: [String: Any] = ["discount": amountHelper.getDiscountForTracking()]
        properties["preference_amount"] = amountHelper.preferenceAmount
        properties["available_methods"] = getAvailablePaymentMethodForTracking()
        var itemsDic: [Any] = []
        for item in amountHelper.preference.items {
            itemsDic.append(item.getItemForTracking())
        }
        properties["items"] = itemsDic
        return properties
    }

    func getScreenPath() -> String {
        var screenPath = TrackingPaths.Screens.PaymentVault.getPaymentVaultPath()
        if let groupName = groupName {
            if groupName == PXPaymentTypes.BANK_TRANSFER.rawValue || groupName == PXPaymentTypes.TICKET.rawValue || groupName == PXPaymentTypes.BOLBRADESCO.rawValue {
                screenPath = TrackingPaths.Screens.PaymentVault.getTicketPath()
            } else {
                screenPath = TrackingPaths.Screens.PaymentVault.getCardTypePath()
            }
        }
        return screenPath
    }
}
