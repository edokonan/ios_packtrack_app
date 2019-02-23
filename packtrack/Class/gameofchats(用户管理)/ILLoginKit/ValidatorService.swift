//
//  ValidatorService.swift
//  Pods
//
//  Created by Daniel Lozano Valdés on 1/4/17.
//
//

import Foundation
//import Validator

enum ValidationError: String, Error {

    case invalidName = " 無効な名前(4~20桁をご入力)"//"Invalid name"
    case invalidEmail = " 無効なメールアドレス"//"Invalid email address"
    case passwordLength = " ログインパスワードの桁数は8桁以上です"
    case passwordAlphaNumber = " 英数字混在で入力して下さい。"
    case passwordNotEqual = " パスワードに誤りがあります。"

    var message: String {
        return self.rawValue
    }
}

public struct FullNameRule: ValidationRule {

    public typealias InputType = String

    public var error: Error

    public init(error: Error) {
        self.error = error
    }

    public func validate(input: String?) -> Bool {
        guard let input = input else {
            return false
        }
//        guard input.characters.count < 4, input.characters.count > 20 else {
//            return false
//        }
        if input.isEmpty {
            return false
        }
        if input.characters.count < 3 {
            return false
        }
        if input.characters.count > 20 {
            return false
        }
//        let components = input.components(separatedBy: " ")
//        guard components.count > 1 else {
//            return false
//        }
//        guard let first = components.first, let last = components.last else {
//            return false
//        }
//        guard first.characters.count > 1, last.characters.count > 1 else {
//            return false
//        }３
        return true
    }
}

public enum CharacterTypeValidationPattern: ValidationPattern {
    case alpha
    case alphaNumeric
    case numeric
    case mustAlphaNumeric
    
    public var pattern: String {
        switch self {
        case .alpha: return "^[A-Za-z]+$"
        case .alphaNumeric :return "^[A-Za-z0-9]+$"
        case .numeric :return "^[0-9]+$"
        case .mustAlphaNumeric :return "^(?=.*?[A-Za-z])(?=.*?[0-9]).{8,}$"
        }
    }
}
/**
 Validation rule for userId.
 */
public struct ValidationPassword: ValidationRule {
    public typealias InputType = String
    public var error: Error
    public let lengthRule: ValidationRuleLength
    public let patternRule: ValidationRulePattern
    public init(error: Error) {
        self.error = error
        self.lengthRule = ValidationRuleLength(min: 0, max: 16, error: self.error)
        self.patternRule =
            ValidationRulePattern(pattern: CharacterTypeValidationPattern.mustAlphaNumeric, error: self.error)
    }
    public func validate(input: String?) -> Bool {
//        return self.lengthRule.validate(input: input) && self.patternRule.validate(input: input)
        let ret = self.patternRule.validate(input: input)
//        print(ret)
        return ret
    }
}


struct ValidationService {
    static var emailRules: ValidationRuleSet<String> {
        var emailRules = ValidationRuleSet<String>()
        emailRules.add(rule: emailRule)
        return emailRules
    }
    
    static var passwordRules: ValidationRuleSet<String> {
        var passwordRules = ValidationRuleSet<String>()
        passwordRules.add(rule: ValidationRuleLength(min: 8, error: ValidationError.passwordLength))
        passwordRules.add(rule: ValidationPassword(error: ValidationError.passwordAlphaNumber))
        return passwordRules
    }

    static var nameRules: ValidationRuleSet<String> {
        var nameRules = ValidationRuleSet<String>()
        nameRules.add(rule: FullNameRule(error: ValidationError.invalidName))
        return nameRules
    }

    // MARK: - Private
    private static var emailRule: ValidationRulePattern {
        return ValidationRulePattern(pattern: EmailValidationPattern.standard,
                                     error: ValidationError.invalidEmail)
    }

}
