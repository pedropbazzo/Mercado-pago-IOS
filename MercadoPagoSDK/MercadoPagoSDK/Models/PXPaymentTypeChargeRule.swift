//
//  PXPaymentTypeChargeRule.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 13/6/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import UIKit

/**
Use this object to make a charge related to any payment method. The relationship is by `paymentMethodId`. You can especify a default `amountCharge` for each payment method.
 */ 
@objc
public final class PXPaymentTypeChargeRule: NSObject, Codable {
    let paymentMethdodId: String
    let amountCharge: Double

    // MARK: Init.
    /**
     - parameter paymentMethdodId: Payment method id.
     - parameter amountCharge: Amount charge for the current payment method.
     */
   @objc public init(paymentMethdodId: String, amountCharge: Double) {
        self.paymentMethdodId = paymentMethdodId
        self.amountCharge = amountCharge
        super.init()
    }

    public enum PXPaymentTypeChargeRuleKeys: String, CodingKey {
        case paymentTypeId = "payment_type_id"
        case amountCharge = "charge"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PXPaymentTypeChargeRuleKeys.self)
        try container.encodeIfPresent(self.paymentMethdodId, forKey: .paymentTypeId)
        try container.encodeIfPresent(self.amountCharge, forKey: .amountCharge)
    }

    public func toJSONString() throws -> String? {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        return String(data: data, encoding: .utf8)
    }

    public func toJSON() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }

    public class func fromJSON(data: Data) throws -> PXPaymentTypeChargeRule {
        return try JSONDecoder().decode(PXPaymentTypeChargeRule.self, from: data)
    }
}
