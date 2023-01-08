import Foundation

// Tuple 값으로 일괄 지정 가능하다.
let (a, b) = (1, 2)

// 문자열은 + 기호로 합칠 수 있다.
print("Hello," + "world!")

// 음수에 대한 연산
print(-9 % 4)

// 단항 음수 연산자 -> 부호를 역으로 바꿔준다.
let three = 3
let minusThree = -three

// 단항 양수 연산자 -> 부호에 아무런 영향도 미치지 않는다.
let plusThree = +three
let minusPlusThree = +minusThree

// 합성 할당 연산자
var four = 1
four += three

// 비교 연산자
// '==' : 변수 또는 상수의 값이 동일한지 확인하는 연산자
// '===' : swift에서 같은 객체인지 확이하는 연산자

// 삼항 조건 연산자
let contentHeight = 40
let hasHeader = true
let rowHeight = contentHeight + (hasHeader ? 50 : 20)
print(rowHeight)

// nil 병합 연산자
let person = "mingu"
var userDefinedPerson : String?
userDefinedPerson = "HyeonGu"
var personName = userDefinedPerson ?? person
print(personName)

// 범위 연산자 (Range Operation)
// Closed Range Operation -> 시작과 끝이 존재
for index in 1...5{
    print("\(index) times 5 is \(index * 5)")
}
// Half-open Range Operation -> Array를 사용할 때 용이 (시작 index가 0)
let names = ["Anna", "Alex", "Brian", "Jack"]
let count = names.count
for i in 0..<count {
    print("Person \(i + 1) is called \(names[i])")
}
// One-Side Ranges
for name in names[1...]{
    print(name)
}
for name in names[...2]{
    print(name)
}
let range = ...5
// subscript 또는 특정 값이 있는지 확인할 때 사용함
print(range.contains(6))
print(range.contains(-10))

// Logical Operation
// ! / && / ||
// 두 개 이상의 logical Operation을 같이 사용할 수 있다.
let hasDoorKey = false
let knowsOverridePassword = true
let enteredDoorCode = false
let passedRetinaScan = false
if (enteredDoorCode && passedRetinaScan) || hasDoorKey || knowsOverridePassword {
    print("Welcome!")
} else {
    print("ACCESS DENIED")
}

