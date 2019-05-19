//
//  PXPaymentMethodConfiguration.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 27/11/18.
//

import UIKit

class PXPaymentMethodConfiguration: NSObject {
    let paymentOptionID: String
    let discountInfo: String?
    let paymentOptionsConfigurations: [PXPaymentOptionConfiguration]
    let selectedAmountConfiguration: String?
    init(paymentOptionID: String, discountInfo: String?, paymentOptionsConfigurations: [PXPaymentOptionConfiguration], selectedAmountConfiguration: String?) {
        self.paymentOptionID = paymentOptionID
        self.discountInfo = discountInfo
        self.paymentOptionsConfigurations = paymentOptionsConfigurations
        self.selectedAmountConfiguration = selectedAmountConfiguration
        super.init()
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let otherConfiguration = object as? PXPaymentMethodConfiguration else {
            return false
        }
        return paymentOptionID == otherConfiguration.paymentOptionID
    }
}

class PXPaymentOptionConfiguration: NSObject {
    let id: String
    let discountConfiguration: PXDiscountConfiguration?
    let amountConfiguration: PXAmountConfiguration?
    init(id: String, discountConfiguration: PXDiscountConfiguration? = nil, payerCostConfiguration: PXAmountConfiguration? = nil) {
        self.id = id
        self.discountConfiguration = discountConfiguration
        self.amountConfiguration = payerCostConfiguration
        super.init()
    }
}
