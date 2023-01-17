import Foundation

// methods (메소드)

// 특정 타입의 Class, Method, Enumeration과 관련된 함수를 메서드라고 한다.
// 인스턴스와 관련된 메소드를 인스턴스 메소드, 타입과 관련된 메서드를 type method라고 한다.


// Insatance method
class Counter {
    var count = 0
    func increment() {
        count += 1
    }
    func increment(by amount: Int) {
        count += amount
    }
    func reset() {
        count = 0
    }
}
// Make new instance
let counter = Counter()
// 초기 count 값은 0입니다.
counter.increment()
print(counter.count)
// count 값이 1로 변경 됐습니다.
counter.increment(by: 5)
print(counter.count)
// count 값은 현재 6입니다.
counter.reset()
print(counter.count)
// count 값은 0이 됩니다.


// Self properties
// : We can use Self properties in instance method.
// ex) self.count += 1
// We use self properties when parameter name is same with property name.
struct Point {
    var x = 0.0, y = 0.0
    func isToTheRightOf(x: Double) -> Bool {
        return self.x > x  // self.x를 이용해 프로퍼티 x와 인자 x를 구분
    }
}
let somePoint = Point(x: 4.0, y: 5.0)
if somePoint.isToTheRightOf(x: 1.0) {
    print("This point is to the right of the line where x == 1.0")
}
// "This point is to the right of the line where x == 1.0" 출력


// Modifying Value Types from within instance method
// Generally, In instance method, we cannot modify value type properties.
// In struct, enumeration type!!
// Class type is exception!!
// Also, We cannot modify Value that was declared with 'let' keyword.
struct Point2 {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
    }
}
var somePoint2 = Point2(x: 1.0, y: 1.0)
somePoint2.moveBy(x: 2.0, y: 3.0)
print("The point is now at (\(somePoint2.x), \(somePoint2.y))")
// "The point is now at (3.0, 4.0)" 출력


// Assigning to self Within a mutation method
struct Point3 {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        self = Point3(x: x + deltaX, y: y + deltaY)
    }
}
// This syntax is exactly same as the previous one.

// Using mutation keyword in enumeration type.
enum TriStateSwitch {
    case off, low, high
    mutating func next() {
        switch self {
        case .off:
            self = .low
        case .low:
            self = .high
        case .high:
            self = .off
        }
    }
}
var ovenLight = TriStateSwitch.low
ovenLight.next()
print(ovenLight)
// ovenLight 값은 .high
ovenLight.next()
print(ovenLight)
// ovenLight 값은 .off


// Type Methods (타입 메서드)
// Add static or class keyword in front of the functions.
// In swift, we can use type methods with structure, enumeration, class type!
// static method cannot override superclass' function.
// class method can override superclass' function.
// Type methods can use 'self' keyword.
struct LevelTracker {
    static var highestUnlockedLevel = 1
    var currentLevel = 1

    static func unlock(_ level: Int) {
        if level > highestUnlockedLevel { highestUnlockedLevel = level }
    }

    static func isUnlocked(_ level: Int) -> Bool {
        return level <= highestUnlockedLevel
    }

    @discardableResult
    mutating func advance(to level: Int) -> Bool {
        if LevelTracker.isUnlocked(level) {
            currentLevel = level
            return true
        } else {
            return false
        }
    }
}
class Player {
    var tracker = LevelTracker()
    let playerName: String
    func complete(level: Int) {
        LevelTracker.unlock(level + 1)
        tracker.advance(to: level + 1)
    }
    init(name: String) {
        playerName = name
    }
}
var player = Player(name: "Argyrios")
player.complete(level: 1)
print("highest unlocked level is now \(LevelTracker.highestUnlockedLevel)")

// "highest unlocked level is now 2" 출력
player = Player(name: "Beto")
if player.tracker.advance(to: 6) {
    print("player is now on level 6")
} else {
    print("level 6 has not yet been unlocked")
}
// "level 6 has not yet been unlocked" 출력
