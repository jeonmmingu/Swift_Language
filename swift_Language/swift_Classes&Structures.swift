import Foundation

// 클래스와 구조체의 비교

// 공통점
// 1. 값을 저장하기 위한 프로퍼티 정의
// 2. 기능을 제공하기 위한 메서드 정의
// 3. subscript 정의
// 4. 초기 상태를 설정할 수 있는 initializer 정의
// 5. 기본 구현에서 확장
// 6. 특정한 종류의 표준 기능을 제공하기 위한 프로토콜 순응(conform)

// 차이점 - Class만 가능한 것
// 1. 상속: 클래스의 여러 속성을 다른 클래스에 물려 줌
// 2. 타입 캐스팅: 런타임에 클래스 인스턴스 타입을 확인
// 3. 소멸자: 할당된 자원을 해제시킴
// 4. 참조 카운트: 클래스 인스턴스에 하나 이상의 참조가 가능 (소멸자가 존재하는 이유)

// * 구조체는 다른 코드로 할당되어질 때 항상 복사되어 전달되고, 참조 카운트를 사용하지 않는다.


// Declare syntax
struct Resolution {
    var width = 0
    var height = 0
}
class VideoMode {
    var resolution = Resolution()  // 위 Resolution 구조체를 값으로 사용
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}


// Make instance
let someResolution = Resolution()    // 구조체 인스턴스 생성
let someVideoMode = VideoMode()    // 클래스 인스턴스 생성


// Accessing Properties
// Dot 문법을 통해 인스턴스에 접근 및 수정이 가능하다.
print("The width of someResolution is \(someResolution.width)")
print("The width of someVideoMode is \(someVideoMode.resolution.width)")
someVideoMode.resolution.width = 1280
print("The width of someVideoMode is now \(someVideoMode.resolution.width)")
// objective-C 와는 다르게 Swift는 하위레벨의 구조체 프로퍼티도 직접 설정이 가능하다.
// ex) someVideoMode.resolution.width = 1280


// Memberwise initializers for structure types (구조체형의 멤버 초기화)
// 모든 구조체는 초기화 시 프로퍼티를 선언할 수 있는 초기자를 자동으로 생성해준다.
// 구조체에서만 가능한 기능이다. Class 자료형에서는 불가능.
let vga = Resolution(width: 640, height: 480)


// Structures and Enumeration are Value Types
// 값 타입이라는 의미는 변수나 상수에 할당될 때 복사되서 전달된다는 의미이다.
let hd = Resolution(width: 1920, height: 1080)
var cinema = hd
cinema.width = 2048
print("cinema is now \(cinema.width) pixels wide")
// "cinema is now 2048 pixels wide" 출력
print("hd is still \(hd.width) pixels wide")
// "hd is still 1920 pixels wide" 출력


// Enumeration
enum CompassPoint {
    case north, south, east, west
}
var currentDirection = CompassPoint.west
let rememberedDirection = currentDirection
currentDirection = .east
if rememberedDirection == .west {
    print("The remembered direction is still .west")
}


// Classes are reference Types
// Class는 앞의 두 자료형과 다르게 상수나 변수에 할당하거나 인자로 전달될 때 복사되는 것이 아닌 참조되는 방식을 사용한다.
let tenEighty = VideoMode()
tenEighty.resolution = hd
tenEighty.interlaced = true
tenEighty.name = "1080i"
tenEighty.frameRate = 25.0

let alsoTenEighty = tenEighty
alsoTenEighty.frameRate = 30.0

print("The frameRate property of tenEighty is now \(tenEighty.frameRate)")


// Identity Operators
// Class는 참조 타입이기 때문에 여러 상수와 변수에서 같은 인스턴스를 참조할 수 있다.
// 상수와 변수가 같은 인스턴스를 참조하고 있는지 비교하기 위해 식별 연산자를 사용한다.
// "===" 비교 연산자를 사용하고 주소 값을 비교하는 것이라고 생각하면 편할 것 같다.
if tenEighty === alsoTenEighty {
print("tenEighty and alsoTenEighty refer to the same VideoMode instance.")
}
// "tenEighty and alsoTenEighty refer to the same VideoMode instance." 출력


// Pointers
// C or Objective-C 에서 나오는 pointer 개념이 참조의 개념이다.
// swift에서는 앞서 말한 두 언어와 다르게 변수나 상수의 형태로 참조를 표현한다.
// 다른 언어는 (*) reference keyword를 사용!


// 클래스와 구조체 중 선택

// 구조체를 고민해볼 수 있는 경우
// 1. 구조체의 주 목적이 관계된 간단한 값을 캡슐화(encapsulate) 하기 위한 것인 경우
// 2. 구조체의 인스턴스가 참조되기 보다 복사되기를 기대하는 경우
// 3. 구조체에 의해 저장된 어떠한 프로퍼티가 참조되기 보다 복사되기를 기대하는 경우
// 4. 구조체가 프로퍼티나 메소드 등을 상속할 필요가 없는 경우

// 위에 기술한 4가지 경우를 제외하고 다른 모든 경우는 class를 사용하면 된다.


// String, Array, Dictionary
// 위의 세 타입은 struct로 정의되어 있어 변수나 상수에 할당하면 copy된다.

// NSString, NSArray, NSDictionary
// 위의 세 타입은 class로 정의되어 있어 변수나 상수에 할당 시 참조가 되는 방식이다.

// String, Array, Dictionary는 할당시 copy된다고 하였는데 실제로 swift는 최적의 성능을 위해 필요 시에만 copy하는 구조를 체택하고 있다.
// 확인 결과 Array만 COW중 초기에 같은 메모리 주소를 갖고 있는 것을 확인하였다.
// String과 Dictionary의 경우에는 단순 COW가 일어난다.
var name = ["name" : "mingu", "age": "25"]
var myName = name

func address(of object: UnsafeRawPointer) -> String{
    let address = Int(bitPattern: object)
    return String(format: "%p", address)
}

print("address of name: \(address(of: &name))")
print("address of name: \(address(of: &myName))")
