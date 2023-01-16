import Foundation

// 프로퍼티 (property)

// 프로퍼티의 종류
// 1. 저장된 프로퍼티 - 값을 저장하는 프로퍼티
// 2. 계산된 프로퍼티 - 값을 계산하는 프로퍼티
// 저장 프로퍼티는 클래스 또는 구조체에서만 사용 가능
// 계산된 프로퍼티는 클래스, 구조체, 열거형 모두 사용 가능
// 추가로 프로퍼티 옵저버를 정의해서 값이 변할 때 마다 모니터링 할 수 있다.


// 저장 프로퍼티 (stored property)
struct FixedLengthRange {
    var firstValue: Int
    let length: Int
}

// 변수 구조체 인스턴스의 프로퍼티 변경 - 가능
var rangeOfThreeItems = FixedLengthRange(firstValue: 0, length: 3)
// 범위 값은 0, 1, 2 이다.
rangeOfThreeItems.firstValue = 6
// 범위 값은 6, 7, 8 이다.

// 상수 구조체 인스턴스의 프로퍼티 변경 - 불가능
let rangeOfFourItems = FixedLengthRange(firstValue: 0, length: 4)
// 범위 값은 0, 1, 2, 3 입니다.
// rangeOfFourItems.firstValue = 6


// 지연 저장 프로퍼티 (Lazy stored property)
// 지연 프로퍼티로 선언하고 싶은 경우 앞에 Lazy 키워드를 붙여주면 된다.
// '지연'의 의미는 해당 프로퍼티가 처음 사용될 경우에 계산을 시작한다는 의미입니다.
// 때문에 지연 저장 프로퍼티는 초기 값을 가지고 있지 않습니다.
// 그리고 지연 프로퍼티는 초기 값을 지니지 않아야 하기 때문에 var로 선언해야 합니다.
// << 사용 예시 >>
// 1. 프로퍼티가 특정 요소에 의존적이어서 그 요소가 끝나기 전까지 적절한 값을 초기화 하지 못하는 경우
// 2. 초기화 시, 복잡한 연산이나 부하가 걸리는 작업이 필요 되어지는 경우 필요시에만 초기화 하여 부하를 방지하고자 할 때도 많이 사용된다.
class DataImporter {
    /*
        DataImporter는 외부 파일에서 데이터를 가져오는 클래스
         이 클래스는 초기화 하는데 매우 많은 시간이 소요된다고 가정
     */
    var filename = "data.txt"
    // 데이터를 가져오는 기능의 구현이 이 부분에 구현돼 있다고 가정
}

class DataManager {
    lazy var importer = DataImporter()
    var data = [String]()
    // 데이터를 관리하는 기능이 이 부분에 구현돼 있다고 가정
}

let manager = DataManager()
manager.data.append("Some data")
manager.data.append("Some more data")
print(manager.data)
// DataImporter 인스턴스는 이 시점에 생성돼 있지 않습니다.
print(manager.importer.filename)
// 이렇게 한번 접근하고 나면 인스턴스가 생성된다.


// 계산된 프로퍼티 (Stored Property)
struct Point {
    var x = 0.0, y = 0.0
}
struct Size {
    var width = 0.0, height = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
}
// square center getter 에 의해 center 프로퍼티가 계산 됨
var square = Rect(origin: Point(x: 0.0, y: 0.0),
                  size: Size(width: 10.0, height: 10.0))

// square center setter 에 의해 center 프로퍼티가 계산 됨
square.center = Point(x: 15.0, y: 15.0)

// "square.origin is now at (10.0, 10.0)" 출력
print("square.origin is now at (\(square.origin.x), \(square.origin.y))")


// setter 선언의 간략한 표현 (short-hand expression)
// setter 의 인자를 정해주지 않는 경우 새로운 인자를 newValue라고 받는다.
struct AlternativeRect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set {
            origin.x = newValue.x - (size.width / 2)    // newValue == 인자 값
            origin.y = newValue.y - (size.height / 2)   // newValue == 인자 값
        }
    }
}


// 읽기전용 계산된 프로퍼티 (Read-Only Computed Property
// getter를 이용해 처음에 값을 계산받지만, setter가 존재하지 않아 후에 새로운 계산을 할 수 없는 프로퍼티
// get만 가능하고 set이 불가능한 프로퍼티를 의미한다.
// * 계산된 프로퍼티는 후에 getter 혹은 setter에 의해 값이 변할 수 있기 때문에 var 키워드를 붙여 변수로 선언해야한다.
// * 읽기전용 계산된 프로퍼티 또한 후에 getter를 통해 값이 변할 수 있기 때문에 var 키워드를 붙여 변수로 선언해야한다.
struct Cuboid {
    var width = 0.0, height = 0.0, depth = 0.0
    var volume: Double {
        return width * height * depth
    }
}
let fourByFiveByTwo = Cuboid(width: 4.0, height: 5.0, depth: 2.0)
print("the volume of fourByFiveByTwo is \(fourByFiveByTwo.volume)")
// "the volume of fourByFiveByTwo is 40.0" 출력


// 프로퍼티 옵저버 (Property Observer)
// 프로퍼티에 새 값이 할당 될 때 (set) 해당 이벤트를 감시할 수 있는 것이 옵저버 이다.
// 옵저버의 종류
// 1. willset - 값이 할당 되기 바로 직전에 호출되는 옵저버
// 2. didset - 값이 할당 되고 난 후에 호출되는 옵저버
// 즉, set event를 감지하며 설정된 setter 코드 블록을 호출하는 것을 옵저버라고 한다.
// func parameter중 in-out 파라미터 같은 경우 기존에 있던 변수의 주소 값을 통해 값을 변경하기 때문에 해당 함수를 사용하는 경우 willset과 didset이 항상 실행된다.
class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("About to set totalSteps to \(newTotalSteps)")
        }
        didSet {
            if totalSteps > oldValue  { // oldValue == 기본 연산자
                print("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}
let stepCounter = StepCounter()
stepCounter.totalSteps = 200
// About to set totalSteps to 200
// Added 200 steps
stepCounter.totalSteps = 360
// About to set totalSteps to 360
// Added 160 steps
stepCounter.totalSteps = 900
// About to set totalSteps to 896
// Added 536 steps


// 전역변수와 지역변수
// 계산된 프로퍼티와 프로퍼티 옵저버 기능은 전역변수와 지역변수 모두에서 실행 할 수 있습니다.
// 1. 전역변수: 클로저, 함수, 메서드, 코드 컨텍스트 바깥에 정의되어 있는 변수를 의미.
// 2. 지역변수: 클로저, 함수, 열거형 등등의 내부에 정의된 변수를 의미.


// 타입 프로퍼티 (Type Property)
// 인스턴스 프로퍼티와 다른 개념이다.
// 인스턴스 프로퍼티는 새로운 인스턴스가 생성 될 때마다 새로운 프로퍼티가 지속적으로 생겨난다.
// 타입 프로퍼티는 특정 타입에 속한 프로퍼티로 그 타입에 해당하는 단 하나의 프로퍼티만 존재한다.
// 또한 인스턴스에서는 타입 프로퍼티에 접근이 불가능하다.

// 타입 프로퍼티 Syntax
// 기본적으로 타입 프로퍼티를 선언하기 위해서 static keyword를 사용한다.
// Class 같은 경우에는 static과 class kewword를 사용한다.
// Class 에서 static으로 타입 프로퍼티를 설정하면 서브클래스의 override가 불가능하게 된다.
// 반면 class로 타입 프로퍼티를 설정하면 서브클래스의 override가 가능하게 된다.
struct SomeStructure {
    static var storedTypeProperty = "Some value."
    // return 값을 달아준 것은 computed property라는 것을 명시하기 위함이다.
    static var computedTypeProperty: Int {
        return 1
    }
}
enum SomeEnumeration {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 6
    }
}
class SomeClass {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 27
    }
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}
// 인스턴스와 무관하게 기본적으로 갖는 프로퍼티를 의미 !!!
print(SomeStructure.storedTypeProperty)
// Prints "Some value."
SomeStructure.storedTypeProperty = "Another value."
print(SomeStructure.storedTypeProperty)
// Prints "Another value."
print(SomeEnumeration.computedTypeProperty)
// Prints "6"
print(SomeClass.computedTypeProperty)
// Prints "27"

// 타입 프로퍼티 얘시 - audio channel
// 타입 프로퍼티는 인스턴스에 접근이 불가능하다.
struct AudioChannel {
    static let thresholdLevel = 10
    static var maxInputLevelForAllChannels = 0
    var currentLevel: Int = 0 {
        didSet {
            if currentLevel > AudioChannel.thresholdLevel {
                // cap the new audio level to the threshold level
                currentLevel = AudioChannel.thresholdLevel
            }
            if currentLevel > AudioChannel.maxInputLevelForAllChannels {
                // store this as the new overall maximum input level
                AudioChannel.maxInputLevelForAllChannels = currentLevel
            }
        }
    }
}
var leftChannel = AudioChannel()
var rightChannel = AudioChannel()

leftChannel.currentLevel = 7
print(leftChannel.currentLevel)
// Prints "7"
print(AudioChannel.maxInputLevelForAllChannels)
// Prints "7"

rightChannel.currentLevel = 11
print(rightChannel.currentLevel)
// Prints "10"
print(AudioChannel.maxInputLevelForAllChannels)
// Prints "10"
// 위와 같은 방식으로 여러 인스턴스에 대해 constraint를 공통된 생성하고자 할 때 유용하게 사용된다.
