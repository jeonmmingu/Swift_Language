import Foundation

// 제어문 (Control Flow)
// while loop, if guard, switch, for-in 문 등 많은 제어문을 제공한다.

// Loop Statements
// For-in Loops
// Dictionary Rotation
let numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
// 정렬되지 않은 순서로 무작위로 나오게 된다. -> 무작위 순서라는 것을 인지해야 한다.
for (animalName, legCount) in numberOfLegs{
    print("\(animalName)s have \(legCount) legs")
}
// 숫자 범위를 지정해 순회할 수 있다.
for index in 1...5{
    print("\(index) times 5 is \(index * 5)")
}
// 변수 자리에 _(underScore)
// for in 문을 순서대로 제어 할 필요가 없는 경우 -> 성능을 높일 수 있다.
let base = 2
let power = 10
var answer = 1
for _ in 1...power{
    answer *= base
}
print("\(base) to the power of \(power) is \(answer)")
// 범위 연산자와 혼용
let minutes = 60
for tickMark in 0..<minutes{
    // render the tick mark each minute (60 times)
    print("\(tickMark + 1)초가 지났습니다.")
}
//stride(from:to:by) method 혼용 -> stride: 보폭이라는 의미 -> 간격을 설정하는데 사용하는 듯
let minuteInterval = 5
for tickMark in stride(from: 0, to: minutes, by: minuteInterval){
    print("This is \(tickMark).")
}

// While Loops
// While & repeat-while 두 종류의 while을 지원한다.
// While: condition이 false일 때까지 statement(구문)을 반복합니다.
// repeat-while : C언어의 do-while문과 유사하다. -> 처음 한 번 먼저 실행 후 조건을 확인하는 방법의 구문
var count = 0
repeat{
    print("hello")
    count += 1
} while count < 6
print("Bye")



// Conditional Statements
// Swift에서는 if와 switch문 두 가지의 조건 구문을 제공합니다.

// if문
// else, else if 구문과 같이 사용

// switch문
let someCharacter : Character = "z"
switch someCharacter {
case "a":
    print("The first letter of the alphabet")
case "z":
    print("The last letter of the alphabet")
default:
    print("Some other character")
}
// No implicit Fallthrough - 암시적 진행을 사용하지 않는다.
// C 또는 Object-C 에서는 적합한 case를 찾아 case문에 포함된 경우 break문을 통해 빠져나와줘야한다.
// Swift는 그럴 필요 없이 그냥 case만 적어주면 자동적으로 break 되도록 되어있다.
// case 구문안에 특정 지점에서 멈추기 위해 break문을 사용하는 경우가 있는데 이럴 때는 사용해도 된다.
// 또한 case 구문 안에는 최소한 하나의 구문이 필요하다.

// case의 혼합 조건 (compound condition) - (,)를 이용해서 혼합하도록 한다.
let anotherCharacter: Character = "a"
switch anotherCharacter {
case "a", "A":
    print("The letter A")
default:
    print("Not the letter A")
}

// Interval matching
// 숫자의 특정 범위를 조건으로 사용할 수 있다.
// - if 문과 비슷하게 사용하면 될 듯. 단지 iterator가 존재하지 않는다는 차이가 존재한다.
let approximateCount = 62
let countedThings = "moons orbiting Saturn"
let naturalCount: String
switch approximateCount {
case 0:
    naturalCount = "no"
case 1..<5:
    naturalCount = "a few"
case 5..<12:
    naturalCount = "several"
case 12..<100:
    naturalCount = "dozens of"
case 100..<1000:
    naturalCount = "hundreds of"
default:
    naturalCount = "many"
}
print("There are \(naturalCount) \(countedThings).")

// 또한 튜플을 조건으로 사용할 수 있다. -> 특정 point를 연산할 때 유용할 것 같다. (x,y) 기반인 UIView 등에서
let somePoint = (1, 1)
switch somePoint {
case (0, 0):
    print("\(somePoint) is at the origin")
case (_, 0):
    print("\(somePoint) is on the x-axis")
case (0, _):
    print("\(somePoint) is on the y-axis")
case (-2...2, -2...2):
    print("\(somePoint) is inside the box")
default:
    print("\(somePoint) is outside of the box")
}

// Value Binding -> '_'(underScore)를 사용하는 대신에 값을 바인딩 하여 인자로 사용
// 값을 조건에서 할당하고 이를 또 case문 내부에서 사용하는 것을 의미한다.
// switch 문에서 값을 하나씩 받고 싶은 경우 사용하면 유용할 듯 하다.
let anotherPoint = (2, 0)
print("first: \(anotherPoint.0) / second: \(anotherPoint.1)") // 이런식으로 써도 될듯
switch anotherPoint {
case (let x, 0):
    print("on the x-axis with an x value of \(x)")
case (0, let y):
    print("on the y-axis with a y value of \(y)")
case let (x, y):
    print("somewhere else at (\(x), \(y))")
}

// where문
// case에 where 조건을 사용할 수 있다.
// 바인딩과 동시에 값을 비교하거나 조건문에 사용하기 위해
let yetAnotherPoint = (1, -1)
switch yetAnotherPoint {
case let (x, y) where x == y:
    print("(\(x), \(y)) is on the line x == y")
case let (x, y) where x == -y:
    print("(\(x), \(y)) is on the line x == -y")
case let (x, y):
    print("(\(x), \(y)) is just some arbitrary point")
}

// binding + compound
let stillAnotherPoint = (9, 0)
switch stillAnotherPoint {
case (let distance, 0), (0, let distance):
    print("On an axis, \(distance) from the origin")
default:
    print("Not on an axis")
}

// Control Transfer Statements
// CTS는 코드의 진행을 계속 할 것인지 말 것인지를 정하는 구문이다.
// continue, break, fallthrough, return, throw 등이 있다.
// continue, break, return은 알기 때문에 skip!

// fallthrough
// case문에서 자동으로 break 되는 것을 막는 키워드!
let integerToDescribe = 5
var description = "The number \(integerToDescribe) is"
switch integerToDescribe {
case 2, 3, 5, 7, 11, 13, 17, 19:
    description += " a prime number, and also"
    fallthrough
default:
    description += " an integer."
}
print(description)

// Labeled Statements
// for
forState: for _ in [1,2,3,4,5]{
    for _ in [1,2,3,4,5]{
        print("for 문")
        break forState
    }
}
// while
whileState: while true{
    while true{
        print("while 문")
        break whileState
    }
}
// repeat
repeatState: repeat{
    repeat{
        print("repeat 문")
        break repeatState
    } while true
} while true

// early exit (이른 탈출)
// guard 문을 이용해 특정 조건을 만족하지 않으면 이 후 코드를 실행하지 않도록 방어코드를 작성할 수 있다.
// guard ~ else{} -> 예외 처리 또는 방어 코드에 매우 유용할 듯 하다.
func greet(person: [String: String]) {
    guard let name = person["name"] else {
        return
    }
    print("Hello \(name)!")

    guard let location = person["location"] else {
        print("I hope the weather is nice near you.")
        return
    }
    print("I hope the weather is nice in \(location).")
}

greet(person: ["name": "John"])
// Prints "Hello John!"
// Prints "I hope the weather is nice near you."
greet(person: ["name": "Jane", "location": "Cupertino"])
// Prints "Hello Jane!"
// Prints "I hope the weather is nice in Cupertino."
