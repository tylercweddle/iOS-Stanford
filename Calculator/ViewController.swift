//
//  ViewController.swift
//  Calculator
//
//  Created by Tyler Christopher Weddle on 2/7/18.
//  Copyright © 2018 Tyler Weddle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private var isUserTyping = false
    
    //Display value handler
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBOutlet private weak var display: UILabel!

    @IBAction private func keypadPress(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if isUserTyping {
            let currentDisplayText = display.text!
            display.text = currentDisplayText + digit
        } else {
            display.text = digit
        }
        isUserTyping = true
    }
    
    //Create communication between model and View (this class)
    private var model: CalculatorModel = CalculatorModel()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if isUserTyping {
            model.setOperand(operand: displayValue)
            isUserTyping = false
        }
        isUserTyping = false
        //Check to ensure that sneder.currentTitle is not nil
        if let mathSymbol = sender.currentTitle {
            model.performOperation(symbol: mathSymbol)
        }
        displayValue = model.result
    }
}

