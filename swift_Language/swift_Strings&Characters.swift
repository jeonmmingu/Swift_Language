import Foundation

// Swift의 String은 Foundation FrameWorks의 NSString이 bridge된 타입이기 때문에 NSString의 메소드를 String에서 캐스팅 없이 사용 가능하다.

// 여러 문자열 리터널
// 한번에 여러 줄의 문자열을 저장하는 것을 제외하면 단일 문자열과 저장이 동일하다.
let quotation = """
The White Rabit put on his spectacles.
"where shall I begin, please your Majesty?" he asked.
"""
print(quotation)

// 문자열 리터널의 특수 문자
let wiseWords = "\"Imagination is more important than knowledge\" - Einstein"
// "Imagination is more important than knowlege" - Einstein
let dollaSign = "\u{24}"            // $, 유니코트 U+0024
let blackHeart = "\u{2665}"         // ♥, 유니코드 U+2665
let sparklingHeart = "\u{1F496}" // 💖,유니코드 U+1F496

// 빈 문자열 초기화
var emptyString = ""
var anotherEmptyString = String()

// 빈 문자열 확인
if emptyString.isEmpty {
    print("String is empty!")
}

// Value Type String
// 기본적으로 String은 Value type이다.
// 다른 Method나 변수 값 또는 상수 값에서 문자열을 할당받은 경우 reference 방식이 아닌
// copy 방식으로 수행이 진행된다.

// 문자열 for-in loop
for character in "Dog!🐶"{
    print(character)
}

// 문자 상수 선언하기
let exclamationMark : Character = "!"
print(exclamationMark)

// 문자 배열을 이용해 문자열 만들기
let catCharacters: [Character] = ["C", "a", "t", "!", "🐈"]
var catString : String = String(catCharacters)
print(catString)

// 문자열에 문자 붙이기 (append를 활용해서 문자를 붙임)
catString.append(exclamationMark)
print(catString)

// 문자열 삽입
let multiplier = 3
let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)!"
print(message)

// 유니코드 스칼라
// Swift Native String Type은 유니코드 스칼라 값으로 만들어졌다.
let precomposed: Character = "\u{D55C}"                        // 한
let decomposed: Character = "\u{1112}\u{1161}\u{11AB}"        // ㅎ,ㅏ,ㄴ
print(precomposed)
print(decomposed)

// 문자 개수 세기
// 문자열 안의 문자 개수는 count property를 이용하여 구합니다.

// 문자열 수정
// By Index
// Index는 0부터 시작함에 유의!
let greeting = "Guten Tag!"
print(greeting[greeting.startIndex])
print(greeting[greeting.index(before: greeting.endIndex)])
print(greeting[greeting.index(after: greeting.startIndex)])
let index = greeting.index(greeting.startIndex, offsetBy: 7)
print(greeting[index])
// endIndex는 끝을 가리키는 것이 아닌 끝 다음 인덱스를 가리킨다.
// startIndex는 0번째 Index를 가리킨다.
print(greeting[greeting.startIndex])

// 문자열의 개별 문자에 index로 접근하기 위한 프로퍼티: indices
for index in greeting.indices{
    print("\(greeting[index])", terminator: " ")
}

// 문자의 삽입과 삭제
var welcome = "hello"
welcome.insert("!", at: welcome.endIndex)
print(welcome)
// at과 before를 동시에 사용하면 2개 앞에 insert 된다.
welcome.insert(contentsOf: " there", at: welcome.index(before: welcome.endIndex))
print(welcome)
// 문자열 개별 삭제
welcome.remove(at: welcome.index(before: welcome.endIndex))
print(welcome)
// 문자열 범위 삭제
let range = welcome.index(welcome.endIndex, offsetBy: -6)..<welcome.endIndex
welcome.removeSubrange(range)
print(welcome)

// 부분 문자열
// 문자열에서 부분 문자열을 얻기 위해 prefix(_:)와 같은 서브스크립트 메소드를 이용
// 해당 메소드를 사용하여 얻은 부분 문자열은 SubString 인스턴스이다.
// 오랜기간 사용될 문자열이라면 String으로 캐스팅하여 String 인스턴스로 변환해주는 편이 좋다.
let greeting_2 = "Hello, World!"
let index_2 = greeting_2.firstIndex(of: ",") ?? greeting_2.endIndex
let beginning = greeting_2[..<index_2]
print(beginning)
print(type(of: beginning))
// 이렇게 새로운 string을 만들어주면 좋은 점!
// SubString같은 경우 원본 String을 참조해서 사용하기 때문에
// SubString을 계속 사용하는 경우 원본 String 또한 계속 메모리에 올라가 있기 때문이다.
// SubString 또한 String과 같이 StringProtocol을 따르기 때문에 메소드는 동일하다.
let newString = String(beginning)
print(newString)
print(type(of: newString))

// 문자열의 비교
// 문자열의 비교 역시 "==" / "!=" 를 사용합니다.
let firstWord = "hello"
let secondWord = "Bye"
let thirdWord = "hello"
if firstWord == secondWord{
    print("first = second")
}
else if firstWord == thirdWord{
    print("first = third")
}
// 만일 같은 대문자 A이더라도 영문자 A와 러시아어 A인 경우
// 유니코드가 다르기 때문에 다르다고 인식한다
// 알파벳 A : A(U+0041)
// 러시아어 A : A(U+0410)

// 접두사와 접미사 (prefix / suffix)
let romeoAndJuliet = [
    "Act 1 Scene 1: Verona, A public place",
    "Act 1 Scene 2: Capulet's mansion",
    "Act 1 Scene 3: A room in Capulet's mansion",
    "Act 1 Scene 4: A street outside Capulet's mansion",
    "Act 1 Scene 5: The Great Hall in Capulet's mansion",
    "Act 2 Scene 1: Outside Capulet's mansion",
    "Act 2 Scene 2: Capulet's orchard",
    "Act 2 Scene 3: Outside Friar Lawrence's cell",
    "Act 2 Scene 4: A street in Verona",
    "Act 2 Scene 5: Capulet's mansion",
    "Act 2 Scene 6: Friar Lawrence's cell"
]
// 해당 정보 중 Act 1이 얼마나 많은 지 알아내는 코드
var act1SceneCount = 0
var act2SceneCount = 0
for scene in romeoAndJuliet{
    if scene.hasPrefix("Act 1"){
        act1SceneCount += 1
    }
    else if scene.hasPrefix("Act 2"){
        act2SceneCount += 1
    }
}
print("""
There are \(act1SceneCount) scenes in Act 1
There are \(act2SceneCount) scenes in Act 2
""")

// 유니코드
// 문자열의 기반은 유니코드이다.
// 유니코드 문자가 텍스트 파일이나 다른 저장소에 쓰여질 때 유니코드의 인코딩 방식은 다양하다.
// 운영체제 또는 저장소에 따라 기본 인코딩 방식이 다를 수 있어 유의해야 함
// 특히 windows 운영체제와 mac의 기본 인코딩 방식이 다르기 때문에 유의해야 한다.
// 유니코드는 Character, UTF-8, UTF-16, Unicode Scalar Code Unit이 존재한다.
