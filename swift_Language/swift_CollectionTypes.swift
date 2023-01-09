import Foundation

// Swift에선 Collection Type으로 array, set, dictionary를 제공

// 배열 (Array)
// 빈 배열의 생성
var someInts = [Int]() // [element]() 형태로 많이 생성한다.
print("someInts is of type [Int] with \(someInts.count) items")
someInts.append(3)
print(someInts)
someInts = [] // 이런식으로 표현하면 배열을 비움을 의미합니다.
print(someInts)

// 기본 값으로 빈 배열 생성
var threeDoubles = Array(repeating: 0.0, count: 3)
print(threeDoubles)
var anotherThreeDoubles = Array(repeating: 2.5, count: 3)
print(anotherThreeDoubles)
var sixDoubles = threeDoubles + anotherThreeDoubles // + operation 가능
print(sixDoubles)

// 리터럴을 이용한 배열의 생성
var shoppingList : [String] = ["milk", "egg", "apple"]
var shoppingList2 = ["milk", "egg", "apple"]
print(shoppingList)
print(type(of: (shoppingList2)))

// 배열의 원소 추가/삭제/접근
shoppingList2.insert("banana", at: 2)
print(shoppingList2)

shoppingList2.remove(at: 1)
print(shoppingList2)

let apples = shoppingList2.removeLast()
print("apples: \(apples), shoppingList2: \(shoppingList2)")

// 배열의 순회
// 1. for in loop
for item in shoppingList{
    print(item)
}
// 2. 배열의 값과 인덱스가 동시에 필요한 경우 - enumerated() 메소드 사용
for (index, value) in shoppingList.enumerated(){
    print("Item \(index + 1) : \(value)")
}


// 셋 (Sets)
// Set 형태로 저장되기 위해서는 반드시 타입이 hashable 이어야만 합니다.
// Swift에서 String, Int, Double, Bool 같은 기본 타입은 기본적으로 hashable 입니다.
// Swift에서 Set type은 Set으로 선언합니다.

// Empty Set 생성
var letters = Set<Character>()
print("letters is of type Set<Character> with \(letters.count) items.")
// letter is of type Set<Character> with 0 items.
letters.insert("a")
print(letters)
// letters Set을 초기화
letters = []

// 배열 리터럴을 이용한 Set 생성
var favoriteGenres : Set<String> = ["Rock", "Classical", "Hip hop"]
var favorite : Set = ["Rock", "Classical", "Hip hop"] // Type Inference
print(favoriteGenres)
print(favorite)

// Set의 접근과 변경
// Set 요소 추가
let resultValue = favoriteGenres.insert("K-pop")
print(resultValue)
print(favoriteGenres)
// Set 요소 삭제
if let removedGenre = favoriteGenres.remove("K-pop"){
    print("\(removedGenre)? I'm over it.")
} else {
    print("I never much cared for that.")
}
// Set 요소 접근
if favoriteGenres.contains("J-pop"){
    print("I get up on the good foot.")
} else {
    print("It's too funcky in here.")
}

// Set의 순회
for genre in favoriteGenres{
    print("\(genre)")
}

// Set 명령
// a.intersection(b) : 교집합
// a.symmetricDifference(b) : 합집합 - 교집합 (대칭 차집합)
// a.union(b) : 합집합
// a.subtracting(b) : a - 교집합
let oddDigits: Set = [3, 1, 7, 5, 9]
let evenDigits: Set = [0, 2, 4, 6, 8]
let singleDigitPrimeNumbers: Set = [2, 3, 5, 7]

print(oddDigits.union(evenDigits).sorted())
// [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
print(oddDigits.intersection(evenDigits).sorted())
// []
print(oddDigits.subtracting(singleDigitPrimeNumbers).sorted())
// [1, 9]
print(oddDigits.symmetricDifference(singleDigitPrimeNumbers).sorted())
// [1, 2, 9]

// Set의 포함관계 관련 함수 - '맴버십과 동등 비교'라고 표현
// isSuperset(of:)
// isStrictSubset(of:)
// isStrictSuperset(of:)
// isDisjoint(with:)
let houseAnimals: Set = ["🐶", "🐱"]
let farmAnimals: Set = ["🐮", "🐔", "🐑", "🐶", "🐱"]
let cityAnimals: Set = ["🐦", "🐭"]
print(houseAnimals.isSubset(of: farmAnimals))
// 참
print(farmAnimals.isSuperset(of: houseAnimals))
// 참
print(farmAnimals.isDisjoint(with: cityAnimals))
// 참

// 사전(Dictionary)
// Swift의 Dictionary 타입은 Foundation class의 NSDictionary를 bridge한 타입이다.

// 축약형 Dictionary
// [key: Value] 형태로 Dictionary를 선언해 사용할 수 있다.
var namesOfIntegers = [Int: String]()
namesOfIntegers[16] = "sixteen"
print(namesOfIntegers)
print(namesOfIntegers.keys)
print(namesOfIntegers.values)
namesOfIntegers = [:]
print(namesOfIntegers)
if namesOfIntegers.isEmpty {
    print("Know my dictionary is empty.")
}
// 리터럴을 이용한 딕셔너리의 생성
var airports: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]
print(airports)

// 값 할당
airports["LHR"] = "London"

