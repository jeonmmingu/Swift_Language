import Foundation

// Automatic Reference Counting

// Swift에서는 앱의 메모리 사용을 관리하기 위해 ARC를 사용한다.
// 자동으로 참조 횟수를 관리하기 때문에 대부분의 경우 개발자는 메모리 관리에 신경 쓸 필요가 없게 된다.
// 하지만 참조 횟수는 클래스 타입의 인스턴스에만 적용되고 값 타입인 구조체와 열거형 등에는 적용되지 않는다.
// 때문에 ARC는 메모리 관리를 위해 코드의 특정 부분에 대한 관계에 대한 정보를 필요로 한다.


// How to ARC Works

// ARC는 자동으로 사용되지 않는 Instance를 추적해 메모리 할당을 해제한다.
// 하지만 만약 ARC가 메모리에서 해당 부분을 해제했는데 인스턴스의 프로퍼티에 접근한다면 앱은 아마 크래시가 발생하게 될 것이다.
// 때문에 ARC는 사용중인 인스턴스를 해자 하지 않기 위해 수 많은 프로퍼티, 상수 혹은 변수가 그 인스턴스에 대한 참조를 갖고 있는지 추적하게 된다.
// 그래서 만약 ARC는 해당 인스턴스가 최소 하나라도 참조가 존재하는 경우 그 인스턴스를 메모리에서 해지 하지 않는다.


// ARC in Action
class Person {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

var reference1: Person?
var reference2: Person?
var reference3: Person?

// 이렇게 인스턴스를 선언하면 Person instance의 참조 횟수는 총 3이 된다.
reference1 = Person(name: "John Appleseed")
reference2 = reference1
reference3 = reference1

// 이렇게 두 개의 instance에 대한 참조만 해제 하면 아직 참조 횟수가 1회 남았기 때문에 deinitializer가 반응하지 않는다.
reference1 = nil
reference2 = nil

// 마지막 인스턴스의 참조를 해지하면 deinitializer가 반응한다.
reference3 = nil


// Strong Reference Cycles Between Class Instances
// 클래스 인스턴스간 강한 참조 순환
// 인스턴스의 참조 횟수가 절대로 0이 되지 않아 메모리에서 해제되지 않는 경우가 발생한다.
// 이러한 경우 중 가장 대표적인 경우가 '강한 참조 순환'이다.

// 두 개의 Class가 변수로 서로를 소유하고 있는 예시
class PersonAp {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name) is being deinitialized") }
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    var tenant: PersonAp?
    deinit { print("Apartment \(unit) is being deinitialized") }
}

var john: PersonAp?
var unit4A: Apartment?

john = PersonAp(name: "John Appleseed2")
unit4A = Apartment(unit: "4A")

// 서로의 참조 횟수가 2가 됨
john!.apartment = unit4A
unit4A!.tenant = john

// 내부의 참조를 지우지 않고 이런 식으로 지우면 메모리 누수가 발생하게 된다.
john = nil
unit4A = nil

// 때문에 이런 식으로 해제를 해야 제대로 할당이 풀리게 된다.
//john?.apartment = nil
//unit4A?.tenant = nil
//john = nil
//unit4A = nil


// Resolving Strong Reference Cycles Between Class Instances
// 이를 해결하기 위해서 weak, unowned 참조를 사용하여 해결한다.

// Weak References
// 약한 참조로 선언하면 참조하고 있는 것이 먼저 메모리에서 해제되기 때문에 ARC는 약한 참조로 선언된 참조 대상이 해지 되면 런타임에 자동으로 참조하고 있는 변수에 nil을 할당한다.
// 또한 약한 참조에 nil을 할당하면 프로퍼티 옵저버가 발동하지 않는다.

class PersonEx {
    let name: String
    init(name: String) { self.name = name }
    var apartment: ApartmentEx?
    deinit { print("\(name) is being deinitialized") }
}

class ApartmentEx {
    let unit: String
    init(unit: String) { self.unit = unit }
    weak var tenant: PersonEx?
    deinit { print("Apartment \(unit) is being deinitialized") }
}

var johnEx: PersonEx?
var unit4AEx: ApartmentEx?

johnEx = PersonEx(name: "John Appleseed")
unit4AEx = ApartmentEx(unit: "4A")

// Apartment -> Person 으로의 참조가 Weak으로 지정되었기 때문에 Person이 메모리에서 할당해제 된다면 참조 카운트가 0이 되므로 메모리에서 지워지고 deinit 구문이 실행된다.
johnEx!.apartment = unit4AEx
unit4AEx!.tenant = johnEx
johnEx = nil
// print(unit4AEx?.tenant) // nil 이 출력된다.
unit4AEx = nil


// Unowned References
// 미소유 참조는 참조 대상이 되는 인스턴스가 현재 참조하고 있는 것과 같은 life cycle을 갖거나 더 긴 생애주기를 갖는다고 판단하여 항상 참조에 그 값이 있다고 기대한다.
// 때문에 ARC는 미소유 참조에는 절대 nil을 할당하지 않는다.
// 쉽게 말하면 미소유 참조에 대해서는 옵셔널 타입을 사용하지 않는다.
// 미소유 참조를 할 경우 ARC가 더해지지 않는다.

// * 미소유 참조는 대상 인스턴스가 항상 존재한다고 생각하기 때문에 만약 대상 인스턴스가 해지 된 상태인데 접근하게 되면 런타임 에러가 발생한다.

// Example
// 신용카드와 사용자 간의 예시이다.
// 신용카드는 사라질 수 있어도 사용자 정보는 사라지지 않는 것이 일반적이기 때문이다.
class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit { print("\(name) is being deinitialized") }
}
class CreditCard {
    let number: UInt64
    unowned let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { print("Card #\(number) is being deinitialized") }
}

var john4: Customer?
john4 = Customer(name: "John Appleseed")
john4!.card = CreditCard(number: 1234_5678_9012_3456, customer: john4!)
john4!.card = CreditCard(number: 3232_4242_5252_6262, customer: john4!)

// john4의 참조를 해지 -> Customer의 Instance에 강하게 참조하고 있는 Instance가 없기 때문에 Customer Instance가 해제된다.
// Customer Instnace가 해지되면서 CreditCard의 인스턴스를 참조하고 있던 개체도 사라지므로 CreditCard 인스턴스도 메모리에서 해제된다.
// 결론적으로 두 객체다 메모리에서 해제된다.
john4 = nil


// Unowned References and Implicitly Unwrapped Optional Properties
// Weak Reference와 Unknowned Reference의 차이가 참조 값이 nil이 될 수 있는지 없는지에 대한 차이이다.
// 하지만 두 경우를 제외한 제 3의 경우가 발생할 수가 있다.
// 두 프로퍼티가 항상 값을 갖지만 한번 초기화 되면 절대 nil이 되지 않는 경우이다.
// 이런 경우 미소유 프로퍼티를 암시적 프로퍼티 언래핑을 사용해 참조 문제를 해결할 수 있다.

// Example
class Country {
    let name: String
    var capitalCity: City!
    init(name: String, capitalName: String) {
        self.name = name
        // self를 인자로 사용하기 위해선 모든 stored property들이 설정되어야 한다.
        // 그렇기 때문에 본래 City는 initializer에서 초기화되서 Optional value로 선언하는 것이 맞지만 self를 사용하기 위해 강제 언랩핑을 시켜준 것이다.
        // 이렇게 Country와 name 정보를 넘겨 받으면 City 객체는 완벽히 구성이 되기 때문이다.
        self.capitalCity = City(name: capitalName, country: self)
    }
}

class City {
    let name: String
    // 여기서는 미소유 참조를 통해 강한 순환 참조를 피하고 있다.
    // Country가 무조건 nil이 아닐 것이라는 확신이 있기 때문에 unowned를 썻음을 알 수 있다.
    // 만약 Country가 메모리에서 해제 된다면 City는 owned이기 때문에 강한 참조가 아니므로 Country 객체가 해제되게 되고 City는 참조하고 있는 것이 없기 때문에 바로 해제되는 구조이다.
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
}

var country = Country(name: "Canada", capitalName: "Ottawa")
print("\(country.name)'s capital city is called \(country.capitalCity.name)")
// Prints "Canada's capital city is called Ottawa"


// Differece between unowned and weak references
// 결국 두 개의 차이는 이름에서 알 수 있듯이,
// Weak References : 소유된(변수로 지정이 된) 두 객체간의 약한 연결
// Unowned References : 한 객체와 소유 되지 않은(소유된 객체 안에 변수로 지정된) 객체와의 연결
// 이렇게 이해하면 쉬울 것 같다.


// Strong Reference Cycles for Closures
// 클로저는 Self를 캡쳐하기 때문에 클로저와 관계되서 강한 참조 순환이 발생할 수 있다.
// 이는 Capture list를 사용하여 해결한다.
// 앞서 클로저를 배울 때 나왔던 내용이다.

class HTMLElement {
    let name: String
    let text: String?
    // 지연 프로퍼티로 설정하여 해당 클로저가 사용되기 이전까지는 초기화 되지 않는다.
    // 때문에 self를 사용할 수 있게 된다.
    // 아래와 같이 weak 또는 owned self 로 캡쳐리스트를 정의해서 사용하면 참조를 바꿀 수 있다.
        lazy var asHTML: () -> String = { [weak self] in
        if let text = self!.text {
            return "<\(self!.name)>\(text)</\(self!.name)>"
        } else {
            return "<\(self!.name) />"
        }
    }
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

let heading = HTMLElement(name: "h1")
let defaultText = "some default text"


// 아직 클로저가 초기화 되지 않았기 때문에 다른 클로저로 바꿀 수 있다.
heading.asHTML = {
    return "<\(heading.name)>\(heading.text ?? defaultText)</\(heading.name)>"
}
print(heading.asHTML())


// 클로저는 가장 강한 참조를 캡쳐하기 때문에 강한 참조 순환에 빠지게 된다.
// HTMLElement -> 클로저 : ()->String + 클로저: ()->string -> HTMLElement
var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
print(paragraph!.asHTML())
// 위에서 self를 weak로 선언했기 때문에 deinit이 활성화된다.
paragraph = nil


// Resolving Strong Reference Cycles for Closures
// 클로저에서 강한 참조 순환 문제의 해결을 위해 캡쳐 참조에 강한 참조 대신 약한 참조 혹은 미소유 참조를 지정할 수 있다.


// Defining a Capture List
// Capture list를 정의하기 위해서는 클로저의 파라미터 옆에 대괄호([])를 넣고 그 안에 각 캡쳐 대상에 대한 참조 타입을 적어 준다.
// Capture list는 내부의 변수 내용을 외부 스코프에서 참조하는 방법이다. 이를 통해 강한 참조를 방지할 수 있다.
// 강한 순환 참조에 빠지는 것을 방지하기 위해 capture list에 self값을 unowned 혹은 weak 값으로 참조한다.
let age = 10
let multiplyClosure = {[age] num in
    return num * age
}
let result = multiplyClosure(5)
print(result)
