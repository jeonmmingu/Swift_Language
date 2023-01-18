import Foundation

// SubScript (서브 스크립트)
// Class, Struct, Enumartion에서 특정 스크립트를 정의해 사용할 수 있습니다.
// 서브스크립트란 콜랙션, 리스트, 시퀀스 등 집합의 특정 맴버 엘리먼트에 간단히 접근할 수 있는 문법이다.
// 서브스크립트를 사용하면 추가적인 메소드 없이 특정 값을 할당하거나 가져올 수 있다.
// 하나의 타입에 여러가지 서브스크립트를 사용할 수 있다.


// Subscript Syntax
// set에 대한 인자 값을 설정하지 않으면 기본 설정 값으로 newValue가 쓰인다.

//subscript(index: Int) -> Int {
//    get {
//        // 적절한 반환 값
//    }
//    set(newValue) {
//        // 적절한 set 액션
//    }
//}

// 읽기 전용으로 선언하려면 get, set을 모두 지우고 따로 지정하지 않으면 get으로 동작하게 되어 읽기 전용 서브 스크립트가 된다.
struct TimesTable {
    let multiplier: Int
    subscript(index: Int) -> Int {
        return multiplier * index
    }
}
let threeTimesTable = TimesTable(multiplier: 3)
print("six times three is \(threeTimesTable[6])")
// get/set을 설정하지 않았기 때문에 기본적으로 get으로 받게 되고 즉 읽기 전용으로 인식된다.


// Subscript Usage
// Subscript의 사용 목적은 특정 자료형의 인자 값을 바꿀 수 있도록 하는 것이다.
var numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
// numberOfLegs라는 dictionary에 "bird"라는 key에 '2'라는 Value를 할당하는 Subscript이다.
numberOfLegs["bird"] = 2


// Subscript's Options
// Subscriptsms 입력 인자 수에 제한이 없고, 입력 인자의 타입과 반환 타입에도 제한이 없다.
// 다만 in-out parameter(reference 방식으로 인자를 전달 받는 것)와 default parameter value를 사용할 수 없다.
// 또한, Overloading을 허용한다.
// 그렇기 때문에 원하는 수 만큼의 서브 스크립트를 선언할 수 있다.
struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0.0, count: rows * columns)
    }
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range") // 유효한 index가 아닌 경우 프로그램을 바로 종료하도록 함
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range") // 유효한 index가 아닌 경우 프로그램을 바로 종료하도록 함
            grid[(row * columns) + column] = newValue
        }
    }
}
var matrix = Matrix(rows: 2, columns: 2)
// 값을 바꾸기 위해 subscript를 사용
// function하고 완전히 다른 용도의 느낌
// 인스턴스의 method를 사용하는 느낌이 아닌 그 타입 자체의 스크립트를 넣는 느낌이다.
// 예를 들어 삼각형을 초기에 만들고 삼각형의 기본적인 어떤 것들을 넣어주거나 뺄 때의 것들을 정의하는 느낌.
// 물론 메서드로도 만들 수 있지만 직관적이고 행렬이라는 것을 잘 표현할 수 있는 syntax인 것 같다.
matrix[0, 1] = 1.5
matrix[1, 0] = 3.2
// 아래와 같이 범위를 넘어가는 경우 assert 함수에 의해 프로그램이 종료 된다.
// matrix[2, 2] = 9.0
print(matrix)
