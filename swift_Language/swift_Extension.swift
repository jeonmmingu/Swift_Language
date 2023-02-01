import Foundation

// Extensions (익스텐션)

// 익스텐션을 이용해 클래스, 구조체, 열거형 혹은 프로토콜 타입에 기능을 추가할 수 있다.
// 1. 계산된 인스턴스 프로퍼티와 계산된 타입 프로퍼티 추가
// 2. 인스턴스 메소드와 타입 메소드의 추가
// 3. 새로운 이니셜라이저 제공
// 4. 서브스크립트 정의
// 5. 중첩 타입의 선언과 사용
// 6. 툭정 프로토콜을 따르는 타입 만들기


/* 기본 형태
 
 extension SomeType {
     // new functionality to add to SomeType goes here
 }
 
 extension SomeType: SomeProtocol, AnotherProtocol {
     // implementation of protocol requirements goes here
 }
 
 */


// 계산된 프로퍼티 (Computed Properties)
// Swift의 내장 타입인 Double에 5개의 계산된 인스턴스 프로퍼티를 추가하는 예제이다.
extension Double {
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}
let oneInch = 25.4.mm
print("One inch is \(oneInch) meters")
// Prints "One inch is 0.0254 meters"
let threeFeet = 3.ft
print("Three feet is \(threeFeet) meters")
// Prints "Three feet is 0.914399970739201 meters"
let aMarathon = 42.km + 195.m
print("A marathon is \(aMarathon) meters long")
// Prints "A marathon is 42195.0 meters long"
// 익스텐션은 새 계산된 값은 추가할 수 있지만 새로운 저장된 프로퍼티나 프로퍼티 옵저버를 추가할 수는 없다.


// Initializer
// Extension은 (New Convenience initializer)을 추가할 수는 있지만 지정된 이니셜라이저 (New designated initializers)나 디이니셜라이저(New deinitializer)는 추가 할 수 없다.
// Desinated initializer은 반드시 Original Class에서 작성해야한다.

// 그리고 만약 다른 모듈에 선언되어 있는 구조체에 이니셜라이저를 추가하는 익스텐션을 사용한다면, 새로운 이니셜라이저는 모듈에 정의된 이니셜라이저를 호출하기 전까지 self에 접근할 수 없다. -> origianl initializer가 호출된 이후 시점에 호출

// Example
// Rect 구조체에서는 모든 프로퍼티의 기본 값을 제공하기 때문에 기본 이니셜라이저와 멤버쪽 이니셜라이저를 자동으로 제공 받아 사용할 수 있다.
struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
}

let defaultRect = Rect() // 0.0 , 0.0, 0.0, 0.0 이런 식으로 진행
let memberwiseRect = Rect(origin: Point(x: 2.0, y: 2.0),
   size: Size(width: 5.0, height: 5.0)) // memberwise한 방식으로 사용

// Add Extention to provide additional intializer
extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}
let centerRect = Rect(center: Point(x: 4.0, y: 4.0),
                      size: Size(width: 3.0, height: 3.0))
// centerRect's origin is (2.5, 2.5) and its size is (3.0, 3.0)

// 익스텐션에서 이니셜라이저를 제공할 때 각 인스턴스가 이니셜라이저가 한번 완료되면 완전히 초기화 되도록 확실히 해야한다.


// Methods
// 익스텐션을 이용해 존재하는 타입에 인스턴스 메소드나 타입 메소드를 추가할 수 있다.

// 다음 예제는 Int 타입에 repetitions라는 인스턴스 메소드를 추가한 예제이다.
extension Int {
    func repetitions(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
}

// 특정 타입의 계산된 프로퍼티에 대해 이런 식으로 Extension을 활용하는 것은 활용도가 매우 높을 것 같다.
3.repetitions {
    print("Hello!")
}
// Hello!
// Hello!
// Hello!


// Mutating Instance Methods
// Extension에서 추가된 모스드는 인스턴스 self를 변경할 수 있다.
// 원본 구현에서 mutating 메소드와 같이 반드시 mutating으로 선언 되어야한다.

// New mutating 메소드를 추가하고 호출하는 예제
// Really impressive method!!
extension Int {
    mutating func square() {
        self = self * self
    }
}
var someInt = 3
someInt.square()
// someInt is now 9


// SubScripts - 서브스크립트
extension Int {
    subscript(digitIndex: Int) -> String {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return "\(digitIndex)번째 숫자: \((self / decimalBase) % 10)"
        // 10 * n번째 수로 현재 수를 나눈 것의 나머지
      // 1인 경우 746381295 % 10 -> 5가 나머지
      // 2인 경우 746381295 % 10 -> 9가 나머지
    }
}
print(746381295[0])
// returns 5
print(746381295[1])
// returns 9
print(746381295[2])
// returns 2
print(746381295[8])
// returns 7
print(746381295[9])
// 범위를 넘어가면 0을 반환한다.


// Nested Type
extension Int {
    enum Kind {
        case negative, zero, positive
    }
    var kind: Kind {
        switch self {
        case 0:
            return .zero
        case let x where x > 0:
            return .positive
        default:
            return .negative
        }
    }
}
print((-615).kind)
print(0.kind)
print(8.kind)
// 위의 Nested Extension을 활용해 만든 함수이다.
// Integer의 kind를 출력하도록 하는 함수.
func printIntegerKinds(_ numbers: [Int]) {
    for number in numbers {
        switch number.kind {
        case .negative:
            print("- ", terminator: "")
        case .zero:
            print("0 ", terminator: "")
        case .positive:
            print("+ ", terminator: "")
        }
    }
    print("")
}
printIntegerKinds([3, 19, -27, 0, -6, 0, 7])
// Prints "+ + - 0 - 0 + "
