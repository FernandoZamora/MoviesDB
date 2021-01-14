//
//  Language.swift
//  Movies DB
//
//  Created by Fernando Zamora on 11/01/21.
//

import Foundation

class Language {
    var currentLanguage: SupportedLanguages = .english
    
    private static let instance = Language()
    
    required internal init(){
    }
    
    class func getInstance() -> Language {
        return Language.instance
    }
    
    enum SupportedLanguages: String {
        case english = "en-US"
        case spanish = "es-MX"
        
        func getLocaleCode() -> String {
            switch self {
            case .english: return "en"
            case .spanish: return "es-419"
            }
        }
    }
}
