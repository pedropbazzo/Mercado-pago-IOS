//
//  PXOneTapHeaderMerchantLayout.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 3/23/19.
//

import Foundation

struct PXOneTapHeaderMerchantLayout {
    enum LayoutType {
        case onlyTitle
        case titleSubtitle
    }

    private let layoutType: LayoutType
    private var horizontalLayoutConstraints: [NSLayoutConstraint] = []
    private var verticalLayoutConstraints: [NSLayoutConstraint] = []

    init(layoutType: PXOneTapHeaderMerchantLayout.LayoutType) {
        self.layoutType = layoutType
    }
}

// MARK: Factory make factory.
extension PXOneTapHeaderMerchantLayout {
    mutating func makeConstraints(_ containerView: UIView, _ imageContainerView: UIView, _ titleLabel: UILabel) {
        horizontalLayoutConstraints.removeAll()
        let horizontalConstraints = [PXLayout.pinBottom(view: containerView),
                                     PXLayout.pinLeft(view: containerView, withMargin: PXLayout.XL_MARGIN),
                                     PXLayout.pinTop(view: imageContainerView, withMargin: PXLayout.XXS_MARGIN),
                                     PXLayout.pinBottom(view: imageContainerView, withMargin: PXLayout.XXS_MARGIN),
                                     PXLayout.pinLeft(view: imageContainerView, withMargin: PXLayout.XXS_MARGIN),
                                     PXLayout.pinRight(view: titleLabel, withMargin: PXLayout.XXS_MARGIN),
                                     PXLayout.put(view: imageContainerView, leftOf: titleLabel, withMargin: PXLayout.XXS_MARGIN, relation: .equal),
                                     PXLayout.centerVertically(view: imageContainerView, to: titleLabel)]
        horizontalLayoutConstraints.append(contentsOf: horizontalConstraints)

        verticalLayoutConstraints.removeAll()
        let verticalConstraints = [PXLayout.pinBottom(view: containerView),
                                   PXLayout.centerHorizontally(view: containerView),
                                   PXLayout.centerHorizontally(view: imageContainerView),
                                   PXLayout.pinTop(view: imageContainerView, withMargin: PXLayout.XXS_MARGIN),
                                   PXLayout.centerHorizontally(view: titleLabel),
                                   PXLayout.put(view: titleLabel, onBottomOf: imageContainerView, withMargin: PXLayout.XXS_MARGIN),
                                   PXLayout.pinBottom(view: titleLabel, withMargin: PXLayout.XXS_MARGIN),
                                   PXLayout.matchWidth(ofView: containerView)]
        verticalLayoutConstraints.append(contentsOf: verticalConstraints)
    }

    mutating func makeConstraints(_ containerView: UIView, _ imageContainerView: UIView, _ titleLabel: UILabel, _ subTitleLabel: UILabel) {
        horizontalLayoutConstraints.removeAll()
        let horizontalConstraints = [PXLayout.pinBottom(view: containerView),
                                     PXLayout.pinLeft(view: containerView, withMargin: PXLayout.XL_MARGIN),
                                     PXLayout.pinTop(view: imageContainerView, withMargin: PXLayout.XXS_MARGIN),
                                     PXLayout.pinBottom(view: imageContainerView, withMargin: PXLayout.XXS_MARGIN),
                                     PXLayout.pinLeft(view: imageContainerView, withMargin: PXLayout.XXS_MARGIN),
                                     PXLayout.pinRight(view: titleLabel, withMargin: PXLayout.XXS_MARGIN),
                                     PXLayout.put(view: imageContainerView, leftOf: titleLabel, withMargin: PXLayout.XXS_MARGIN, relation: .equal),
                                     PXLayout.pinBottom(view: titleLabel, to: subTitleLabel, withMargin: PXLayout.XS_MARGIN),
                                     PXLayout.pinLeft(view: subTitleLabel, to: titleLabel, withMargin: 0),
                                     PXLayout.pinTop(view: titleLabel, to: imageContainerView, withMargin: 0)
        ]
        horizontalLayoutConstraints.append(contentsOf: horizontalConstraints)

        verticalLayoutConstraints.removeAll()
        let verticalConstraints = [PXLayout.pinBottom(view: containerView),
                                   PXLayout.centerHorizontally(view: containerView),
                                   PXLayout.centerHorizontally(view: imageContainerView),
                                   PXLayout.pinTop(view: imageContainerView, withMargin: PXLayout.XXS_MARGIN),
                                   PXLayout.centerHorizontally(view: titleLabel),
                                   PXLayout.put(view: titleLabel, onBottomOf: imageContainerView, withMargin: PXLayout.XXS_MARGIN),
                                   PXLayout.centerHorizontally(view: subTitleLabel),
                                   PXLayout.put(view: subTitleLabel, onBottomOf: titleLabel, withMargin: PXLayout.XXXS_MARGIN),
                                   PXLayout.pinBottom(view: subTitleLabel, withMargin: PXLayout.XXS_MARGIN),
                                   PXLayout.matchWidth(ofView: containerView)]
        verticalLayoutConstraints.append(contentsOf: verticalConstraints)
    }
}

// MARK: Publics
extension PXOneTapHeaderMerchantLayout {
    func getLayoutType() -> LayoutType {
        return layoutType
    }

    func getHorizontalContrainsts() -> [NSLayoutConstraint] {
        return horizontalLayoutConstraints
    }

    func getVerticalContrainsts() -> [NSLayoutConstraint] {
        return verticalLayoutConstraints
    }
}
