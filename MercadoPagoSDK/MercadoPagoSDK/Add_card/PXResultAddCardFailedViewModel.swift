//
//  PXResultAddCardFailedViewModel.swift
//  MercadoPagoSDKV4
//
//  Created by Diego Flores Domenech on 24/9/18.
//

import UIKit

final class PXResultAddCardFailedViewModel: PXResultViewModelInterface {

    let buttonCallback: () -> Void
    let linkCallback: () -> Void
    var callback: ((PaymentResult.CongratsState) -> Void)?

    init(buttonCallback: @escaping () -> Void, linkCallback: @escaping () -> Void) {
        self.buttonCallback = buttonCallback
        self.linkCallback = linkCallback
    }

    func getPaymentData() -> PXPaymentData {
        return PXPaymentData()
    }

    func primaryResultColor() -> UIColor {
        return ThemeManager.shared.warningColor()
    }

    func setCallback(callback: @escaping (PaymentResult.CongratsState) -> Void) {
        self.callback = callback
    }

    func getPaymentStatus() -> String {
        return ""
    }

    func getPaymentStatusDetail() -> String {
        return ""
    }

    func getPaymentId() -> String? {
        return nil
    }

    func isCallForAuth() -> Bool {
        return false
    }

    func buildHeaderComponent() -> PXHeaderComponent {
        let props = PXHeaderProps(labelText: NSAttributedString(string: "add_card_failed_label_text".localized_beta), title: NSAttributedString(string: "add_card_failed_title".localized_beta, attributes: [NSAttributedString.Key.font: UIFont.ml_regularSystemFont(ofSize: 26)]), backgroundColor: ThemeManager.shared.warningColor(), productImage: UIImage(named: "card_icon", in: ResourceManager.shared.getBundle(), compatibleWith: nil), statusImage: UIImage(named: "need_action_badge", in: ResourceManager.shared.getBundle(), compatibleWith: nil), closeAction: { [weak self] in
            if let callback = self?.callback {
                callback(PaymentResult.CongratsState.cancel_EXIT)
            }
        })
        let header = PXHeaderComponent(props: props)
        return header
    }

    func buildFooterComponent() -> PXFooterComponent {
        let buttonAction = PXAction(label: "add_card_try_again".localized_beta, action: self.buttonCallback)
        let linkAction = PXAction(label: "add_card_go_to_my_cards".localized_beta, action: self.linkCallback)
        let props = PXFooterProps(buttonAction: buttonAction, linkAction: linkAction, primaryColor: UIColor.ml_meli_blue(), animationDelegate: nil)
        let footer = PXFooterComponent(props: props)
        return footer
    }

    func buildReceiptComponent() -> PXReceiptComponent? {
        return nil
    }

    func buildBodyComponent() -> PXComponentizable? {
        return nil
    }

    func buildTopCustomView() -> UIView? {
        return nil
    }

    func buildBottomCustomView() -> UIView? {
        return nil
    }

    func getTrackingProperties() -> [String: Any] {
        return [:]
    }

    func getTrackingPath() -> String {
        return ""
    }

    func getFooterPrimaryActionTrackingPath() -> String {
        return ""
    }

    func getFooterSecondaryActionTrackingPath() -> String {
        return ""
    }

    func getHeaderCloseButtonTrackingPath() -> String {
        return ""
    }
}
