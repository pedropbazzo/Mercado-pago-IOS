//
//  PXSummaryAmountBody.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 02/01/2019.
//

import Foundation

class PXSummaryAmountBody: Codable {
    let siteId: String?
    let transactionAmount: String?
    let marketplace: String?
    let email: String?
    let productId: String?
    let paymentMethodId: String?
    let paymentType: String?
    let bin: String?
    let issuerId: String?
    let labels: [String]?
    let defaultInstallments: Int?
    let differentialPricingId: String?
    let processingMode: String?
    let charges: [PXPaymentTypeChargeRule]?

    init(siteId: String?, transactionAmount: String?, marketplace: String?, email: String?, productId: String?, paymentMethodId: String?, paymentType: String?, bin: String?, issuerId: String?, labels: [String]?, defaultInstallments: Int?, differentialPricingId: String?, processingMode: String?, charges: [PXPaymentTypeChargeRule]?) {
        self.siteId = siteId
        self.transactionAmount = transactionAmount
        self.marketplace = marketplace
        self.email = email
        self.productId = productId
        self.paymentMethodId = paymentMethodId
        self.paymentType = paymentType
        self.bin = bin
        self.issuerId = issuerId
        self.labels = labels
        self.defaultInstallments = defaultInstallments
        self.differentialPricingId = differentialPricingId
        self.processingMode = processingMode
        self.charges = charges
    }

    public enum PXSummaryAmountBodyKeys: String, CodingKey {
        case siteId = "site_id"
        case transactionAmount = "transaction_amount"
        case marketplace
        case email
        case productId = "product_id"
        case paymentMethodId = "payment_method_id"
        case paymentType = "payment_type"
        case bin = "bin"
        case issuerId = "issuer_id"
        case labels
        case defaultInstallments = "default_installments"
        case differentialPricingId = "differential_pricing_id"
        case processingMode = "processing_mode"
        case charges
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PXSummaryAmountBodyKeys.self)
        try container.encodeIfPresent(self.siteId, forKey: .siteId)
        try container.encodeIfPresent(self.transactionAmount, forKey: .transactionAmount)
        try container.encodeIfPresent(self.marketplace, forKey: .marketplace)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.productId, forKey: .productId)
        try container.encodeIfPresent(self.paymentMethodId, forKey: .paymentMethodId)
        try container.encodeIfPresent(self.paymentType, forKey: .paymentType)
        try container.encodeIfPresent(self.bin, forKey: .bin)
        try container.encodeIfPresent(self.issuerId, forKey: .issuerId)
        try container.encodeIfPresent(self.labels, forKey: .labels)
        try container.encodeIfPresent(self.defaultInstallments, forKey: .defaultInstallments)
        try container.encodeIfPresent(self.differentialPricingId, forKey: .differentialPricingId)
        try container.encodeIfPresent(self.processingMode, forKey: .processingMode)
        try container.encodeIfPresent(self.charges, forKey: .charges)
    }

    open func toJSONString() throws -> String? {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        return String(data: data, encoding: .utf8)
    }

    open func toJSON() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }

    open class func fromJSON(data: Data) throws -> PXSummaryAmountBody {
        return try JSONDecoder().decode(PXSummaryAmountBody.self, from: data)
    }
}
