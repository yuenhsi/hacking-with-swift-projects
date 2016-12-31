//: Playground - noun: a place where people can play

import UIKit

extension Int {
    func plusOne() -> Int {
        return self + 1
    }
}

extension Int {
    mutating func plusOneMutate() {
        self += 1
    }
}

var myInt = 0
myInt.plusOne()
myInt
myInt.plusOneMutate()
myInt

extension Int {
    func squared() -> Int {
        return self * self
    }
}

let i: Int = 8
print(i.squared())

let j: UInt64 = 8
//print(j.squared())

extension Integer {
    func squaredDataType() -> Self {
        return self * self
    }
}

let k: UInt64 = 8
print(k.squaredDataType())
