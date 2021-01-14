//
//  String+Localize.swift
//  Movies DB
//
//  Created by Fernando Zamora on 13/01/21.
//

import Foundation

extension String{
    func localized() -> String {
        var bundle:Bundle
        if let path = Bundle.main.path(forResource: Language.getInstance().currentLanguage.getLocaleCode(), ofType: "lproj") {
            bundle = Bundle(path: path)!
        }
        else{
            bundle = .main
        }
        return bundle.localizedString(forKey: self, value: nil, table: nil)
    }
}
