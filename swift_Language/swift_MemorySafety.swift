import Foundation

// Memory Safety

// Swift는 기본적으로 코드가 비정상적으로 동작하는 것을 막는 행위를 한다.
// 메모리가 해제된 값을 접근하는 것을 막는다거나, 인덱스의 한계를 넘는지를 확인하는 등의 비정상 동작이 존재한다.
// 이런 것과 마찬가지로 메모리의 같은 영역을 동시에 접근해서 충돌이 나지 않도록 관리해주는 역할도 하고 있다.
// 보통 메모리와 관련된 예외 처리는 Swift에서 알아서 처리하지만, 메모리 접근 충돌이 발생할 수 있는 잠재적인 상황을 이해하고 메모리 접근 충돌을 피하는 코드를 어떻게 작성할 수 있을지 알아야 한다.


// Understanding Conflicting Accesss to Memory
// A write access to the memory where one is stored.
var one = 1

// A read access from the memory where one is stored.
print("We're number \(one)!")

// Cuncurrent code 또는 Multi-Thread에서 동시성 문제로 많이 발생하는 문제이다.
// 하지만 여기서 다루는 문제는 싱글 스레드 상태일 때에 관한 문제이다.


// Characteristics of Memory Access
// 메모리 접근이 충돌 할 수 있는 3가지 상황
// 1. 최소 하나 이상의 쓰기 상황
// 2. 메모리의 같은 위치에 접근할 때
// 3. 접근 지속시간이 겹칠 때

// 메모리 접근의 지속시간은 둘로 나뉜다.
// 1. 즉각적인 접근 : 메모리에 접근 한 후 다른 곳에서의 메모리 접근이 불가능함을 의미한다.
// 2. 장기적인 접근

// 즉각적인 접근 예시
func oneMore(than number: Int) -> Int {
    return number + 1
}
// 여기서는 메모리 접근 충돌이 일어나지 않는다.
var myNumber = 1
// 메모리 쓰기
myNumber = oneMore(than: myNumber)
// 메모리 읽기
print(myNumber)
// Prints "2"


// Conflicting Access In-Out Parameters
var stepSize = 1
//
func increment(_ number: inout Int) {
    // number도 stepSize의 주소 값이기 때문에 값을 불러옴과 동시에 값을 주소 값에 쓰는 행위이기 때문에 오류가 발생한다.
    number += stepSize
}
//increment(&stepSize)
// Error: conflicting accesses to stepSize


// 위의 문제를 해결하기 위한 해결책
// 1. stepSize의 복사본을 만든다.
// Make an explicit copy.
var copyOfStepSize = stepSize
increment(&copyOfStepSize)

// Update the original.
stepSize = copyOfStepSize
// stepSize is now 2
print("stepSize: \(stepSize)")


// 장기 접근으로 인한 in-out parameter conflict Example
func balance(_ x: inout Int, _ y: inout Int) {
    let sum = x + y
    x = sum / 2
    y = sum - x
}
var playerOneScore = 42
var playerTwoScore = 30
balance(&playerOneScore, &playerTwoScore)  // OK
// balance(&playerOneScore, &playerOneScore)
// 읽기와 쓰기를 동시에 하게 되기 때문에 오류가 발생한다.
// Error: conflicting accesses to playerOneScore


// Conflicting Access to Self in Methods
struct Player {
    var name: String
    var health: Int
    var energy: Int

    static let maxHealth = 10
    mutating func restoreHealth() {
        health = Player.maxHealth
    }
}

extension Player {
    mutating func shareHealth(with teammate: inout Player) {
        //player 자신의 health와 teammate의 health를
        balance(&teammate.health, &health)
    }
}

var oscar = Player(name: "Oscar", health: 10, energy: 10)
var maria = Player(name: "Maria", health: 5, energy: 10)
oscar.shareHealth(with: &maria)  // OK
print("\(oscar.health)")
// oscar = (oscar + maria) / 2
print("\(maria.health)")
// maria = (oscar + maria) - oscar

// 자신의 체력을 동시에 쓰고자 하면 메모리에 중복 접근이 되어 오류가 발생한다.
// oscar.shareHealth(with: &oscar)
// Error: conflicting accesses to oscar


// Conflicting Access to Properties
var playerInformation = (health: 10, energy: 20)
var playerInfromation2 = ["health": 10, "energy": 20]
print(playerInfromation2["health"]!)

// 전역 변수로 할당된 변수 또한 메모리에 동시 접근하게 되는 경우 에러가 발생한다.
// balance(&playerInformation.health, &playerInformation.energy)
// Error: conflicting access to properties of playerInformation

var holly = Player(name: "Holly", health: 10, energy: 10)
// Player 객체로 선언하는 것 또한 전역 변수로 선언되기 때문에 동시에 접근하는 것은 불가능 하다.
// balance(&holly.health, &holly.energy)  // Error

func someFunction() {
    var oscar = Player(name: "Oscar", health: 10, energy: 10)
    // 전역 변수가 아닌 지역 변수에서는 에러가 발생하지 않는다.
    balance(&oscar.health, &oscar.energy)  // OK
}

someFunction()

// Swift는 멀티 스레드를 통한 병렬사고를 용이하게 하기 위해 메모리 동시 접근 시 전역 변수의 접근을 막고 있다.
// 이는 전역 변수에 여러 스레드가 접근할 수 있기 때문이다.
// 지역 변수는 하나의 스레드만 접근할 수 있기 때문에 문제가 발생하지 않는다.
// 하나의 스레드에서만 접근한다는 말은 같은 메모리를 참조하는 행위를 했을 때 여러 스레드에 나뉘어져 행동되는 것이 아니라 하나의 스레드에서 차례대로 동작하게 하기 때문에 Conflict가 발생하지 않는다고 이해할 수 있다.
