import Foundation


// initialization (초기화)
// 초기화는 구조체, 클래스, 열거형 인스턴스를 사용하기 위해 준비 작업을 하는 단계이다.
// 이 단계에서 각 저장 프로퍼티의 초기값을 설정한다.
// 여러 값과 자원의 해지를 위해 deinitializer를 사용할 수도 있다.
// initializer는 한번에 여러 개를 생성해서 사용할 수 있다.


// Setting initial Values for Stored Properties
// Instance의 저장 프로퍼티는 사용하기 전에 반드시 특정 값으로 초기화 되어야 한다.
// Initializer에서 저장 프로퍼티에 관한 값을 할당하면 옵저버가 실행되지 않는다.


// Initializer
// 이니셜라이저는 특정 인스턴스를 생성한다.
struct Fahrenheit {
    var temperature: Double
    init() {
        temperature = 32.0
    }
}
var f = Fahrenheit()
print("The default temperature is \(f.temperature)° Fahrenheit")


// Default Property Values
// 프로퍼티의 선언과 동시에 값을 할당하면 그 값을 초기 값으로 사용할 수 있다.
// 항상 같은 초기 값을 갖는다면 Default Property를 사용하는 것이 좋다.
// init()을 사용하지 않고 Default Property 형태로 사용하면 된다.


// Customizing initialization

// initialization parameters
struct Celsius {
    var temperatureInCelsius: Double // 해당 인자를 초기화 프로퍼티로 설정
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
}
let boilingPointOfWater = Celsius(fromFahrenheit: 212.0)
// boilingPointOfWater.temperatureInCelsius is 100.0
let freezingPointOfWater = Celsius(fromKelvin: 273.15)
// freezingPointOfWater.temperatureInCelsius is 0.0


// 인자 레이블이 있는 이니셜라이저 파라미터
struct Color {
    let red, green, blue: Double
    init(red: Double, green: Double, blue: Double) {
        self.red   = red
        self.green = green
        self.blue  = blue
    }
    init(white: Double) {
        red   = white
        green = white
        blue  = white
    }
}
// 인자 레이블이 존재하기 때문에 인자를 다 적어줘야 한다.
let magenta = Color(red: 1.0, green: 0.0, blue: 1.0)
let halfGray = Color(white: 0.5)


// 인자 레이블이 없는 이니셜라이저 파라미터
struct Celsius2 {
    var temperatureInCelsius: Double
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
    init(_ celsius: Double) {
        temperatureInCelsius = celsius
    }
}
let bodyTemperature = Celsius2(37.0)
// bodyTemperature.temperatureInCelsius is 37.0


// Optional Property Types
// 프로퍼티의 최초 값이 존재하지 않고 후에 추가 될 수 있는 값을 옵셔널로 선언한다.
// 처음에 옵셔널로 설정하면 자동적으로 nil로 초기화 된다.
class SurveyQuestion {
    var text: String
    var response: String?
    init(text: String) {
        self.text = text
    }
    func ask() {
        print(text)
    }
}
let cheeseQuestion = SurveyQuestion(text: "Do you like cheese?")
cheeseQuestion.ask()
// Prints "Do you like cheese?"
cheeseQuestion.response = "Yes, I do like cheese."


// 초기화 중에 상수 프로퍼티 할당
// 이니셜라이저에서는 상수 프로퍼티에 값을 할당하는 것도 가능하다.
class SurveyQuestion2 {
    let text: String
    var response: String?
    init(text: String) {
        self.text = text // 상수 프로퍼티도 초기화 과정에서 할당할 수 있다.
    }
    func ask() {
        print(text)
    }
}
let beetsQuestion = SurveyQuestion2(text: "How about beets?")
beetsQuestion.ask()
// Prints "How about beets?"
beetsQuestion.response = "I also like beets. (But not with cheese.)"


// Default initializer
// 만약 모든 프로퍼티가 Default property를 가지고 있고, 하나의 이니셜라이저도 설정되지 않았다면, Swift에서는 모든 프로퍼티를 기본 값으로 초기화 하는 기본 초기자를 제공한다.
class ShoppingListItem2 {
    var name: String?
    var quantity = 1
    var purchased = false
}
var item = ShoppingListItem2()


// Memberwise Initializers for Structure Type
// Structure type instance를 생성할 때 인자를 설정하며 생성할 수 있다.
// => 새로운 initializer가 필요하지 않다.
struct Size1 {
    var width = 0.0, height = 0.0
}
let twoByTwo = Size1(width: 2.0, height: 2.0)


// Initializer Delegation for Value Types
// Value type : Structure type & Enumeration type
// Class type : Class Type
// 둘은 상속 부분에서 차이가 있기 때문에 Initializer의 위임도 방법과 순서가 다르다.
// Initializer Delegation : 이니셜라이저를 다른 이니셜라이저로 위임하는 것을 의미한다.
struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    init() {} // 기본 값을 초기화 값으로 갖도록 하는 initializer
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        // 특정 동작을 수행하고 다른 이니셜라이저에게 초기화를 위임
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}
let basicRect = Rect()
// basicRect's origin is (0.0, 0.0) and its size is (0.0, 0.0)
let originRect = Rect(origin: Point(x: 2.0, y: 2.0),
                      size: Size(width: 5.0, height: 5.0))
// originRect's origin is (2.0, 2.0) and its size is (5.0, 5.0)
let centerRect = Rect(center: Point(x: 4.0, y: 4.0),
                      size: Size(width: 3.0, height: 3.0))
// centerRect's origin is (2.5, 2.5) and its size is (3.0, 3.0)


// Class inheritance and initialization
// 모든 Class의 저장 프로퍼티와 superclass로부터 상속받은 모든 프로퍼티는 초기 값을 가져야 한다.

// Designated Initializer and Convenience Initializer (지정 초기자와 편리한 초기자)
// Designated Initializer : 지정 초기자
// => Class의 주 초기자로써 클래스의 모든 프로퍼티를 초기화하며 Class에 무조건 한 개 이상 존재해야한다.
// Convenience Initializer : 이전의 지정 초기자를 호출함으로써 최소한의 입력으로 초기화를 진행할 수 있는 초기자를 의미한다.

// 지정 초기자
// init(parameters) {
//     statements
// }

// 편리한 초기자
// convenience init(parameters) {
//     statements
// }


// Initializer Delegation for Class type
// Designated initializer와 Convenience Initializer 사이의 관계를 단순하게 하기 위해 Swift는 3가지 규칙을 따르도록 하였다.
// 1. Designated initializer는 반드시 SuperClass의 Designated Initializer를 호출 해야한다.
// 2. Convenience Initializer는 반드시 같은 Class의 Initializer를 호출 해야한다.
// 3. Convenience Initializer는 궁극적으로 지정 초기자를 호출한다.

// 요약
// 1. Designated initializer는 superclass의 Designated initializer에 위임을 해야한다.
// 2. Convenience initializer는 같은 level에서 initializer를 호출 해야한다.


// 2단계 초기화 (Two-Phase-Intialization)
// 1단계 : 프로퍼티들을 초기 값으로 초기화 하는 단계
// 2단계 : 새로운 인스턴스의 사용이 준비되었다고 알려주기 전에 저장된 프로퍼티를 커스터마이징 하는 단계이다.

// 초기화 단계 안전 확인 4단계
// 1단계 : 지정 초기자는 superclass의 지정 초기자에 위임하기 전에 모든 프로퍼티를 초기화 한 후에 위임해야한다.
// 2단계 : 지정 초기자는 반드시 상속된 값을 할당하기 전에 superclass의 초기자로 위임을 넘겨야한다. 그렇지 않으면 상속된 값이 superclass의 지정 초기자에 의해 다시 초기화 되버리기 때문이다.
// 3단계 : 편리한 초기자는 반드시 어떤 프로퍼티를 할당하기 전에 다른 초기자로 위임을 넘겨야 한다. 만약 그렇지 않으면 할당된 프로퍼티가 편리한 초기자에 의해 다시 초기화 되버리기 때문이다.
// 4단계 : 이니셜라이저는 초기화의 1단계가 끝나기 전에는 self의 값을 참조하거나 어떤 인스턴스 프로퍼티, 메소드 등을 호출하거나 읽을 수 없습니다. 즉 먼저 초기 값을 지정하거나 초기화를 지정해준 뒤 행동을 정의 해야한다.


// Initializer Inheritance and Overriding
// : Swift에서는 기본적으로 subclass가 superclass의 initializer를 상속받지 않는다.
// SuperClass의 initializer를 상속받는 경우 override keyword를 통해 실현한다.
// SubClass에서 var 값은 변경이 가능하지만 let값은 변경이 불가능하다.
class Vehicle {
    var numberOfWheels = 0
    var description: String {
        return "\(numberOfWheels) wheel(s)"
    }
}
let vehicle = Vehicle()
print("Vehicle: \(vehicle.description)")
// Vehicle: 0 wheel(s)

class Bicycle: Vehicle {
    // Initializer를 상속받는 경우에 override keyword를 통해 이를 구현한다.
    override init() {
        super.init()
        numberOfWheels = 2
    }
}
let bicycle = Bicycle()
print("Bicycle: \(bicycle.description)")
// Bicycle: 2 wheel(s)


// Automatic Initializer Inheritance
// Rule 1 : 만약 subclass에서 지정 초기자를 설정하지 않으면 superclass의 모든 지정 초기자를 상속받는다.
// Rule 2 : 만약 subclass에서 superclass의 모든 지정 초기자에 대해 정의했다면 superclass의 모든 편리한 초기자를 상속받는다.


// Designated initializer와 Convenience initializer의 Usage
class Food {
    var name: String
    init(name: String) {
        self.name = name
    }
    convenience init() {
        self.init(name: "[Unnamed]")
    }
}
let namedMeat = Food(name: "Bacon")
// namedMeat's name is "Bacon"
let mysteryMeat = Food()
// mysteryMeat's name is "[Unnamed]"


// Food Class를 subclassing한 예제
class RecipeIngredient: Food {
    var quantity: Int
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    override convenience init(name: String) {
        self.init(name: name, quantity: 1)
    }
}
let oneMysteryItem = RecipeIngredient()
let oneBacon = RecipeIngredient(name: "Bacon")
let sixEggs = RecipeIngredient(name: "Eggs", quantity: 6)
// 상속받은 지정 초기자를 모두 설정해주었기 때문에 편리한 초기자는 자동으로 상속되어 이런식으로 쓰인다.
print(oneMysteryItem.name)


// Food를 상속받은 RecipeIngredient를 상속받은 ShoppingListItem의 예제
// 상속을 아주 잘 사용한 예시인 것 같다.
// 이런 식으로 코드를 짠다면 정말 완벽한 코드가 될 것 같다.
class ShoppingListItem: RecipeIngredient {
    var purchased = false
    var description: String {
        var output = "\(quantity) x \(name)"
        output += purchased ? " ✔" : " ✘"
        return output
    }
}
var breakfastList = [
    ShoppingListItem(),
    ShoppingListItem(name: "Bacon"),
    ShoppingListItem(name: "Eggs", quantity: 6),
]
breakfastList[0].name = "Orange juice"
breakfastList[0].purchased = true
for item in breakfastList {
    print(item.description)
}
// 1 x Orange juice ✔
// 1 x Bacon ✘
// 6 x Eggs ✘


// Failable initializers
// : 초기화 과정중 실패할 가능성이 있는 초기자를 의미한다.
// init뒤에 '?' keyword를 붙여서 이를 표시한다.

// * Initializer는 본래 반환 값을 갖지 않는 프로퍼티이다.
// 하지만 Failable한 Initializer에 한해서 nil 값을 반환 받는다. -> 실패했는지 확인하는 용도로 활용
// 아래의 예시에서 Int(exactly:)는 Int struct의 failable한 initializer이다.
// 즉 반환 값으로 nil값 혹은 optional 값을 반환한다.
let wholeNumber: Double = 12345.0
let pi = 3.14159

if let valueMaintained = Int(exactly: wholeNumber) {
    print("\(wholeNumber) conversion to Int maintains value of \(valueMaintained)")
}
// Prints "12345.0 conversion to Int maintains value of 12345"

let valueChanged = Int(exactly: pi)
// valueChanged is of type Int?, not Int

if valueChanged == nil {
    print("\(pi) conversion to Int does not maintain value")
}
// Prints "3.14159 conversion to Int does not maintain value"


// 초기자의 입력이 없는 경우 초기화 실패가 일어나도록 설정한 예제
struct Animal {
    let species: String
    init?(species: String) {
        if species.isEmpty { return nil }
        self.species = species
    }
}
// 인자 값을 제대로 설정한 경우
let someCreature = Animal(species: "Giraffe")
// someCreature is of type Animal?, not Animal

if let giraffe = someCreature {
    print("An animal was initialized with a species of \(giraffe.species)")
}
// Prints "An animal was initialized with a species of Giraffe"

// 인자 값을 제대로 설정하지 않은 경우
let anonymousCreature = Animal(species: "")
// anonymousCreature is of type Animal?, not Animal

if anonymousCreature == nil {
    print("The anonymous creature could not be initialized")
}
// Prints "The anonymous creature could not be initialized"
// nil 과 empty는 다른 의미이다.
// nil은 특정 타입의 값의 부재를 의미한다.
// null은 C언어에서 표현하는 단어로 가리키는 포인터가 존재하지 않음을 의미한다.
// 단순히 비어있다의 의미가 아니고 특정 타입 값의 부재라고 이해해야 한다.
// Empty라는 표현은 array, set, dictionary등 특정 Collectioin에서 비었다고 표현을 하는 것이다.


// Failure initializers for enumerations
enum TemperatureUnit {
    case kelvin, celsius, fahrenheit
    init?(symbol: Character) {
        switch symbol {
        case "K":
            self = .kelvin
        case "C":
            self = .celsius
        case "F":
            self = .fahrenheit
        default:
            return nil
        }
    }
}
let fahrenheitUnit = TemperatureUnit(symbol: "F")
if fahrenheitUnit != nil {
    print("This is a defined temperature unit, so initialization succeeded.")
}
// Prints "This is a defined temperature unit, so initialization succeeded."

let unknownUnit = TemperatureUnit(symbol: "X")
if unknownUnit == nil {
    print("This is not a defined temperature unit, so initialization failed.")
}
// Prints "This is not a defined temperature unit, so initialization failed."


// Failable initializers for enumerations with Raw Values
// Raw Value들을 이런 방식으로 추가하게 되면 자동으로 failable initializer로 인식된다.
enum TemperatureUnit2: Character {
    case kelvin = "K", celsius = "C", fahrenheit = "F"
}

let fahrenheitUnit2 = TemperatureUnit2(rawValue: "F")
if fahrenheitUnit2 != nil {
    print("This is a defined temperature unit, so initialization succeeded.")
}
// Prints "This is a defined temperature unit, so initialization succeeded."

let unknownUnit2 = TemperatureUnit2(rawValue: "X")
if unknownUnit2 == nil {
    print("This is not a defined temperature unit, so initialization failed.")
}
// Prints "This is not a defined temperature unit, so initialization failed."


// Propagation of Initialization Failure
// 실패 가능한 초기자에서 실패가 발생하면 즉시 초기자는 종료된다.
// 또혼 실패 가능한 초기자는 실패 불가능한 초기자에게 위임할 수 있다. 이를 활용하여 현재 존재하는 초기자를 특정 상황에만 실패하는 초기자로 만들 수 있다.
// 아래의 예시 설명
// product의 name이 없거나, cartitem의 quantity가 1 미만인 경우 초기화를 실패하도록 구현된 예시이다.
class Product {
    let name: String
    init?(name: String) {
        if name.isEmpty { return nil }
        self.name = name
    }
}
class CartItem: Product {
    let quantity: Int
    init?(name: String, quantity: Int) {
        if quantity < 1 { return nil }
        self.quantity = quantity
        super.init(name: name)
    }
}
if let twoSocks = CartItem(name: "sock", quantity: 2) {
    print("Item: \(twoSocks.name), quantity: \(twoSocks.quantity)")
}
// Prints "Item: sock, quantity: 2"
if let zeroShirts = CartItem(name: "shirt", quantity: 0) {
    print("Item: \(zeroShirts.name), quantity: \(zeroShirts.quantity)")
} else {
    print("Unable to initialize zero shirts")
}
// Prints "Unable to initialize zero shirts"
if let oneUnnamed = CartItem(name: "", quantity: 1) {
    print("Item: \(oneUnnamed.name), quantity: \(oneUnnamed.quantity)")
} else {
    print("Unable to initialize one unnamed product")
}
// Prints "Unable to initialize one unnamed product"


// Overriding a Failure Initializers
// : SuperClass의 실패 가능한 초기자를 SubClass의 실패 불가능한 초기자로 오버라이딩 할 수 있다.
// : 반대는 불가능하다.
class Document {
    var name: String?
    // this initializer creates a document with a nil name value
    init() {}
    // this initializer creates a document with a nonempty name value
    init?(name: String) {
        if name.isEmpty { return nil }
        self.name = name
    }
}
class AutomaticallyNamedDocument: Document {
    override init() {
        super.init()
        self.name = "[Untitled]"
    }
    // 실패 가능한 SuperClass Initializer를 실패 불가능한 SubClass의 initializer로 가져왔다.
    override init(name: String) {
        super.init()
        if name.isEmpty {
            self.name = "[Untitled]"
        } else {
            self.name = name
        }
    }
}
class UntitledDocument: Document {
    override init() {
        // 옵셔널 값을 갖지 않도록 강제 언래핑
        // 강제로 언래핑 하는 경우 반환 값으로 옵셔널 값을 갖지 않는다. -> 하지만 만약 반환 값으로 optional 값이 출력되는 경우 오류를 발생한다.
        super.init(name: "[Untitled]")!
    }
}


// 필수 초기자 (required initializers)
// : SubClass가 반드시 구현해야 하는 초기자를 설정
// 필수 초기자 표시를 해도 반드시 구현을 할 필요는 없다.
class SomeClass {
    required init() {
        // initializer implementation goes here
    }
}
class SomeSubclass: SomeClass {
    required init() {
        // subclass implementation of the required initializer goes here
    }
}


// Setting a defualt property value with a closure or function
// : 기본 값을 할당하는데 다소 복잡한 계산을 필요로 한다면 함수나 클로저를 사용하여 값을 할당할 수 있다.
class SomeClass2 {
    // closure 뒤에 ()라는 표현을 이해 못함
    let someProperty: Int = {
        // create a default value for someProperty inside this closure
        // someValue must be of the same type as SomeType
        return 3
    }()
}

// Example - Chessboard
struct Chessboard {
    let boardColors: [Bool] = {
        // 여기서도 인자형 뒤에 ()를 사용함을 볼 수 있다.
        var temporaryBoard = [Bool]()
        var isBlack = false
        for i in 1...8 {
            for j in 1...8 {
                temporaryBoard.append(isBlack)
                isBlack = !isBlack
            }
            isBlack = !isBlack
        }
        return temporaryBoard
    }()
    func squareIsBlackAt(row: Int, column: Int) -> Bool {
        return boardColors[(row * 8) + column]
    }
}
let board = Chessboard()
print(board.squareIsBlackAt(row: 0, column: 1))
// Prints "true" - Black space
print(board.squareIsBlackAt(row: 7, column: 7))
// Prints "false" - White space
