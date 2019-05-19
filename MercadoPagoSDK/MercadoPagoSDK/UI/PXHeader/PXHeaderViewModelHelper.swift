//
//  PXHeaderViewModelHelper.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 11/15/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

internal extension PXResultViewModel {

    func getHeaderComponentProps() -> PXHeaderProps {
        let props = PXHeaderProps(labelText: labelTextHeader(), title: titleHeader(), backgroundColor: primaryResultColor(), productImage: iconImageHeader(), statusImage: badgeImage(), closeAction: { [weak self] in
            if let callback = self?.callback {
                callback(PaymentResult.CongratsState.cancel_EXIT)
            }
        })
        return props
    }

    func buildHeaderComponent() -> PXHeaderComponent {
        let headerProps = getHeaderComponentProps()
        return PXHeaderComponent(props: headerProps)
    }
}

// MARK: Build Helpers
internal extension PXResultViewModel {
    func iconImageHeader() -> UIImage? {
        if paymentResult.isAccepted() {
            if self.paymentResult.isApproved() {
                return preference.getHeaderApprovedIcon() // * **
            } else if self.paymentResult.isWaitingForPayment() {
                return preference.getHeaderPendingIcon()
            } else {
                return preference.getHeaderImageFor(self.paymentResult.paymentData?.paymentMethod)
            }
        } else {
            return preference.getHeaderRejectedIcon(paymentResult.paymentData?.paymentMethod)
        }

    }

    func badgeImage() -> UIImage? {
        if !preference.showBadgeImage {
            return nil
        }
        return ResourceManager.shared.getBadgeImageWith(status: paymentResult.status, statusDetail: paymentResult.statusDetail)
    }

    func labelTextHeader() -> NSAttributedString? {
        if paymentResult.isAccepted() {
            var isOnlineMethod = true
            if let paymentMethod = self.paymentResult.paymentData?.getPaymentMethod() {
                isOnlineMethod = paymentMethod.isOnlinePaymentMethod
            }

            if self.paymentResult.isWaitingForPayment() && isOnlineMethod {
                return "¡Apúrate a pagar!".localized.toAttributedString(attributes: [NSAttributedString.Key.font: Utils.getFont(size: PXHeaderRenderer.LABEL_FONT_SIZE)])
            } else {
                var labelText: String?
                if self.paymentResult.isApproved() {
                    labelText = preference.getApprovedLabelText()
                } else {
                    labelText = preference.getPendingLabelText()
                }
                guard let text = labelText else {
                    return nil
                }
                return text.toAttributedString(attributes: [NSAttributedString.Key.font: Utils.getFont(size: PXHeaderRenderer.LABEL_FONT_SIZE)])
            }
        }
        if !preference.showLabelText {
            return nil
        } else {
            return NSMutableAttributedString(string: "Algo salió mal...".localized, attributes: [NSAttributedString.Key.font: Utils.getFont(size: PXHeaderRenderer.LABEL_FONT_SIZE)])
        }

    }
    func titleHeader() -> NSAttributedString {
        if self.instructionsInfo != nil {
            return titleForInstructions()
        }
        if paymentResult.isAccepted() {
            if self.paymentResult.isApproved() {
                return NSMutableAttributedString(string: preference.getApprovedTitle(), attributes: [NSAttributedString.Key.font: Utils.getFont(size: PXHeaderRenderer.TITLE_FONT_SIZE)])
            } else {
                return NSMutableAttributedString(string: "Estamos procesando el pago".localized, attributes: [NSAttributedString.Key.font: Utils.getFont(size: PXHeaderRenderer.TITLE_FONT_SIZE)])
            }
        }
        if preference.rejectedTitleSetted {
            return NSMutableAttributedString(string: preference.getRejectedTitle(), attributes: [NSAttributedString.Key.font: Utils.getFont(size: PXHeaderRenderer.TITLE_FONT_SIZE)])
        }
        return titleForStatusDetail(statusDetail: self.paymentResult.statusDetail, paymentMethod: self.paymentResult.paymentData?.paymentMethod)
    }

    func titleForStatusDetail(statusDetail: String, paymentMethod: PXPaymentMethod?) -> NSAttributedString {
        guard let paymentMethod = paymentMethod else {
            return "".toAttributedString()
        }

        var statusDetail = statusDetail
        let badFilledKey = "cc_rejected_bad_filled"
        if statusDetail.contains(badFilledKey) {
            statusDetail = badFilledKey
        }

        let title = statusDetail + "_title"

        if title.existsLocalizedBeta() {
            return getTitleForRejected(paymentMethod, title)
        } else {
            return getDefaultRejectedTitle()
        }
    }

    func titleForInstructions() -> NSMutableAttributedString {
        guard let instructionsInfo = self.instructionsInfo, let amountInfo = instructionsInfo.amountInfo else {
            return "".toAttributedString()
        }
        let currency = SiteManager.shared.getCurrency()
        let currencySymbol = currency.getCurrencySymbolOrDefault()
        let thousandSeparator = currency.getThousandsSeparatorOrDefault()
        let decimalSeparator = currency.getDecimalSeparatorOrDefault()

        let arr = String(amountInfo.amount).split(separator: ".").map(String.init)
        let amountStr = Utils.getAmountFormatted(arr[0], thousandSeparator: thousandSeparator, decimalSeparator: decimalSeparator)
        let centsStr = Utils.getCentsFormatted(String(amountInfo.amount), decimalSeparator: decimalSeparator)
        let amountRange = instructionsInfo.getInstruction()!.title.range(of: currencySymbol + " " + amountStr + decimalSeparator + centsStr)

        if let range = amountRange {
            let lowerBoundTitle = String(instructionsInfo.instructions[0].title[..<range.lowerBound])
            let attributedTitle = NSMutableAttributedString(string: lowerBoundTitle, attributes: [NSAttributedString.Key.font: Utils.getFont(size: PXHeaderRenderer.TITLE_FONT_SIZE)])
            let attributedAmount = Utils.getAttributedAmount(amountInfo.amount, thousandSeparator: thousandSeparator, decimalSeparator: decimalSeparator, currencySymbol: currencySymbol, color: UIColor.px_white(), fontSize: PXHeaderRenderer.TITLE_FONT_SIZE, centsFontSize: PXHeaderRenderer.TITLE_FONT_SIZE / 2, smallSymbol: true)
            attributedTitle.append(attributedAmount)
            let upperBoundTitle = String(instructionsInfo.instructions[0].title[range.upperBound...])
            let endingTitle = NSAttributedString(string: upperBoundTitle, attributes: [NSAttributedString.Key.font: Utils.getFont(size: PXHeaderRenderer.TITLE_FONT_SIZE)])
            attributedTitle.append(endingTitle)

            return attributedTitle
        } else {
            let attributedTitle = NSMutableAttributedString(string: (instructionsInfo.instructions[0].title), attributes: [NSAttributedString.Key.font: Utils.getFont(size: 26)])
            return attributedTitle
        }
    }

    func getTitleForRejected(_ paymentMethod: PXPaymentMethod, _ title: String) -> NSAttributedString {

        guard let paymentMethodName = paymentMethod.name else {
            return getDefaultRejectedTitle()
        }

        return NSMutableAttributedString(string: (title.localized_beta as NSString).replacingOccurrences(of: "%0", with: "\(paymentMethodName)"), attributes: [NSAttributedString.Key.font: Utils.getFont(size: PXHeaderRenderer.TITLE_FONT_SIZE)])
    }

    func getDefaultRejectedTitle() -> NSAttributedString {
        return NSMutableAttributedString(string: PXHeaderResutlConstants.REJECTED_HEADER_TITLE.localized_beta, attributes: [NSAttributedString.Key.font: Utils.getFont(size: PXHeaderRenderer.TITLE_FONT_SIZE)])
    }
}
