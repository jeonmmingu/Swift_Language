import Foundation

// Optional Chaining
// 옵셔널 체이닝은 nil일 수도 있는 프로퍼티, 메소드 그리고 서브스크립트에 질의(query)하는 과정을 말한다.
// 질의를 연결해서 연결된 질의를 만들 수 있는데 연결된 질의중에서 어느 하나라도 nil이면 전체 결과는 nil이 된다.


// Optional Chaining as an Alternative to Forced Unwrapping
// 강제 언래핑을 사용하는 경우 만약 값이 nil값이 반환되는 경우 런타임 에러가 발생하는데, 옵셔널 체이닝을 사용하면 nil을 반환한다는 점이 차이점이다.
// 옵셔널 체이닝에 의해 nil 값이 호출 될 수 있기 때문에 옵셔널 체이닝의 값은 항상 Optional이 된다.
// 옵셔널 값을 반환하지 않는 프로퍼티, 메서드 혹은 서브스크립트를 호출하더라도 옵셔널 체이닝에 의해 옵셔널 값이 반환된다.
// 이러한 옵셔널 값을 확인하여 옵셔널 체이닝이 성공적으로 실행 됬는지 nil을 반환 했는지 확인할 수 있다.

// 옵셔널 체이닝에 의해 호출되면 반환 값과 같은 타입에 옵셔널(?)이 붙어 반환 된다.
class Person {
    var residence: Residence?
}

class Residence {
    var numberOfRooms = 1
}

// john은 residence 프로퍼티가 nil인 값을 소유한다.
let john = Person()

// 만약 여기서 john의 residence의 numberOfRooms에 접근하기 위해 강제 언래핑을 사용한다면 런타임 에러가 발생한다.
// let roomCount = john.residence!.numberOfRooms

// 그렇기 때문에 이런 경우 옵셔널 체이닝을 활용한다.
if let roomCount = john.residence?.numberOfRooms {
    print("John's residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}

// numberOfRooms는 Optional Value가 아니지만 residence와 체이닝 되어있기 때문에 optional 값을 반환하게 된다.
print(type(of: john.residence?.numberOfRooms))

// nil이었던 residence 값에 Residence 인스턴스를 생성해 추가
john.residence = Residence()
if let roomCount = john.residence?.numberOfRooms {
    print("John's residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}
// 여기서 roomCount는 Int? 값인 1을 반환한다.


// Defining Model Classes for Optional Chaining
// 옵셔널 체이닝은 한 단계가 아닌 여러 레벨로 사용할 수 있다. (multilevel optional chaining)
class Person2 {
    var residence : Residence2?
}

class Room {
    let name: String
    init(name: String) { self.name = name }
}

class Address {
    var buildingName: String?
    var buildingNumber: String?
    var street: String?
    func buildingIdentifier() -> String? {
        if let buildingNumber = buildingNumber, let street = street {
            return "\(buildingNumber) \(street)"
        } else if buildingName != nil {
            return buildingName
        } else {
            return nil
        }
    }
}

class Residence2 {
    var rooms = [Room]()
    var numberOfRooms: Int {
        return rooms.count
    }
    subscript(i: Int) -> Room {
        get {
            return rooms[i]
        }
        set {
            rooms[i] = newValue
        }
    }
    func printNumberOfRooms() {
        print("The number of rooms is \(numberOfRooms)")
    }
    var address: Address?
}


// Accessing properties through Optional Chaining
let johnYeom = Person2()
if let roomCount = johnYeom.residence?.numberOfRooms {
    print("John's residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}

func createAddress() -> Address {
    print("Function was called.")
    let someAddress = Address()
    someAddress.buildingNumber = "29"
    someAddress.street = "Acacia Road"
    
    return someAddress
}
// johnYeom.residence = Residence2()
// johnYeom.residence? 값이 nil 값이 나오기 때문에 run-time error는 발생하지 않지만 nil 값이 찍히는 것을 확인 할 수 있다.
// 또한 create func이 실행되지 않고 값이 아예 할당되지 않는 모습을 볼 수 있다.
// 여러개의 optional 값이 chaining 되어 있을 때 하나라도 nil이면 nil 값이 출력된다.
// 즉 다른 언어처럼 null 값 안의 프로퍼티에 접근할 때랑 다른 개념이다. (강제 언래피과 유사)
johnYeom.residence?.address = createAddress()
if let buildingInfo = johnYeom.residence?.address?.buildingIdentifier() {
    print(buildingInfo)
} else {
    print("sorry bro")
}


// Call Methods Through Optional Chaining
// 기본적으로 반환 값을 명시하지 않은 optional chaining 같은 경우 void 값을 반환한다.
if johnYeom.residence?.printNumberOfRooms() != nil {
    print("It was possible to print the number of rooms.")
} else {
    print("It was not possible to print the number of rooms.")
}
// Prints "It was not possible to print the number of rooms."


// Accessing Subscript Through Optional Chaining
// Optional Value의 Subscript에 접근할 때는 [] 앞에 ?를 붙여 접근하면 된다.
if let firstRoomName = johnYeom.residence?[0].name {
    print("The first room name is \(firstRoomName).")
} else {
    print("Unable to retrieve the first room name.")
}
// Prints "Unable to retrieve the first room name."

// Example : johnsHouse : Residence()
let johnsHouse = Residence2()
johnsHouse.rooms.append(Room(name: "Living Room"))
johnsHouse.rooms.append(Room(name: "Kitchen"))
johnYeom.residence = johnsHouse

if let firstRoomName = johnYeom.residence?[0].name {
    print("The first room name is \(firstRoomName).")
} else {
    print("Unable to retrieve the first room name.")
}
// Prints "The first room name is Living Room."


// Accessing Subscripts of Optional Type
var testScores = ["Dave": [86, 82, 84], "Bev": [79, 94, 81]]
testScores["Dave"]?[0] = 91
testScores["Bev"]?[0] += 1
testScores["Brian"]?[0] = 72
// the "Dave" array is now [91, 82, 84] and the "Bev" array is now [80, 94, 81]


// Linking multiple levels of Chaining
// 다중 연결 시 하나라도 fail하는 level이 존재한다면 해당 chaining은 nil을 반환한다.


// Chaining on Methods with Optional Return Values
let johnsAddress = Address()
johnsAddress.buildingName = "The Larches"
johnsAddress.street = "Laurel Street"
johnYeom.residence?.address = johnsAddress

if let johnsStreet = johnYeom.residence?.address?.street {
    print("John's street name is \(johnsStreet).")
} else {
    print("Unable to retrieve the address.")
}
// Prints "John's street name is Laurel Street."
if let buildingIdentifier = johnYeom.residence?.address?.buildingIdentifier() {
    print("John's building identifier is \(buildingIdentifier).")
}
// Prints "John's building identifier is The Larches."

// If you want to try Additional action after Optional chaining
if let beginsWithThe =
    johnYeom.residence?.address?.buildingIdentifier()?.hasPrefix("The") {
    if beginsWithThe {
        print("John's building identifier begins with \"The\".")
    } else {
        print("John's building identifier does not begin with \"The\".")
    }
}
// Prints "John's building identifier begins with "The"."
