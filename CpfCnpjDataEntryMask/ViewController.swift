//
//  ViewController.swift
//  CpfCnpjDataEntryMask
//
//  Created by Marcelo Sampaio on 07/01/19.
//  Copyright © 2019 EIG Mercados. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    
    // MARK: - Outlets
    @IBOutlet weak var cpfCnpj: UITextField!
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cpfCnpj.delegate = self
    }
    
    // MARK: - UI Actions
    @IBAction func goAction(_ sender: Any) {
        if (cpfCnpj.text?.isValidCnpj())! {
            view.alert(msg: "👍 CNPJ OK !", sender: self)
        }else{
            view.alert(msg: "❌ CNPJ não válido!", sender: self)
        }
    }
    
    // MARK: - Text Field Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var updatedText = textField.text!
        
        if range.location == 14  && range.length == 0 {
            updatedText = formatTextField(true)
        }else if range.location == 14  && range.length == 1 {
            updatedText = formatTextField(false)
        }
        
        if range.location < 13 {
            // CPF Mask
            if (range.location == 3 || range.location == 7 || range.location == 11) && range.length == 0 {
                if range.location < 11 {
                    updatedText.append(".")
                }else{
                    updatedText.append("-")
                }
                
            }
        }else{
            // CNPJ Mask
            if (range.location == 2 || range.location == 6 || range.location == 10 || range.location == 15) && range.length == 0 {
                if range.location == 2 || range.location == 6 {
                    updatedText.append(".")
                }else if range.location == 10 {
                    updatedText.append("/")
                }else if range.location == 15 {
                    updatedText.append("-")
                }
                
            }
        }
        
        

        updateTextField(updatedText)
        
        
        print("👉 range location: \(range.location)")
        if range.location < 18 {
            return true
        }else{
            return false
        }
        
    }
    

    
    // MARK: Formatter
    private func updateTextField(_ input: String) {
        cpfCnpj.text = input
    }
    private func formatTextField(_ isCnpj: Bool) -> String {
        let cnpj = cpfCnpj.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        var cnpjClean = cnpj.replacingOccurrences(of: ".", with: "")
        cnpjClean = cnpjClean.replacingOccurrences(of: "-", with: "")
        cnpjClean = cnpjClean.replacingOccurrences(of: "/", with: "")
        if isCnpj {
            return cnpjFormat(cnpjClean)
        }else{
            return cpfFormat(cnpjClean)
        }
        
    }
    
    private func cpfFormat(_ input: String) -> String {
        var result = String()
        var i = 1
        var editChar = String()
        for char in input {
            if i == 3 || i == 6 {
                editChar = "."
            }
            if i == 9 {
                editChar = "-"
            }
            result = result + "\(char)" + editChar
            i = i + 1
            editChar = String()
        }
        
        return result
    }
    
    private func cnpjFormat(_ input: String) -> String {
        var result = String()
        var i = 1
        var editChar = String()
        for char in input {
            if i == 2 || i == 5 {
                editChar = "."
            }
            if i == 8 {
                editChar = "/"
            }
            if i == 12 {
                editChar = "-"
            }
            result = result + "\(char)" + editChar
            i = i + 1
            editChar = String()
        }
        
        return result
    }
    
    
}


