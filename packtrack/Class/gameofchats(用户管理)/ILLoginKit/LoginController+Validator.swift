//
//  LoginController+Validator.swift
//  packtrack
//
//  Created by ksymac on 2017/12/02.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

extension LoginController {
    func setupValidation() {
        setupValidationOn(field: nameTextField, rules: ValidationService.nameRules)
        setupValidationOn(field: emailTextField, rules: ValidationService.emailRules)
        setupValidationOn(field: passwordTextField, rules: ValidationService.passwordRules)
    }
    func setupValidationOn(field: SkyFloatingLabelTextField, rules: ValidationRuleSet<String>) {
        field.validationRules = rules
        field.validateOnInputChange(enabled: true)
        field.validationHandler = validationHandlerFor(field: field)
    }
    func validationHandlerFor(field: SkyFloatingLabelTextField) -> ((ValidationResult) -> Void) {
        return { result in
            switch result {
            case .valid:
//                guard self.loginAttempted == true else {
//                    break
//                }
                field.errorMessage = nil
            case .invalid(let errors):
//                guard self.loginAttempted == true else {
//                    break
//                }
                if let errors = errors as? [ValidationError] {
                    field.errorMessage = errors.first?.message
                }
            }
        }
    }
    
    func validateFields(isRigester: Bool, success: () -> Void) {
        var errorFound = false
        var fields: Array<SkyFloatingLabelTextField> = []
        if isRigester {
            fields = [self.nameTextField,self.emailTextField,self.passwordTextField]
        }else{
            fields = [self.emailTextField,self.passwordTextField]
        }
        for field in fields {
            let result = field.validate()
            switch result {
            case .valid:
                field.errorMessage = nil
            case .invalid(let errors):
                errorFound = true
                if let errors = errors as? [ValidationError] {
                    field.errorMessage = errors.first?.message
                }
            }
        }
        if !errorFound {
            success()
        }
    }
    func validateFields_ForgotPassword(success: () -> Void) {
        var errorFound = false
        var fields: Array<SkyFloatingLabelTextField> = []
        fields = [self.emailTextField]
        for field in fields {
            let result = field.validate()
            switch result {
            case .valid:
                field.errorMessage = nil
            case .invalid(let errors):
                errorFound = true
                if let errors = errors as? [ValidationError] {
                    field.errorMessage = errors.first?.message
                }
            }
        }
        if !errorFound {
            success()
        }
    }
}
