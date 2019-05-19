//
//  Localizator.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 2/8/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

// Only for MoneyIn custom verb support.
/// :nodoc
public enum PXCustomTranslationKey: String {
    case total_to_pay = "total_row_title_default"
    case total_to_pay_onetap = "onetap_purchase_summary_total"
    case how_to_pay = "¿Cómo quieres pagar?"
}

internal class Localizator {
    static let sharedInstance = Localizator()
    private var language: String = NSLocale.preferredLanguages[0]
    private var customTrans: [PXCustomTranslationKey: String]?
}

// MARK: Privates.
internal extension Localizator {
    private func localizableDictionary() -> NSDictionary? {
        let languageBundle = Bundle(path: getLocalizedPath())
        let languageID = getParentLanguageID()

        if let path = languageBundle?.path(forResource: "Localizable_\(languageID)", ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        return NSDictionary()
    }

    private func parentLocalizableDictionary() -> NSDictionary? {
        let languageBundle = Bundle(path: getParentLocalizedPath())
        let languageID = getParentLanguageID()

        if let path = languageBundle?.path(forResource: "Localizable_\(languageID)", ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        } else if let path = languageBundle?.path(forResource: "Localizable_es", ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        fatalError("Localizable file NOT found")
    }
}

// MARK: Getters/ Setters
internal extension Localizator {
    func setLanguage(language: PXLanguages) {
        self.language = language.rawValue
        self.customTrans = nil
    }

    func setLanguage(string: String) {
        self.language = string
        self.customTrans = nil
    }

    func getLanguage() -> String {
        return language
    }

    // MoneyIn Custom verb support.
    func setLanguage(_ string: String, _ customTranslations: [PXCustomTranslationKey: String]) {
        self.language = string
        self.customTrans = customTranslations
    }
}

// MARK: Localization Paths
extension Localizator {
    private func getLocalizedID() -> String {
        let bundle = ResourceManager.shared.getBundle() ?? Bundle.main
        let currentLanguage = getLanguage()
        let currentLanguageSeparated = currentLanguage.components(separatedBy: "-").first
        if bundle.path(forResource: currentLanguage, ofType: "lproj") != nil {
            return currentLanguage
        } else if let language = currentLanguageSeparated, bundle.path(forResource: language, ofType: "lproj") != nil {
            return language
        } else {
            return "es"
        }
    }

    private func getParentLanguageID() -> String {
        return getLanguage().components(separatedBy: "-").first ?? "es"
    }

    func getLocalizedPath() -> String {
        let bundle = ResourceManager.shared.getBundle() ?? Bundle.main
        let pathID = getLocalizedID()
        return bundle.path(forResource: pathID, ofType: "lproj")!
    }

    private func getParentLocalizedPath() -> String {
        let bundle = ResourceManager.shared.getBundle() ?? Bundle.main
        let pathID = getParentLanguageID()
        if let parentPath = bundle.path(forResource: pathID, ofType: "lproj") {
            return parentPath
        }
        return bundle.path(forResource: "es", ofType: "lproj")!
    }

    func localize(string: String) -> String {
        guard let localizedStringDictionary = localizableDictionary()?.value(forKey: string) as? NSDictionary, let localizedString = localizedStringDictionary.value(forKey: "value") as? String else {

            let parentLocalizableDictionary = self.parentLocalizableDictionary()?.value(forKey: string) as? NSDictionary
            if let parentLocalizedString = parentLocalizableDictionary?.value(forKey: "value") as? String {
                return parentLocalizedString
            }

            #if DEBUG
            assertionFailure("Missing translation for: \(string)")
            #endif

            return string
        }

        return localizedString
    }

    func getCustomTrans(_ targetKey: String) -> String? {
        if let cVerbs = customTrans {
            for (key, value) in cVerbs {
                if key.rawValue == targetKey {
                    return value
                }
            }
        }
        return nil
    }
}

// MARK: localized capability for Strings.
internal extension String {
    var localized_beta: String {
        if let customTrans = Localizator.sharedInstance.getCustomTrans(self) {
            return customTrans
        }
        return Localizator.sharedInstance.localize(string: self)
    }

    var localized: String {
        if let customTrans = Localizator.sharedInstance.getCustomTrans(self) {
            return customTrans
        }
        var bundle: Bundle? = ResourceManager.shared.getBundle()
        if bundle == nil {
            bundle = Bundle.main
        }
        if let languageBundle = Bundle(path: Localizator.sharedInstance.getLocalizedPath()) {
            return languageBundle.localizedString(forKey: self, value: "", table: nil)
        }
        return self
    }
}
