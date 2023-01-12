import Foundation

// Closures
// 클로저는 코드블록으로 C와 Objective-C의 블럭(blocks)와 다른 언어의 Lambdas와 비슷한 개념이다.
// 어떤 상수나 변수의 참조를 캡쳐(Capture)해 저장할 수 있다.
// Swift는 이 캡쳐와 관련한 모든 메모리를 알아서 처리한다.

// Closure Expressions
// 클로저의 표현은 인라인 클로저를 명확하게 표현하는데에 초점이 맞춰져있다.
// 클로저 표현은 코드의 명확성과 의도를 잃지 않으면서 문법을 축약할 수 있는 다양한 문법 최적화 방법을 제공한다.

// The Sorted Method (정렬 메서드)
// Swift 표준 라이브러리에 있는 sorted(by:) 라는 알려진 타입의 배열 값을 정렬하는 메소드를 제공한다.
// 해당 정렬 함수에 by라는 인자 값에 어떤 방식으로 정렬할 것인지에 대해 기술한 클로저를 넣어 사용한다.
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
func backward(_ s1: String, _ s2: String) -> Bool{
    return s1 > s2
}
var reversedNames = names.sorted(by: backward) // backward가 closure 이다.
print(reversedNames)

// Closure Expression Syntax
// {(인자) -> 반환형 in
//  statement
// }
// 이런 식으로 정의된 형태가 아닌 인자로 들어가 있는 형태의 클로저를 인라인 클로저(Inline closure)라고 한다.
reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 < s2
})
print(reversedNames)

// Inferring Type From Context
// sorted(by:) 의 메소드에서는 이미 (String, String) -> Bool 타입의 인자가 들어와야 하는지 알고 있기 때문에 이러한 타입들은 생략 될 수 있다.
// {인자 in statement}
var names2 = ["mingu", "aingu", "qingu"]
names2 = names2.sorted(by: {s1, s2 in return s1 > s2})
print(names2)

// Implicit Returns from Single-Express Closures (단일 표현 클로저에서의 암시적 반환)
// 단일 표현 클로저에서는 반환 키워드조차 생략할 수 있다.
// 단일 표현이라는 것은 딱 한줄짜리 statement를 가진 클로저를 의미한다.
names2 = names2.sorted(by: {s1, s2 in s1 < s2})
print(names2)

// Shorthand Arguments Names (인자 이름 축약)
// 인자의 순서대로 $0, $1, $2 이런 식으로 인식하기 때문에 in 키워드 부분을 생략할 수 있다.
names2 = names2.sorted(by: { $0 > $1 })
print(names2)

// Operator Methods (연산자 메소드)
// 극한으로 코드 라인을 줄일 수 있다.
// swift에서는 String 타입 연산자에 대해서 비교할 수 있는 비교 연산자(>)를 구현해 두었다.
// 때문에 두 개의 인자에 대해 비교를 할 때는 굳이 인자를 적어주지 않아도 된다.
names2 = names2.sorted(by: <)
print(names2)

// Trailing Closures (후위 클로저)
// 만약 함수의 마지막 인자로 클로저를 넣고 그 클로저가 길다면 후위 클로저를 사용할 수 있다.
names2 = names2.sorted() { (s1: String, s2: String) -> Bool in
    return s1 > s2
}
names2 = names2.sorted() { $0 > $1 }
// 만약 함수의 마지막 인자가 클로저이고 후위 클로저를 사용하는 경우에는 ()를 생략할 수 있다.
names2 = names2.sorted { $0 > $1 }
print(names2)
// 후위 클로저를 이용하여 숫자(Int)를 문자(String)로 매핑(Mapping)하는 예제
let digitNames = [
    0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]
let numbers = [16, 58, 510]

// map(_:) 메소드를 이용해 특정 값을 다른 특정 값으로 maping할 수 있는 클로저를 구현
// 1. 클로저가 길기 때문에 Trailing Closure를 사용
// 2. 마지막 인자가 클로저 이기 때문에 ()를 생략
// 3. strings는 타입 추론에 의해 문자열 배열 타입으로 추론
// 기본적으로 함수와 클로저에 넘겨지는 인자 값은 상수이다. -> 그대로 변경하며 사용하는 다른 언어들과 다름
// -> 그렇기 때문에 "var number"로 다시 캐스팅을 진행한 것이다.
let strings = numbers.map { (number) -> String in
    var number = number
    var output = ""
    repeat{
        output = digitNames[number % 10]! + output
        number /= 10
    } while number > 0
    return output
}
print(strings)
// let strings는 타입 추론에 의해 문자 배열 ([strings]) 타입을 갖는다.

// Capturing Values (값 캡쳐)
// 클로저는 특정 문맥의 상수나 변수의 값을 캡쳐할 수 있다.
// 값을 캡쳐한다는 말은 원본 값이 사라져도 closure의 body 안에서 다시 사용할 수 있음을 의미한다.
// Swift에서 값을 캡쳐하는 가장 단순한 형태는 nested function 이다.
// 반환하는 값이 closure이다.
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int{
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}
let incrementByTen = makeIncrementer(forIncrement: 10)
// 같은 클로저 안에서 실행을 시키면 값이 캡쳐링 되서 값이 누적된다.
// incrementer 함수를 반환받지만 incrementer 함수에 사용되는 변수 값이 캡쳐링 된다.
print(incrementByTen()) // 이전에 캡쳐된 값 0
print(incrementByTen()) // 이전에 캡쳐된 값 10

let incrementBySeven = makeIncrementer(forIncrement: 7)
// 다른 클로저를 실행시키기 때문에 위의 값은 누적되지 않는다.
print(incrementBySeven()) // 이전에 캡쳐된 값 0
print(incrementBySeven()) // 이전에 캡쳐된 값 10

// 만약 closure를 어떤 클래스의 인스턴스 프로퍼티로 할당하고 그 클로저가 그 인스턴스를 캡쳐링하면 강한 순환 참조에 빠지게 된다.
// 1. 어떤 클래스가 존재하는데 특정 closure가 클래스의 property로 지정되어 있음
// 2. closure가 사용될 때, 해당 instance를 캡쳐링 하게 됨
// 3. 그럼 instance의 프로퍼티 중 하나인 closure가 다시 instance의 정보를 캡쳐해서 가지고 있게 됨.
// 4. 이 상황에서 instance가 delete(즉, 메모리에서 소멸)되어도 closure가 instance의 정보를 가지고 있게 되어 메모리에서 해제가 안되는 문제가 발생
// 5. Swift는 이러한 문제를 해결하기 위해서 Capture list라는 것을 사용한다.

// Closures are Refernce Types
// 클로저는 참조 타입이다.
// 1. 위의 예시에서 incrementByTen은 상수인데 capture된 변수인 runningTotal을 증가시킴
// 2. 그 이유는 클로저는 참조 타입이기 때문이다.
// 3. 만약 여러 변수 또는 상수에 하나의 클로저를 할당하면 다 같은 클로저를 참조하고 있는 것이다.
// 4. C언어의 함수 포인터를 저장한다고 생각하면 된다.
let incrementByTen2 = incrementByTen
print(incrementByTen2()) // 이전에 캡쳐된 값 20

// Escaping Closures
// 함수의 파라미터로 쓰이는 closures 중에 함수 밖에서 실행되는 closure(Asynchronous closure / completeHandler closure)는 파라미터 타입 앞에 @escaping이라는 키워드를 명시해야한다.
var completionHandlers : [()->Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void){
    completionHandlers.append(completionHandler)
}
// Non-Escaping Closure
func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()    // 함수 안에서 끝나는 클로저
}
// Escaping closure와 Non-Escaping closure를 둘 다 쓰는 함수
// Escaping closure의 경우 self를 명시적으로 언급 해야한다. -> 밖으로 꺼내기 때문인 듯 함(정확한 이유는 모름)
class SomeClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure {
            print(self.x)
            self.x = 100
        } // 명시적으로 self를 적어줘야 함.
        someFunctionWithNonescapingClosure {
            print(x)
            x = 200
        } // doSomething func을 부르면 바로 실행되는 클로저.
    }
}
let instance = SomeClass()
instance.doSomething()
print(instance.x)
// prints "200"
completionHandlers.first?()
print(instance.x)
// prints "100"
// 위의 결과 값들은 capturing과도 연관이 있다. -> class안에 있는 closure가 capturing을 하고 구문을 동작시키기 때문에 x의 값 이 달라지는 것이다.
// capture는 호출되는 순간 포착하는 개념이 아니고 capture된 변수를 계속해서 추적하는 느낌인듯 하다. 즉 한번 캡쳐한 변수의 값이 달라지면 처음에 포착된 순간이 아닌 바뀐 값을 보게 되는 개념이다.

// AutoClosures
// 자동 클로저는 인자 값이 없으며 특정 표현을 감싸서 다른 함수에 전달 인자로 사용할 수 있는 클로저이다.
// 자동 클로저는 클로저를 실행하기 전까지 실제 실행이 되지 않는다.
// 계산이 복잡한 연산을 넣는 경우 많이 사용된다.
var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
print(customersInLine.count)
// Prints "5"

let customerProvider = { customersInLine.remove(at: 0) } // No parameter -> Auto closure -> 처음 실행이 x
print(customersInLine.count)
// Prints "5"

print("Now serving \(customerProvider())!")
// Prints "Now serving Chris!"
print(customersInLine.count)
// Prints "4"

// AutoClosure을 Func의 parameter로 사용
// 아래의 예시는 명시적으로 클로저를 직접 넣는 방식으로 구현
// customersInLine is ["Alex", "Ewa", "Barry", "Daniella"]
func serve1(customer customerProvider: () -> String) {
    print("Now serving \(customerProvider())!")
}
serve1(customer: { customersInLine.remove(at: 0) } )

// @autoclosure 키워드를 이용해서 더 간결하게 사용하는 방법
// customersInLine is ["Ewa", "Barry", "Daniella"]
func serve2(customer customerProvider: @autoclosure () -> String) {
    print("Now serving \(customerProvider())!")
}
serve2(customer: customersInLine.remove(at: 0)) // @autoclosure 키워드를 붙여줌으로써 인자는 자동으로 클로저로 변환된다.

// 자동 클로저를 너무 남용하면 코드를 이해하기 어려워지기 때문에 문맥과 함수 이름이 AutoClosure를 사용하기에 분명 해야 한다.
// 클로저는 일반적으로 사용하되 만약 인자 값이 존재하지 않는 클로저를 사용하고 싶은 경우에 AutoClosure를 사용한다.
// 클로저의 개념을 refernce의 개념으로 생각해보면 좋을 것 같다.
// refernce의 개념으로 함수를 사용하고 싶을 때 closure를 사용할 수 있다고 생각할 수 있을 것 같다.

// Escaping AutoClosure Example
// customersInLine is ["Barry", "Daniella"]
var customerProviders: [() -> String] = []        //  클로저를 저장하는 배열을 선언
func collectCustomerProviders(_ customerProvider: @autoclosure @escaping () -> String) {
    customerProviders.append(customerProvider)
} // 클로저를 인자로 받아 그 클로저를 customerProviders 배열에 추가하는 함수를 선언
collectCustomerProviders(customersInLine.remove(at: 0))    // 클로저를 customerProviders 배열에 추가
collectCustomerProviders(customersInLine.remove(at: 0))

print("Collected \(customerProviders.count) closures.")
// Prints "Collected 2 closures."        // 2개의 클로저가 추가 됨
for customerProvider in customerProviders {
    print("Now serving \(customerProvider())!")    // 클로저를 실행하면 배열의 0번째 원소를 제거하며 그 값을 출력
}
// Prints "Now serving Barry!"
// Prints "Now serving Daniella!"
