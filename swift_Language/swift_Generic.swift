import Foundation

// Generic
// 타입을 일반화 하는 내용으로, 함수, 구조체, 클래스 등을 하나로 재사용하기 위해 사용되는 개념이다.

// The Problem that Generics Solve
// 같은 수행을 하는 함수인데 Parameter의 type만 다른 경우에 대해 해결할 수 있다.
// Example
// 두 변수의 값을 바꾸는 함수
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}
var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print(" someInt: \(someInt)\n antherInt: \(anotherInt)")

func swapTwoStrings(_ a: inout String, _ b: inout String) {
    let temporaryA = a
    a = b
    b = temporaryA
}

func swapTwoDoubles(_ a: inout Double, _ b: inout Double) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var myWrongName = "mingu"
var myOriginalName = "mongu"
swapTwoStrings(&myWrongName, &myOriginalName)
print(" myWrongName: \(myWrongName)\n myOriginalName: \(myOriginalName)")
// 함수의 인자로 들어가는 두 개의 타입은 항상 같아야 한다.
// swift가 type-safe 언어이기 때문에 만약 다른 타입의 값을 바꾸려고 하면 컴파일 에러가 발생한다.


// Generic Functions
// 위의 세 함수를 하나의 Generic Function으로 만드는 예제
// T: Place Holder라고 한다.
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}
var someInt2 = 3
var anotherInt2 = 107
swapTwoValues(&someInt2, &anotherInt2)
print(" someInt2: \(someInt2)\n anotherInt2: \(anotherInt2)")
// someInt is now 107, and anotherInt is now 3

var someString = "hello"
var anotherString = "world"
swapTwoValues(&someString, &anotherString)
print(" someString: \(someString)\n anotherString: \(anotherString)")
// someString is now "world", and anotherString is now "hello"


// Type parameters
// Generic function의 인자 type으로 지정한 <T>가 Type parameter이다.


// Naming Type Parameters
// Dictionary의 Key, Value와 같이 엘리먼트 간의 서로 상관관계가 있는 경우 의미가 있는 이름을 파라미터 이름으로 붙이고 그렇지 않은 경우는 T, U, V와 같은 단일 문자로 파라미터 이름을 짓는다.


// Generic Type
// Swift에서는 Generic function에 추가적으로 Generic type을 정의할 수 있도록 하였다.
// 대표적으로 Stack이라는 Generic Collectioin type이 존재한다.
// 이는 UINavigationController에서 사용하는 자료 구조이다.

// Example - stack algorithm
// 원본 형태
struct IntStack {
    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
}
// Generic type으로 만든 구조체
struct Stack<Element> {
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}
var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
stackOfStrings.push("cuatro")
print(stackOfStrings.pop(), stackOfStrings.pop(), stackOfStrings.pop())

// Expanding a Generic Type
// Generic type도 Extension을 이용하여 확장이 가능하다.
extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}
if let topItem = stackOfStrings.topItem {
    print("The top item on the stack is \(topItem).")
} else {
    print("There is no item in stack")
}


// Type Constraints
// 예를 들어 Directory Type을 보면 항상 hashable protocol을 따르도록 되어있다. 그 이유는 key값이 고유함을 보장하여 value 값을 찾을 때 용이하게 하기 위함이다.
// 이때 hashable protocol을 무조건 따르도록 하는 것이 Type Constraint 이다.


// Type constraint Syntax
/*
     func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
         // function body goes here
     }
 */


// Type Constraint in Action
// <T>에서 T바로 옆에 conform 할 프로토콜 name을 :과 함께 붙여준다.
// Example: <T: Equatable>
func findIndex(ofString valueToFind: String, in array: [String]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

let strings = ["cat", "dog", "llama", "parakeet", "terrapin"]
if let foundIndex = findIndex(ofString: "llama", in: strings) {
    print("The index of llama is \(foundIndex)")
}
// Prints "The index of llama is 2"
// <T : Equatable> part를 넣어주어 value == valueToFind 에서 "==" 기호를 사용할 수 있게 되었다.
func findIndex<T : Equatable>(of valueToFind: T, in array:[T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}
let doubleIndex = findIndex(of: 9.3, in: [3.14159, 0.1, 0.25])
// doubleIndex is an optional Int with no value, because 9.3 isn't in the array
let stringIndex = findIndex(of: "Andrea", in: ["Mike", "Malcolm", "Andrea"])
// stringIndex is an optional Int containing a value of 2
if doubleIndex != nil && stringIndex != nil {
    print("doubleIndex = \(doubleIndex!), stringIndex = \(stringIndex!)")
} else {
    print("Between doubleIndex and stringIndex, one thing's value is nil!")
}


// Associated Types
// 연관 타입은 프로토콜의 일부분으로 타입에 PlaceHolder 이름을 부여한다.
// 특정 타입을 동적으로 지정해 사용할 수 있다.


// Associated Types in Action
// Example
protocol Container {
    associatedtype Item // 변수를 지정한 것이 아닌 단순히 타입을 자유롭게 설정하기 위해 선언한 것이다.
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

struct IntStack2: Container {
    // original IntStack implementation
    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
    // conformance to the Container protocol
    // typealias를 통해 associatedtype을 정해주었다.
    typealias Item = Int
    mutating func append(_ item: Int) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Int {
        return items[i]
    }
}

// General Type과 associatedtype을 둘 다 사용한 형태로 구현되었다.
struct Stack2<Element>: Container {
    // original Stack<Element> implementation
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    // conformance to the Container protocol
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}


// Expanding an Existing Type to Specify an Associated Type

// extesion을 통해 특정 프로토콜에 순응하도록 할 수 있다.
extension Array: Container {
    // 이것이 이렇게 자연스럽게 오류가 안나고 되는 이유는
    // Container에 있는 모든 요소들
    // "append", "count", "subscript" 가 모두 정의되어 있기 때문이다.
}


// Using a Protocol in Its Associated Type's Constraints
// 프로토콜의 연관 타입을 제한하는 부분은 어렵다...
// Protocol의 associated type에도 restricts를 둘 수 있다.
// Condition을 붙일 때는 where 절을 이용한다.
protocol SuffixableContainer: Container {
    // Suffix.Item의 타입이 Container의 Item type과 동일해야 하도록 Condition을 설정하였다.
    associatedtype Suffix: SuffixableContainer where Suffix.Item == Item
    func suffix(_ size: Int) -> Suffix
}

extension Stack2: SuffixableContainer {
    func suffix(_ size: Int) -> Stack2 {
        var result = Stack2()
        for index in (count-size)..<count {
            result.append(self[index])
        }
        return result
    }
    // Inferred that Suffix is Stack2.
}
// <Int>를 붙인 것은 Stack2를 Generic Type으로 설정했기 때문이다.
// Suffix의 Type을 Stack2로 줌
// Stack2.Item == Item 이건 프로토콜을 2중으로 따르기 때문에 당연하기에 성립한다.
var stackOfInts = Stack2<Int>()
stackOfInts.append(10)
stackOfInts.append(20)
stackOfInts.append(30)
// suffix가 Stack2<Int> 형으로 추론되는 것을 볼 수 있다.
let suffix = stackOfInts.suffix(2)
// suffix contains 20 and 30


// Generic Where Clauses
// 제네릭 내에서도 where 절을 사용할 수 있다.
// C1, C2가 모두 Container를 따른다.
func allItemsMatch<C1: Container, C2: Container>
    (_ someContainer: C1, _ anotherContainer: C2) -> Bool
    where C1.Item == C2.Item, C1.Item: Equatable {

        // Check that both containers contain the same number of items.
        if someContainer.count != anotherContainer.count {
            return false
        }
        // Check each pair of items to see if they're equivalent.
        for i in 0..<someContainer.count {
            if someContainer[i] != anotherContainer[i] {
                return false
            }
        }
        // All items match, so return true.
        return true
}

var stackOfStrings2 = Stack2<String>()
stackOfStrings2.push("uno")
stackOfStrings2.push("dos")
stackOfStrings2.push("tres")

var arrayOfStrings = ["uno", "dos", "tres"]

if allItemsMatch(stackOfStrings2, arrayOfStrings) {
    print("All items match.")
} else {
    print("Not all items match.")
}
// Prints "All items match."


// Extensions with a Generic where Clause
// Extension에 where 절을 이용해 Element 가 Equtable protocol을 따르는지 확인 해야한다.
extension Stack where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}

if stackOfStrings.isTop("tres") {
    print("Top element is tres.")
} else {
    print("Top element: \(stackOfStrings.topItem!)")
    print("Top element is something else.")
}
// Prints "Top element is tres."

struct NotEquatable { } // Equatable protocol을 따르지 않는 구조체이다.
var notEquatableStack = Stack<NotEquatable>()
let notEquatableValue = NotEquatable()
notEquatableStack.push(notEquatableValue)
// notEquatableStack.isTop(notEquatableValue)  // Error


// Cpmtainer Protocol을 따르는 타입중에 Item이 Equatable 프로토콜을 따르는 것으로만 제약을 준 예시
extension Container where Item: Equatable {
    func startsWith(_ item: Item) -> Bool {
        return count >= 1 && self[0] == item
    }
}
// 42의 첫 숫자가 9가 아니므로 false에 대한 분기 실행문이 실행된다.
if [9, 9, 9].startsWith(42) {
    print("Starts with 42.")
} else {
    print("Starts with something else.")
}

// Where 절에서 특정 프로토콜을 따르는지 뿐만 아니라 특정 값 타입인지 구분하는 문구를 작성할 수도 있다.
extension Container where Item == Double {
    func average() -> Double {
        var sum = 0.0
        for index in 0..<count {
            sum += self[index]
        }
        return sum / Double(count)
    }
}
// 위에서 array가 container를 conform한다는 내용 때문에 에러가 나지 않고 해당 구문이 작동한다.
print([1260.0, 1200.0, 98.6, 37.0].average())
// Prints "648.9"


// Associated Types with Generic Where clause
// 연관 타입에도 where 절을 적용해 제한을 둘 수 있다.
protocol Container2 {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
    
    // IteratorProtocol 또한 Element를 가지고 있는 Generic type임과 동시에 sequence protocol과 긴밀하게 연결되어 있다.
    associatedtype Iterator: IteratorProtocol where Iterator.Element == Item
    func makeIterator() -> Iterator
}

// 다른 프로토콜을 상속하는 프로토콜에도 where절로 조건을 부여할 수 있다.
protocol ComparableContainer: Container where Item: Comparable { }


// Generic Subscript
// Generic Subscript에도 Constraints를 부여할 수 있다.
extension Container {
    subscript<Indices: Sequence>(indices: Indices) -> [Item]
    where Indices.Iterator.Element == Int {
        var result = [Item]()
        for index in indices {
            result.append(self[index])
        }
        return result
    }
}

let myArray = ["A", "B", "C", "D", "E", "F", "G"]
// Array 또한 Sequence protocol을 따르며 Indices.Iterator.Element가 Int이기 때문에 subscript를 사용할 수 있다.
let indices = [0, 2, 4, 6]
print(myArray[indices])

