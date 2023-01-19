import Foundation

// Class는 method, properties, other charcterize 들을 다른 클래스로부터 상속 할 수 있다.
// 이것이 Swift에서 Class가 다른 자료형과 구분되는 특징이다.
// Class는 상속 받은 프로퍼티가 저장된 프로퍼티이던 계산된 프로퍼티이던 상관없이 프로퍼티 옵저버를 설정할 수 있다.


// Defining a base classes
// Base class란 아무것도 상속받지 않은 초기의 클래스를 의미한다.
// Objective-C에서는 NSObject 클래스로 부터 상속받은 후 superclass로 지정해줘야 했지만
// Swift에서는 그냥 선언하면 superclass 설정이 된다.
class Vehicle {
    var currentSpeed = 0.0
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    func makeNoise() {
        // do nothing - an arbitrary vehicle doesn't necessarily make a noise
    }
}
let someVehicle = Vehicle()
print("Vehicle: \(someVehicle.description)")
// Vehicle: traveling at 0.0 miles per hour


// Subclassing
// 서브클래싱, 즉 상속은 부모로 부터 프로퍼티들을 상속받고 자기 자신의 고유 특성도 추가할 수 있다.
class Bicycle: Vehicle {
    var hasBasket = false
}
let bicycle = Bicycle()
bicycle.hasBasket = true
bicycle.currentSpeed = 15.0
print("Bicycle: \(bicycle.description)")
// Bicycle: traveling at 15.0 miles per hour


// Subclass를 Subclassing 하기
// 이렇게 상속받은 class를 다시 상속할 수도 있다.
// 이럴 경우 Bicycle은 부모 Class, Vehicle은 조부모 Class라고 표현한다.
class Tandem: Bicycle {
    var currentNumberOfPassengers = 0
}
let tandem = Tandem()
tandem.hasBasket = true
tandem.currentNumberOfPassengers = 2
tandem.currentSpeed = 22.0
print("Tandem: \(tandem.description)")
// Tandem: traveling at 22.0 miles per hour


// 오버라이딩 (Overriding)
// 오버라이딩은 부모 Class에서 상속받은 것들을 재정의 하는 것을 의미한다.
// 오버라이딩은 인스턴스 메소드, 타입 메소드, 인스턴스 프로퍼티, 타입 프로퍼티, 서브스크립트 모두에 대해 가능함
// 오버라이딩을 사용하고자 하는 것 앞에 'override' 키워드를 붙여주면 된다.


// Overriding Methods
class Train: Vehicle {
    override func makeNoise() {
        print("Choo Choo")
    }
}
let train = Train()
train.makeNoise()


// Overriding Properties
// 프로퍼티를 오버라이드 시, 프로퍼티의 이름과 타입을 명시해야한다.
// 프로퍼티는 상속 받을 때 단순히 상속받은 특정 형의 프로퍼티가 있다는 것 정도만 알고 있기 때문이다.
// 계산된 프로퍼티에서 읽기 전용 -> 읽/쓰기 로 변경은 가능하지만 반대는 안된다.
// 만약 setter를 오버라이드 해서 사용한다면 getter도 제공 해야한다.
class Car: Vehicle {
    var gear = 1
    override var description: String {
        // super.description 이 string이기 때문에 이런 표현이 가능하다.
        return super.description + " in gear \(gear)"
    }
}
let car = Car()
car.currentSpeed = 25.0
car.gear = 3
print("Car: \(car.description)")


// Overriding Property Observer
// 부모클래스에 생성된 프로퍼티 옵저버도 overriding이 가능하다.
// 상수 프로퍼티와 읽기 전용 프로퍼티는 옵저버를 상속하여 바꿔 붙일 수 없다.
// -> 이름 그대로 set을 못하기 때문
// 옵저버를 추가하고 setter를 동시에 추가하는 것은 불가능하다. -> 둘 다 옵저버 역할을 하기 때문.
class AutomaticCar: Car {
    // 부모의 저장된 프로퍼티에 옵저버를 단 예시
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 10.0) + 1
        }
    }
}
let automatic = AutomaticCar()
automatic.currentSpeed = 35.0
print("AutomaticCar: \(automatic.description)")


// Preventing Overrides
// 모든 자료형 앞에 final 이라는 keyword를 붙이면 더 이상 상속할 수 없게 된다.
// 이에 대한 오류는 runtime에서 error를 검출한다.
class oneWheel: Car {
    final var numberOfWheel : Int {
        return 3
    }
}
class specialCar : oneWheel{
//    override var numberOfWheel : Int {
//        return 4
//    }
    // Property overrides a 'final' property 라는 에러문구가 출력된다.
}

