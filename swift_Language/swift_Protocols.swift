import Foundation

// Protocols
// 프로토콜은 특정 기능 수행에 필수적인 요소들을 정의한 "청사진"이다.


// Protocol Syntax
/*
 
 protocol SomeProtocol {
 // protocol definition goes here
 }
 
 */


// Defining Protocol to specific types
/*
 
 struct SomeStructure: FirstProtocol, AnotherProtocol {
 // structure definition goes here
 }
 
 */

// Defining Protocol when Subclassing
/*
 
 class SomeClass: SomeSuperclass, FirstProtocol, AnotherProtocol {
 // class definition goes here
 }
 
 */


// Property Requirements
// Protocol doesn't mark whether stored property or computed property
// But Protocol have to mark that property is gettable or settable.
// Required property must declare with var type.
protocol SomeProtocol {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
}

// When declare Type property, Declare with static type.
protocol AnotherProtocol {
    static var someTypeProperty: Int { get set }
}

// Example with Protocol and Class
// 1. Use fullName property as stored property
protocol FullyNamed {
    // required property
    var fullName: String { get }
}

struct Person: FullyNamed {
    var fullName: String
}

let john = Person(fullName: "John")
print(john.fullName)

// 2. Use fullName property as computed property
class Starship: FullyNamed {
    var prefix: String?
    var name: String
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    var fullName: String {
        return (prefix != nil ? prefix! + " " : "") + name
    }
}
var ncc1 = Starship(name: "Enterprise", prefix: "USS")
print("This Starship's FullName is \(ncc1.fullName)")


// Method Requirements
// 필수 인스턴스 메소드와 타입 메소드를 정의할 수 있다.
// 하지만 메소드 파라미터의 기본 값은 프로토콜 안에서 사용할 수 없다.
/* Type method
 protocol SomeProtocol {
 static func someTypeMethod()
 }
 */
/* Required Instance Method -> 구현에 필요한 괄호는 적지 않아도 된다.
 protocol RandomNumberGenerator {
 func random() -> Double
 }
 */

protocol RandomNumberGenerator {
    func random() -> Double
}

class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        // truncatingRemainder: Double Type variable 2개에 대해서 나눗셈 연산을 할 시 사용
        lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy:m))
        return lastRandom / m
    }
}
let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
// Prints "Here's a random number: 0.3746499199817101"
print("And another one: \(generator.random())")
// Prints "And another one: 0.729023776863283"


// Mutating Method Requirements
// Mutating keyword can be used by value type method!
protocol Toggable {
    mutating func toggle()
}

enum OnOffSwitch: Toggable {
case off, on
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}
var lightSwitch = OnOffSwitch.off
print("Light Switch's state is now \(lightSwitch.self)")
lightSwitch.toggle()
print("Light Switch's state is now \(lightSwitch.self)")


// Initializer Requirements
// Protocol can set required initializer
protocol initializeProtocol {
    init(someParameter: Int)
}

class testClass: initializeProtocol {
    required init(someParameter: Int) {
        print("The number of this Class is \(someParameter)!!!")
    }
}
let testInstance = testClass(someParameter: 3)

// Class Type에서 final로 선언된 것에는 required를 표시하지 않아도 된다.
// 왜냐하면 final keyword가 선언됬다는 것은 더이상 subClassing이 불가능하다는 것이기 때문이다.

// Superclass' initializer is declared in protocol + Subclassing
protocol SomeProtocol2 {
    init()
}

class SomeSuperClass {
    init() {
        print("Hello :-)")
    }
}
class SomeSubClass: SomeSuperClass, SomeProtocol2 {
    // "required" from SomeProtocol conformance; "override" from SomeSuperClass
    required override init() { print("Hello Too :-)") }
}
let subClass = SomeSubClass()


// Protocol + Failable initializer
// Protocol can declare Failable initializer Requirements


// Protocols as Types
// Protocol is used as a Type
// So protocol can be used in the Space Where type is allowed.
// protocol은 타입이기 때문에 첫 글자는 대문자로 표기해야한다.

// Example
class Dice {
    let sides: Int
    // This one!
    let generator: RandomNumberGenerator
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}

var d6 = Dice(sides: 6, generator: LinearCongruentialGenerator())
for _ in 1...5 {
    print("Random dice roll is \(d6.roll())")
}
// Random dice roll is 3
// Random dice roll is 5
// Random dice roll is 4
// Random dice roll is 5
// Random dice roll is 4


// Delegation (위임)
protocol DiceGame {
    var dice: Dice { get }
    func play()
}
// To Decalre AnyObject, this protocol can be allowed to Class Type Only!
protocol DiceGameDelegate : AnyObject {
    // 프로토콜도 형으로 인정받기 때문에 파라미터로 사용되는 것을 확인 할 수 있다.
    func gameDidStart(_ game: DiceGame)
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    func gameDidEnd(_ game: DiceGame)
}
// Example Class That Allow DiceGame and Delegate
class SnakesAndLadders: DiceGame {
    let finalSquare = 25
    let dice = Dice(sides: 6, generator: LinearCongruentialGenerator())
    var square = 0
    var board: [Int]
    init() {
        board = Array(repeating: 0, count: finalSquare + 1)
        board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
        board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
    }
    weak var delegate: DiceGameDelegate?
    func play() {
        square = 0
        delegate?.gameDidStart(self)
        gameLoop: while square != finalSquare {
            let diceRoll = dice.roll()
            delegate?.game(self, didStartNewTurnWithDiceRoll: diceRoll)
            switch square + diceRoll {
            case finalSquare:
                break gameLoop
            case let newSquare where newSquare > finalSquare:
                continue gameLoop
            default:
                square += diceRoll
                square += board[square]
            }
        }
        delegate?.gameDidEnd(self)
    }
}
class DiceGameTracker: DiceGameDelegate {
    var numberOfTurns = 0
    func gameDidStart(_ game: DiceGame) {
        numberOfTurns = 0
        if game is SnakesAndLadders {
            print("Started a new game of Snakes and Ladders")
        }
        print("The game is using a \(game.dice.sides)-sided dice")
    }
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        numberOfTurns += 1
        print("Rolled a \(diceRoll)")
    }
    func gameDidEnd(_ game: DiceGame) {
        print("The game lasted for \(numberOfTurns) turns")
    }
}
let tracker = DiceGameTracker()
let game = SnakesAndLadders()
game.delegate = tracker
game.play()
// Started a new game of Snakes and Ladders
// The game is using a 6-sided dice
// Rolled a 3
// Rolled a 5
// Rolled a 4
// Rolled a 5
// The game lasted for 4 turns

// 위와 같은 방식으로 delegate을 지정하여 사용할 수 있다.

    
// Adding Protocols Conformance with an Extension
// 익스텐션을 이용해 프로토콜 따르게 하기

// Example1
// 이전에 있던 Dice Class에 extension을 이용해 프로토콜을 따르도록 할 수 있다.
protocol TextRepresentable {
    var textualDescription: String { get }
}

extension Dice: TextRepresentable {
    var textualDescription: String {
        return "A \(sides)-sided dice"
    }
}

let d12 = Dice(sides: 12, generator: LinearCongruentialGenerator())
print(d12.textualDescription)


// Example2
extension SnakesAndLadders: TextRepresentable {
    var textualDescription: String {
        return "A game of Snakes and Ladders with \(finalSquare) squares"
    }
}
print(game.textualDescription)


// Conditionally conforming to a Protocol
// 배열중에서 원소들이 전부 해당 프로토콜을 따르는 경우에만 프로토콜을 따르도록 설정
extension Array: TextRepresentable where Element: TextRepresentable {
    var textualDescription: String {
        let itemsAsText = self.map { $0.textualDescription }
        return "[" + itemsAsText.joined(separator: ", ") + "]"
    }
}

let myDice = [d6, d12]
print(myDice.textualDescription)


// Declaring Protocol Adoption with an Extension
// 익스텐션을 이용해 프로토콜 채용 선언하기
// 만약 어떤 프로토콜 충족에 필요한 모든 조건을 만족하지만 아직 그 프로토콜을 따른다는 선언을 하지 않았다면 그 선언을 빈 익스텐션으로 선언할 수 있다.
// 프로토콜의 요구사항을 충족시키는 것만으로는 프로토콜의 사용조건을 만족하지 못한다. 반드시 어떤 프로토콜을 따르는지 기술해야한다.
// Exmaple
struct Hamster {
    var name: String
    var textualDescription: String {
            return "A hamster name \(name)"
    }
}
// extension을 사용해서 분리할 수도 있지만 처음에 struct 선언 시 프로토콜을 따르게 해도 상관없다.
extension Hamster: TextRepresentable {}

let simonTheHamster = Hamster(name: "Simon")
// protocol을 타입으로 사용한 예시이다.
let somethingTextRepresentable: TextRepresentable = simonTheHamster


// Collections of Protocol Types
// Array, Dictionary등 Collection Type에 넣기 위한 타입으로 사용할 수 있다.
let things: [TextRepresentable] = [game, d12, simonTheHamster]
for thing in things {
    print("\(thing.textualDescription)")
}


// Protocol Inheritance
// 클래스의 상속과 같이 프로토콜도 상속이 가능하다.
// Example
protocol PrettyTextRepresentable: TextRepresentable {
    var prettyTextualDescription: String { get }
}
extension SnakesAndLadders: PrettyTextRepresentable {
    var prettyTextualDescription: String {
        // PrettyTextPresentable protocol에서 TextRepresentable protocol 변수를 차용
        var output = textualDescription + ":\n"
        for index in 1...finalSquare {
            switch board[index] {
            case let ladder where ladder > 0:
                output += "▲ "
            case let snake where snake < 0:
                output += "▼ "
            default:
                output += "○ "
            }
        }
        return output
    }
}
print(game.prettyTextualDescription)


// Class-Only Protocols
// 구조체, 열거형에서 사용하지 않고 클래스 타입에만 사용가능한 프로토콜을 선언하기 위해서 프로토콜에 AnyObject를 추가한다.
protocol SomeClassOnlyProtocol: AnyObject {
    func greetings() -> String
}
class Human: SomeClassOnlyProtocol {
    var name: String
    var isHuman: Bool
    
    init(name: String, isHuman: Bool? = false){
        self.name = name
        self.isHuman = isHuman!
    }
    
    func greetings() -> String {
        if isHuman {
            return "Hello, my name is \(name)! :-)"
        }
        else {
            return "????"
        }
    }
}
let mingu = Human(name: "mingu", isHuman: true)
print(mingu.greetings())


// Protocol Compsition - 프로토콜 합성
// 동시에 여러 프로토콜을 따르는 타입을 선언할 수 있다.
// Example
protocol Named {
    // settable 하다는 의미는 instance를 한번 생성한 이후에 다시 set 할 수 있는지에 대한 내용이다.
    var name: String { get set }
}
protocol Aged {
    var age: Int { get }
}
struct NamedAgedPerson: Named, Aged {
    var name: String
    var age: Int
}
// 여러 개의 프로토콜을 따를 시 & 연산자를 사용해서 표시한다.
func wishHappyBirthday(to celebrator: Named & Aged) {
    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
}
let birthdayPerson = NamedAgedPerson(name: "Malcolm", age: 21)
wishHappyBirthday(to: birthdayPerson)

// More example
// Class와 Protocol도 이런 식으로 묶을 수 있다.
class Location {
    var latitude: Double
    var longitude: Double
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
class City: Location, Named {
    var name: String
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        super.init(latitude: latitude, longitude: longitude)
    }
}
func beginConcert(in location: Location & Named) {
    print("Hello, \(location.name)!")
}

let seattle = City(name: "Seattle", latitude: 47.6, longitude: -122.3)
beginConcert(in: seattle)
// Prints "Hello, Seattle!"


// 프로토콜 순응 확인 (Checking for Protocol Conformance)
// 어떤 타입이 특정 프로토콜을 따르는지 확인하는 방법
// is 연산자를 이용하면 어떤 타입이 특정 프로토콜을 따르는지 확인할 수 있다.
// as? 는 특정 프로토콜 타입을 따르는 경우 그 옵셔널 타입의 프로토콜 타입으로 다운캐스트를 하게 되고 따르지 않는 경우에는 nil을 반환한다.
// as! 는 강제로 특정 프로토콜을 따르도록 정의한다. 만약 다운캐스트에 실패하면 런타임 에러가 발생한다.

// Example
protocol HasArea {
    var area: Double { get }
}
// Use area property as a computed property
class Circle: HasArea {
    let pi = 3.1415927
    var radius: Double
    var area: Double { return pi * radius * radius }
    init(radius: Double) { self.radius = radius }
}
// Use area property as a stored property
class Country: HasArea {
    var area: Double
    init(area: Double) { self.area = area }
}
// Which is not conform HasArea Protocol
class Animal {
    var legs: Int
    init(legs: Int) { self.legs = legs }
}

let objects: [AnyObject] = [
    Circle(radius: 2.0),
    Country(area: 243_610),
    Animal(legs: 4)
]
// as? 를 통해서 프로토콜을 따르는지 확인하기
for object in objects {
    if let objectWithArea = object as? HasArea {
        print("Area is \(objectWithArea.area)")
    } else {
        print("Something")
    }
}


// Optional Protocol Requirements
// When implement protocols, we can define optinal implementation Conditions
// To use Optional implementation conditons, we have do declare this protocol by using @objc
@objc protocol CounterDataSource {
    @objc optional func increment(forCount count: Int) -> Int
    @objc optional var fixedIncrement: Int { get }
}

class Counter {
    var count = 0
    // Class가 따르는 것이 아닌 dataSource가 프로토콜을 따르도록 하였다.
    var dataSource: CounterDataSource?
    func increment() {
        // dataSource의 increment가 구현이 안되어 있을 수 있기 때문에 옵셔널 체이닝을 이용해 확인해 볼 수 있다.
        if let amount = dataSource?.increment?(forCount: count) {
            print("Yeah")
            count += amount
        } else if let amount = dataSource?.fixedIncrement {
            print("Ya hoo")
            count += amount
        }
    }
}

class ThreeSource: NSObject, CounterDataSource {
    let fixedIncrement: Int = 3
}

var counter = Counter()
counter.dataSource = ThreeSource()
for _ in 1...4 {
    // dataSoruce자체의 increment가 정의되어있지 않기 때문에 fixedIncrement로 진행되도록 설정되었다.
    counter.increment()
    print(counter.count)
}

// 값을 0으로 수렴하도록 만드는 클래스
class TowardsZeroSource: NSObject, CounterDataSource {
    func increment(forCount count: Int) -> Int {
        if count == 0 {
            return 0
        } else if count < 0 {
            return 1
        } else {
            return -1
        }
    }
}

counter.dataSource = TowardsZeroSource()
counterLoop: while counter.count != 0 {
    counter.increment()
    print(counter.count)
}


// Protocol Extensions
// we can extension to expand protocols.

// Exmaple
// RnadomNumberGenerator: Protocol Type
extension RandomNumberGenerator {
    func randomBool() -> Bool {
        return random() > 0.5
    }
}

// LinearCongruentialGenerator: 컴퓨터 알고리즘으로 이루어진 난수 발생기
let newGenerator = LinearCongruentialGenerator()
print("Here's a random number: \(newGenerator.random())")
// Prints "Here's a random number: 0.3746499199817101"
print("And here's a random Boolean: \(newGenerator.randomBool())")
// Prints "And here's a random Boolean: true"


// 프로토콜에서의 기본 구현 제공
// 프로토콜에서는 선언만 할 수 있는데 익스텐션을 통해 기본 구현을 제공할 수 있습니다.

// Example
// prettyTextualDescription 프로퍼티의 구현을 그냥 textualDescription을 반환하도록 구현한 예시이다.
extension PrettyTextRepresentable  {
    var prettyTextualDescription: String {
        return textualDescription
    }
}


// Adding constraints to protocol extensions
// 특정 상황에만 프로토콜을 사용할 수 있도록 where절을 이용하여 제약을 생성한 경우이다.

// Example
// Collection element가 Equatable인 경우에만 적용되는 allEqual() method를 작성한 예시
extension Collection where Element: Equatable {
    func allEqual() -> Bool {
        for element in self {
            if element != self.first {
                return false
            }
        }
        return true
    }
}

let equalNumbers = [100, 100, 100, 100, 100]
let differentNumbers = [100, 100, 200, 100, 200]

print(equalNumbers.allEqual())
print(differentNumbers.allEqual())

