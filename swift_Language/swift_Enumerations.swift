import Foundation

// enumeration (열거형)
// 열거형은 관련된 값들로 이뤄진 그룹을 공통의 type으로 선언해 형 안정성을 보장하는 방법으로 코드를 다룰 수 있도록 한다.
// 다른 언어들과 달리 interger type 뿐만 아니라 다양한 type에 대해 열거형을 지정하고 사용할 수 있다.

// Enumeration syntax (열거형 문법)
// enum keyward를 통해 열거형을 정의한다.
// swift에서는 case값을 선언해도 다른 언어들처럼 integer 값들이 할당되지 않는다.
enum CompassPoint{
    case north
    case south
    case east
    case west
}
// 여러 case를 ,를 이용해 한 줄에 적을 수 있다.
enum Planet {
    case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}
var directionToHead = CompassPoint.west
// 한번 선언되고 난 이후에는 syntax를 생략할 수 있다.
directionToHead = .east

// Switch 문에서 enumeration 값을 매칭하기
directionToHead = .south
switch directionToHead {
case .north:
    print("Lots of planets have a north")
case .south:
    print("Watch out for penguins")
case .east:
    print("Where the sun rises")
case .west:
    print("Where the skies are blue")
}
// 기본적으로 enumeration value를 case 값의 인자로 사용할 때, 모든 case에 대해서 작성을 해주어야 한다.
// 만약 여의치 않은 경우 다른 모든 case들에 대해서 default 값으로 정의해주어야 한다.
let somePlanet = Planet.earth
switch somePlanet {
case .earth:
    print("Mostly harmless")
default:
    print("Not a safe place for humans")
}

// Associate Values (관련 값)
// 열거형의 각 case에 custom type의 추가적인 정보를 저장할 수 있다.
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}
var productBarcode = Barcode.upc(8, 85909, 51226, 3)
productBarcode = .qrCode("ABCDEFGHIJKLMNOP")

// switch case 문에서 관련 값을 인자로 사용하는 경우 상수나 변수 값으로 사용할 수 있다.
switch productBarcode {
case .upc(let numberSystem, let manufacturer, let product, let check):
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrCode(let productCode):
    print("QR code: \(productCode).")
}
// Prints "QR code: ABCDEFGHIJKLMNOP."

// case안의 값이 전부 상수이거나 변수이면 공통된 값을 case 뒤에 선언해서 보다 간결하게 기술할 수 있다.
switch productBarcode {
case let .upc(numberSystem, manufacturer, product, check):
    print("UPC : \(numberSystem), \(manufacturer), \(product), \(check).")
case let .qrCode(productCode):
    print("QR code: \(productCode).")
}
// Prints "QR code: ABCDEFGHIJKLMNOP."

// Raw values (Raw 값)
// enum을 초기 선언 시 초기화 값을 지정할 수 있음
// 초기 값을 선언 시 꼭 형을 지정해주어야 한다.
// 즉, type inferrence가 안된다.
// 마지막으로 각 case의 초기 값은 중복 값이 아니어야 한다.
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}

// 암시적으로 할당 된 Associate Raw Values
enum Planet_2: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}
enum CompassPoint_2: String {
    case north, south, east, west
}
// Int 값은 1로 할당해두면 뒤로 자동 할당 된다.
var myPlanet = Planet_2.earth
print(myPlanet.rawValue)
// String 값은 raw value가 그냥 이름으로 할당된다.
var compass = CompassPoint_2.north
print(compass.rawValue)

// Raw 값을 이용한 초기화 (Initializing with Raw value)
// 만약 존재하지 않는 rawValue에 대해 초기화를 진행하려 하면 초기화에 실패할 수 있다.
let possiblePlanet = Planet_2(rawValue: 7)

// 존재하지 않는 rawValue가 있을 것을 고려해 방어 코드를 생성하는 방법
let positionToFind = 11
if let somePlanet = Planet_2(rawValue: positionToFind) {
    switch somePlanet {
    case .earth:
        print("Mostly harmless")
    default:
        print("Not a safe place for humans")
    }
} else {
    print("There isn't a planet at position \(positionToFind)")
}

// Recursive Enumeration (재귀 열거자)
// 재귀 열거자는 다른 열거 인스턴스를 관계 값으로 갖는 열거형이다.
// 재귀 열거자는 case는 앞에 indirect keyword를 붙여 사용한다.
enum ArithmeticExpression {
    case number(Int)
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}
// 만약 관계 값을 갖는 모든 열거형 case에 indirect를 표시하고 싶으면 enum 앞에 indirect keyword를 표시하면 된다.
// indirect enum ArithmeticExpression{
//  statement
// }
let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))

// 재귀 열거자를 처리하는 함수
func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case let .number(value):
        return value
    case let .addition(left, right):
        return evaluate(left) + evaluate(right)
    case let .multiplication(left, right):
        return evaluate(left) * evaluate(right)
    }
}
print(evaluate(product))
