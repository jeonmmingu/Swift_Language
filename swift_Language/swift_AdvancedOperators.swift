import Foundation

// - MARK: Advanced Operators


/* - MARK: Bitwise Basic Operators
 
// - MARK: Bitwise NOT Operators(~)
 ```
 [Syntax]
 let initialBits: UInt8 = 0b00001111
 let invertedBits = ~initialBits  // equals 11110000
 ```
 
 // - MARK: Bitwise AND Operators(&)
 ```
 [Syntax]
 let firstSixBits: UInt8 = 0b11111100
 let lastSixBits: UInt8  = 0b00111111
 let middleFourBits = firstSixBits & lastSixBits  // equals 00111100
 ```
 
 // - MARK: Bitwise OR Operators(|)
 ```
 [Syntax]
 let someBits: UInt8 = 0b10110010
 let moreBits: UInt8 = 0b01011110
 let combinedbits = someBits | moreBits  // equals 11111110
 ```
 
 // - MARK: Bitwise XOR Operators(^)
 1. 두 비트가 같은 경우 0, 다른 경우 1을 반환하는 연산자이다.
 
 ```
 [Syntax]
 let firstBits: UInt8 = 0b00010100
 let otherBits: UInt8 = 0b00000101
 let outputBits = firstBits ^ otherBits  // equals 00010001
 ```
 
*/


/* - MARK: Bitwise Left and Right Shift Operators
 
 ```
 [Syntax]
 let shiftBits: UInt8 = 4   // 00000100 in binary
 shiftBits << 1             // 00001000
 shiftBits << 2             // 00010000
 shiftBits << 5             // 10000000
 shiftBits << 6             // 00000000
 shiftBits >> 2             // 00000001
 ```
 
*/


// - MARK: Operator Methods
// + 연산자에 대한 오버라이딩을 진행해서 vector의 합 연산을 정의할 수 있다.
struct Vector2D {
    var x = 0.0, y = 0.0
}

extension Vector2D {
    static func + (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y + right.y)
    }
}

let vector = Vector2D(x: 3.0, y: 1.0)
let anotherVector = Vector2D(x: 2.0, y: 4.0)
let combinedVector = vector + anotherVector
// combinedVector is a Vector2D instance with values of (5.0, 5.0)


// - MARK: Prefix and Postfix Operators
extension Vector2D {
    static prefix func - (vector: Vector2D) -> Vector2D {
        return Vector2D(x: -vector.x, y: -vector.y)
    }
}

let positive = Vector2D(x: 3.0, y: 4.0)
let negative = -positive
// negative is a Vector2D instance with values of (-3.0, -4.0)
let alsoPositive = -negative
// alsoPositive is a Vector2D instance with values of (3.0, 4.0)


// - MARK: Compound Assignment Operators
extension Vector2D {
    static func += (left: inout Vector2D, right: Vector2D) {
        left = left + right
    }
}

var original = Vector2D(x: 1.0, y: 2.0)
let vectorToAdd = Vector2D(x: 3.0, y: 4.0)
original += vectorToAdd
// original now has values of (4.0, 6.0)


// - MARK: Equivalence Operators
// Swift에서는 등위 연산자의 구현을 자동으로 합성해주기도 한다.
// 1. 구조체가 저장 프로퍼티만을 갖는 경우
// 2. 열거형이 연관 타입만 갖는 경우
// 3. 열거형이 연관 타입이 없는 경우

extension Vector2D: Equatable {
    static func == (left: Vector2D, right: Vector2D) -> Bool {
        return (left.x == right.x) && (left.y == right.y)
    }
}
let twoThree = Vector2D(x: 2.0, y: 3.0)
let anotherTwoThree = Vector2D(x: 2.0, y: 3.0)
if twoThree == anotherTwoThree {
    print("These two vectors are equivalent.")
}
// Prints "These two vectors are equivalent."


// - MARK: Custom Operators
prefix operator +++

extension Vector2D {
    static prefix func +++ (vector: inout Vector2D) -> Vector2D {
        vector += vector
        return vector
    }
}

var toBeDoubled = Vector2D(x: 1.0, y: 4.0)
let afterDoubling = +++toBeDoubled
// toBeDoubled now has values of (2.0, 8.0)
// afterDoubling also has values of (2.0, 8.0)


// - MARK: Precedence for Custom Infix Operators
// x값은 더하고 y값은 빼도록 하는 연산자
infix operator +-: AdditionPrecedence
extension Vector2D {
    static func +- (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y - right.y)
    }
}
let firstVector = Vector2D(x: 1.0, y: 2.0)
let secondVector = Vector2D(x: 3.0, y: 4.0)
let plusMinusVector = firstVector +- secondVector
// plusMinusVector is a Vector2D instance with values of (4.0, -2.0)
