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
