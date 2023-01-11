import Foundation

// Functions (함수)

// Defining and Calling Functions
// 함수를 선언할 때는 가장 앞에 Func 키워드를 붙이고 parameter(인자)와 인자형 그리고 반환형을 정의해야 한다.
func greet(person: String) -> String{
    let greeting = "Hello, " + person + "!"
    return greeting
}
print(greet(person: "Anna"))
print(greet(person:"brain"))

// 상수 도는 변수를 바인딩 하지 않고 바로 반환 받는 형태로 구현
func greetAgain(person: String) -> String{
    return "Hello again, " + person + "!"
}
print(greetAgain(person: "Anna"))

// 함수 파라미터와 반환 값 (Function Parameters and Return Values)
// The function with no parameter
func sayHelloWorld() -> String{
    return "Hello, world"
}
print(sayHelloWorld())

// The function with many parameter -> 함수 명이 같아도 인자의 형태가 다르면 다른 함수로 인식한다.
// 이는 C언어의 template이랑 유사한 개념이다.
func greet(person: String, already: Bool) -> String{
    if already{
        return greetAgain(person: person)
    } else{
        return greet(person: person)
    }
}
print(greet(person: "Tim", already: false))
print(greet(person: "Mingu", already: true))

// The function without return value
func greet(personName: String){
    print("Hello, \(personName)")
}
// 반환형이 다른 걸로는 다른 함수로 취급하지 않는다.
// 다른 함수로 인정받기 위해서는 인자형 혹은 함수명이 달라야 다른 함수로 인정받는다.
greet(personName: "dave")

// 함수의 반환 값이 반환 값을 받지 않고 호출만 할 수도 있다.
func printAndCount(string: String) -> Int {
    print(string)
    return string.count
}
func printWithoutCounting(string: String) {
    let _ = printAndCount(string: string)
}
let value = printAndCount(string: "hello, world")
print(value)
// prints "hello, world" and returns a value of 12
printWithoutCounting(string: "hello, world")
// prints "hello, world" but does not return a value

// 복수 값을 반환하는 함수 (Functions with Multiple Return Values)
// 복수 값을 반환하는 경우에는 tuple을 이용한다.
func minMax(array : [Int]) -> (min: Int, max: Int){
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count]{
        if value < currentMin{
            currentMin = value
        } else if value > currentMax{
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}
let bounds = minMax(array: [8, -6, 2, 109, 3])
print("min is \(bounds.min) and max is \(bounds.max)")

// Optional Tuple Return Types
// 옵셔널 반환형을 사용하는 이유는 return 값으로 nil 값등을 보내서 호출한 쪽에서 확인이 가능하기 때문이다.
func minMax2(array: [Int]) -> (min: Int, max: Int)? {
    if array.isEmpty { return nil }
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}
// nil이 아닌 경우에만 출력하도록 하려고 if let 구문을 사용!
// swift에서 할당 연산자는 값을 반환하지 않는다.
// 하지만 함수에서 반환한 값을 할당할 수는 있기 때문에 아래와 같은 문법은 사용 가능하다.
// if let을 "옵셔널 체인"이라고 표현한다.
if let bounds2 = minMax2(array: []) {
    print("min is \(bounds2.min) and max is \(bounds2.max)")
} else {
    print("array is empty!")
}
// 사용하지 못하는 조건 할당문 - 아래와 같이 사용하면 할당 받은 값이 없어 오류가 발생한다.
// let a = 3
// if let x = a{
//    statement
// }

// 인자 라벨 지정 (Specifying Argument Labels)
// 인자의 이름을 함수안에서 사용할 때와 호출할 때를 분리해서 설정할 수 있다.
func greet(person: String, from hometown: String) -> String {
    return "Hello \(person)!  Glad you could visit from \(hometown)."
}
print(greet(person: "Bill", from: "Cupertino"))

// 인자 생략 (Ommiting Argument Labels)
// 파라미터 앞에 _를 붙여서 함수 호출 시 인자 값을 생략하여 사용할 수 있다.

// 기본 인자 값 (Default Parameter Values)
// 함수의 기본 파라미터 값을 설정할 때, 기본 파라미터 값이 없는 인자를 앞에 쓰는게 더 의미있게 함수를 구성할 수 있다.
// 평소에는 잘 바꾸지 않는 값이지만 함수 호출 시 가끔 바꿔야 할 필요가 있는 경우 Default parameter를 사용한다.
// 기본 인자 값을 설정하는 방법은 인자와 인자형 뒤에 "= value" 를 붙여주면 된다.

// 가변 매개변수 (Variadic Parameters)
// 매개변수의 개수를 특정하지 않고 받을 수 있다.
// [double], 이런 식으로 array를 만들어도 되지만 가변 매개변수를 써도 좋을 것 같다.
func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        print(number)
        total += number
    }
    return total / Double(numbers.count)
}
print(arithmeticMean(1, 2, 3, 4, 5))
print(arithmeticMean(3, 8.25, 18.75))

// In-Out Parameters
// C언어에서 포인터를 사용해 call-by-reference 하는 방식이랑 유사
// return 값을 받지 않고 값을 주고 받는 느낌의 방식이다.
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}
var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")

// 함수 형 (Function Types)
// 함수 형은 파라미터 형과 반환 형으로 구성되어 있다.
// 함수 형의 활용
// 함수 포인터랑 똑같다고 생각하면 편할 것 같다.(In C)
// 하지만 Address를 참조하는 것은 아닌 것 같고 값을 할당해주는 방식인 것 같다. (정확히 무엇을 할당하는지는 공부해봐야 알 듯)
func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}
var mathFunction: (Int, Int) -> Int = addTwoInts
print(mathFunction(1, 3))
// 형 추론을 통해 만들 수도 있다.
let anotherMathFunction = addTwoInts
print(anotherMathFunction(2, 4))
// 파라미터로써 함수 형 사용
func printMathResult(_ mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
    print("Result: \(mathFunction(a, b))")
}
printMathResult(addTwoInts, 3, 5)
// 반환형으로써 함수 형 사용 (이런 식으로 코드짜면 간지날 듯..)
func stepForward(_ input: Int) -> Int {
    return input + 1
}
func stepBackward(_ input: Int) -> Int {
    return input - 1
}
func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    return backward ? stepBackward : stepForward
}
var currentValue = 3
let moveNearerToZero = chooseStepFunction(backward: currentValue > 0)
// moveNearerToZero는 이제 stepBackward() 함수를 가르키고 있습니다.
print("Counting to zero:")
// Counting to zero:
while currentValue != 0 {
    print("\(currentValue)... ")
    currentValue = moveNearerToZero(currentValue)
}
print("zero!")

// 중첩 함수 (Nested Functions)
// 특정 함수의 body안에 있는 함수를 의미하며 해당 함수는 전역적으로 사용하지 못한다.
// 특정 함수에서만 쓰이는 함수인 경우 이런 식으로 사용
func chooseStepFunction2(backward: Bool) -> (Int) -> Int {
    func stepForward2(input: Int) -> Int { return input + 1 }
    func stepBackward2(input: Int) -> Int { return input - 1 }
    return backward ? stepBackward : stepForward
}
var currentValue2 = -4
let moveNearerToZero2 = chooseStepFunction2(backward: currentValue > 0)
// moveNearerToZero는 이제 중첩 돼 있는 stepForward() 함수를 가르킵니다.
while currentValue2 != 0 {
    print("\(currentValue2)... ")
    currentValue2 = moveNearerToZero2(currentValue2)
}
print("zero!")
