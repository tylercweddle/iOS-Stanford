//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Tyler Christopher Weddle on 2/7/18.
//  Copyright © 2018 Tyler Weddle. All rights reserved.
//

import Foundation

func multiply(op1: Double, op2: Double) -> Double{
    return op1 * op2
}

func divide(op1: Double, op2: Double) -> Double{
    return op1 / op2
}

func add(op1: Double, op2: Double) -> Double {
    return op1 + op2
}

func subtract(op1: Double, op2: Double) -> Double {
    return op1 - op2
}

class CalculatorModel {
    
    private var accumulator: Double = 0.0
    private var currentProgram = [AnyObject]()
    
    func setOperand(operand: Double) {
        accumulator = operand
        currentProgram.append(operand as AnyObject)
    }
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case Clear
    }
    
    struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    var operations: Dictionary<String,Operation> = [
        "clr" : Operation.Clear,
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "sqrt" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "sin" : Operation.UnaryOperation(sin),
        "+" : Operation.BinaryOperation(add),
        "-" : Operation.BinaryOperation(subtract),
        "*" : Operation.BinaryOperation(multiply),
        "/" : Operation.BinaryOperation(divide),
        "=" : Operation.Equals
    ]
    
    func performOperation(symbol: String) {
        currentProgram.append(symbol as AnyObject)
        if let operation = operations[symbol] {
            switch operation {
            case .Clear:
                accumulator = 0
                break
            case .Constant(let v):
                accumulator = v
                break
            case .UnaryOperation(let f):
                accumulator = f(accumulator)
                break
            case .BinaryOperation(let f):
                pending = PendingBinaryOperationInfo(binaryFunction: f, firstOperand: accumulator)
                break
            case .Equals:
                if pending != nil {
                    accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
                    pending = nil
                }
                break
            }
        }
    }
    //Similar to #define PropertyList = AnyObject
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return currentProgram as CalculatorModel.PropertyList
        }
        set {
            accumulator = 0.0
            pending = nil
            currentProgram.removeAll()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand: operand)
                    } else if let operand = op as? String {
                        performOperation(symbol: operand)
                    }
                }
            }
        }
    }
    var result: Double {
        get {
            return accumulator
        }
    }
}
