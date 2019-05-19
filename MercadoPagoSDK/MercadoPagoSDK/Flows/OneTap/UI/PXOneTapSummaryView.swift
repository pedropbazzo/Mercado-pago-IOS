//
//  PXOneTapSummaryView.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 18/12/2018.
//

import UIKit

class PXOneTapSummaryView: PXComponentView {
    private var data: [OneTapHeaderSummaryData] = []

    init(data: [OneTapHeaderSummaryData] = []) {
        self.data = data
        super.init()
        render()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render() {
        self.removeAllSubviews()
        self.pinContentViewToBottom()
        self.backgroundColor = ThemeManager.shared.navigationBar().backgroundColor

        for row in self.data {
            let margin: CGFloat = row.isTotal ? PXLayout.S_MARGIN : PXLayout.XXS_MARGIN
            let rowView = self.getSummaryRowView(with: row)

            if row.isTotal {
                let separatorView = UIView()
                separatorView.backgroundColor = ThemeManager.shared.boldLabelTintColor()
                separatorView.alpha = 0.1
                separatorView.translatesAutoresizingMaskIntoConstraints = false
                self.addSubviewToBottom(separatorView, withMargin: margin)
                PXLayout.setHeight(owner: separatorView, height: 1).isActive = true
                PXLayout.pinLeft(view: separatorView, withMargin: PXLayout.M_MARGIN).isActive = true
                PXLayout.pinRight(view: separatorView, withMargin: PXLayout.M_MARGIN).isActive = true
            }

            self.addSubviewToBottom(rowView, withMargin: margin)

            PXLayout.centerHorizontally(view: rowView).isActive = true
            PXLayout.pinLeft(view: rowView, withMargin: 0).isActive = true
            PXLayout.pinRight(view: rowView, withMargin: 0).isActive = true
        }

        self.pinLastSubviewToBottom(withMargin: PXLayout.S_MARGIN)?.isActive = true
    }

    func update(_ newData: [OneTapHeaderSummaryData], hideAnimatedView: Bool = false) {
        self.data = newData
        self.render()
        if hideAnimatedView {
            self.hideAnimatedViews()
        }
    }

    func hideAnimatedViews() {
        for view in self.getSubviews() {
            if view.pxShouldAnimatedOneTapRow {
                view.isHidden = true
            }
        }
    }

    func showAnimatedViews() {
        for view in self.getSubviews() {
            if view.pxShouldAnimatedOneTapRow {
                view.isHidden = false
            }
        }
    }

    func getSummaryRowView(with data: OneTapHeaderSummaryData) -> UIView {
        let rowView = PXOneTapSummaryRowView(data: data)
        return rowView
    }
}
