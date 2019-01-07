//
//  String+Utils.swift
//  CpfCnpjDataEntryMask
//
//  Created by Marcelo Sampaio on 07/01/19.
//  Copyright © 2019 EIG Mercados. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    
    // MARK: - Email Validation
    func isValidEmail() -> Bool? {
        let trimmedText = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedText.isEmpty {
            return false
        }
        
        guard let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return false
        }
        
        let range = NSMakeRange(0, NSString(string: trimmedText).length)
        let allMatches = dataDetector.matches(in: trimmedText,
                                              options: [],
                                              range: range)
        
        if allMatches.count == 1,
            allMatches.first?.url?.absoluteString.contains("mailto:") == true
        {
            return true
        }
        return false
    }
    
    
    // MARK: - Password Validation
    func isValidPassword() -> Bool? {
        let password = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if password.isEmpty{
            return false
        }
        if password.range(of:" ") != nil {
            return false
        }
        
        return true
    }
    
    // MARK: - Name Validation
    func isValidName() -> Bool? {
        let name = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty{
            return false
        }
        
        return true
    }
    
    // MARK: - Cpf
    func isValidCpf() -> Bool {
        let cpf = self.trimmingCharacters(in: .whitespacesAndNewlines)
        var cpfClean = cpf.replacingOccurrences(of: ".", with: "")
        cpfClean = cpfClean.replacingOccurrences(of: "-", with: "")
        
        if cpfClean.isEmpty || isFakeCpf(cpfClean){
            return false
        }
        
        var i = 0
        var firstSum = 0
        var secondSum = 0
        var firstDigit = 0
        var secondDigit = 0
        var firstDigitCheck = 0
        var secondDigitCheck = 0
        
        for character in cpfClean {
            let value = Int(character.description) ?? 0
            
            // step 1
            if i <= 8 {
                let sumarizer = (value * (10 - i))
                firstSum += sumarizer
            }
            // step2
            if i <= 9 {
                let sumarizer = (value * (11 - i))
                secondSum += sumarizer
            }
            //
            if i == 9 {
                firstDigitCheck = value
            }else if i == 10 {
                secondDigitCheck = value
            }
            // digit control
            i = i + 1
        }
        
        // with firstSum I'll get firstDigit
        if (firstSum % 11 < 2) {
            firstDigit = 0;
        }
        else {
            firstDigit = 11 - (firstSum % 11);
        }
        
        // with secondSum I'll get secondDigit
        if (secondSum % 11 < 2) {
            secondDigit = 0;
        }
        else {
            secondDigit = 11 - (secondSum % 11)
        }
        
        // validate digits
        if ((firstDigit == firstDigitCheck) && (secondDigit == secondDigitCheck)) {
            return true;
        }
        
        
        return false
    }
    
    // Prevent valid digits to accept as true
    private func isFakeCpf(_ cpf: String) -> Bool {
        if (cpf == "00000000000" || cpf == "11111111111" || cpf == "22222222222" || cpf == "33333333333" || cpf == "44444444444" || cpf == "55555555555" || cpf == "66666666666" || cpf == "77777777777" || cpf == "88888888888" || cpf == "99999999999") {
            return true
        }
        return false
    }
    
    func isValidCnpj() -> Bool {
        let cnpj = self.trimmingCharacters(in: .whitespacesAndNewlines)
        var cnpjClean = cnpj.replacingOccurrences(of: ".", with: "")
        cnpjClean = cnpjClean.replacingOccurrences(of: "-", with: "")
        cnpjClean = cnpjClean.replacingOccurrences(of: "/", with: "")
        
        if cnpjClean.isEmpty || cnpjClean == "00000000000000" {
            return false
        }
        
        var i = 0
        var firstSum = 0
        var secondSum = 0
        var firstDigit = 0
        var secondDigit = 0
        var firstDigitCheck = 0
        var secondDigitCheck = 0
        
        let firstMultipliers : [Int] = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
        let secondMultipliers : [Int] = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
        
        for character in cnpjClean {
            
            let value = Int(character.description) ?? 0
            
            // step 1
            if i <= 11 {
                let sumarizer = (value * firstMultipliers[i])
                firstSum += sumarizer
            }
            // step2
            if i <= 12 {
                let sumarizer = (value * secondMultipliers[i])
                secondSum += sumarizer
            }
            //
            if i == 12 {
                firstDigitCheck = value
            }else if i == 13 {
                secondDigitCheck = value
            }
            // digit control
            i = i + 1
        }
        // with firstSum I'll get firstDigit
        if (firstSum % 11 < 2) {
            firstDigit = 0;
        }
        else {
            firstDigit = 11 - (firstSum % 11);
        }
        
        // with secondSum I'll get secondDigit
        if (secondSum % 11 < 2) {
            secondDigit = 0;
        }
        else {
            secondDigit = 11 - (secondSum % 11)
        }
        
        // validate digits
        if ((firstDigit == firstDigitCheck) && (secondDigit == secondDigitCheck)) {
            return true;
        }
        
        return false
    }
    
}

