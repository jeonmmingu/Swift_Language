import Foundation

// Error Handling
// Swift에서는 런타임 에러가 발생한 경우 처리를 위해 에러의 발생(Throwing), 감지(catching), 증식(propagating), 조작(manipulating)을 지원하는 일급 클래스를 제공한다.


// 에러의 표시와 발생 (Representing and Throwing Errors)
// 게임안에서 판매기기의 동작에러를 정의
enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}


// Handling Errors
// 에러 처리
// 1. Error가 발생한 함수에서 리턴 값으로 에러를 반환해 해당 함수를 호출한 코드에서 에러를 처리하도록 하는 방법
// 2. Do-Catch 구문을 사용하는 방법
// 3. Optional 값을 반환하는 방법
// 4. Assert를 사용해 강제로 크래쉬를 발생시키는 방법 => 밑의 설명에서는 제외되었다. (에러가 발생한 부분에서 assert 함수를 호출하기만 하면 되는 방법이다.)


// 에러를 발생시키는 함수 사용하기 (Propagating Errors Using Throwing Functions)
// Throwing Function
// : 함수 내부에서 에러를 만들어 함수가 호출된 곳에 전달한다.

// 이런식으로 throwing 함수를 정의한다.
func canThrowErrors() throws -> String {
    return "canThrow"
}
// 아래와 같은 일반적인 함수에서는 에러를 발생시킬 수 없다.
// 즉 throw가 해당 함수 내에서 발생한다면 반드시 그 함수 내에서 처리가 되어야 한다.
func cannotThrowErrors() -> String {
    return "cannotThrow"
}

// Example
struct Item {
    var price: Int
    var count: Int
}

class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
    var coinsDeposited = 0
    
    func vend(itemNamed name: String) throws {
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }
        
        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }
        
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }
        
        coinsDeposited -= item.price
        
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        
        print("Dispensing \(name)")
    }
}

let favoriteSnacks = [
    "Alice": "Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels",
]
func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    try vendingMachine.vend(itemNamed: snackName)
}

struct PurchasedSnack {
    let name: String
    init(name: String, vendingMachine: VendingMachine) throws {
        try vendingMachine.vend(itemNamed: name)
        self.name = name
    }
}

let newVendingMachine = VendingMachine()
newVendingMachine.coinsDeposited += 100
for _ in 1...4 {
    try buyFavoriteSnack(person: "Alice", vendingMachine: newVendingMachine)
    print(newVendingMachine.coinsDeposited)
}


// Do-Catch 구문을 이용한 에러처리
// General Syntax Form
/*
 do {
 try expression
 statements
 } catch pattern 1 {
 statements
 } catch pattern 2 where condition {
 statements
 } catch {
 statements
 }
 */
// catch 구문 뒤에는 어떤 에러인지 적고 그것을 어떻게 처리할 지 명시할 수 있다.
// 만약 catch 구문 뒤에 어떤 에러인지 명시하지 않은 경우 모든 에러를 지역 상수인 error로 바인딩한다.

// Example: VendingMachineError 열거형의 모든 에러에 대해 처리하는 코드
var vendingMachine = VendingMachine()
vendingMachine.coinsDeposited = 8
do {
    try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
    print("Success! Yum.")
} catch VendingMachineError.invalidSelection {
    print("Invalid Selection.")
} catch VendingMachineError.outOfStock {
    print("Out of Stock.")
} catch VendingMachineError.insufficientFunds(let coinsNeeded) {
    print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
} catch {
    print("Unexpected error: \(error).")
}
// Prints "Insufficient funds. Please insert an additional 2 coins."
// 발생되는 에러는 애러를 발생시키지 않는 함수에서는 do-catch 구문에서 그 에러를 반드시 처리해야하고,
// 애러를 발생 시키는 함수는 에러를 do-catch 구문에서 처리하거나 함수를 호출한 곳에서 반드시 애러를 처리해야한다.
// 만약 에러가 발생한 곳에서 에러에 대해 아무런 처리도 하지 않는다면 런타임 에러가 발생하게 된다.

// Example2: 모든 VendingMachineError에 대해 기술하는 것 대신 처리하는 다른 방법
// 이런 식으로 표현하는 이유는 모든 에러들에 대해서 처리해주기 힘들기 때문이다.
// 대표적으로 많이 발생하는 에러나 예상되는 에러들에 대해서 우선적으로 묶어서 처리해주도록 하고,
// 나머지 에러들에 대해서는 unexpected error로 구분하여 처리해주도록 한다.
func nourish(with item: String) throws {
    do {
        try vendingMachine.vend(itemNamed: item)
    } catch is VendingMachineError {    // 모든 VendingMachineError 구분을 위해 is를 사용
        print("Invalid selection, out of stock, or not enough money.")
    }
}
// catch is => 기본적으로 catch는 error를 잡아내는데 error들 중에서 VendingMachineError를 처리하고 싶은 것이기 때문에 이런 식으로 표현을 한다.
do {
    try nourish(with: "Beet-Flavored Chips")
} catch {
    print("Unexpected non-vending-machine-related error: \(error)")
    // 어떤 에러인지 알고 싶은 경우 이런식으로 \(error)로 표시할 수 있다.
    // 여기에서 처럼 catch를 그냥 if-else에서 else 같이 사용 가능
}
// Prints "Invalid selection, out of stock, or not enough money."


// 에러를 옵셔널 값으로 변환하기 (Converting Errors to Optional Values)
// try? syntax를 사용해 에러를 옵셔널 값으로 변환할 수 있다.
// 만약 try? expression 안에서 에러가 발생한 경우 그 표현의 반환 값은 nil이 된다.

// Example
/*
    func someThrowingFunction() throws -> Int {
        // ...
    }

    let x = try? someThrowingFunction()

    let y: Int?
    do {
        y = try someThrowingFunction()
    } catch {
        y = nil
    }
*/
// try? 를 사용하는 이유는 발생하는 모든 에러들을 같은 방법으로 처리하고 싶을 때 유용하기 때문이다.
// 예를 들어, 아래 코드는 데이터를 가져오는 여러 접근 방법을 시도하는데 접근 방법이 모두 실패한다면 nil을 반환한다.
/*
    func fetchData() -> Data? {
        if let data = try? fetchDataFromDisk() { return data }
        if let data = try? fetchDataFromServer() { return data }
        return nil
    }
*/


// 에러 발생을 중지하기 (Disabling Error Propagation)
// 에러 발생을 중지한다는 것은 에러를 발생시키는 함수를 사용할 때 에러와 관련된 로직들을 생략한다는 의미이다.
// 이는 try! syntax를 이용하여 처리할 수 있다.
// 정말 에러가 발생하지 않는게 확실한 경우에는 이런 식으로 code를 작성하고 에러 발생의 여지가 있는 경우에는 확인하며 코딩하는 것이 좋다.


// 정리 액션 기술 (Specifying Cleanup Actions)
// defer syntax를 이용해 함수가 종료 된 후 파일 스트림을 닫거나, 사용했던 자원을 해지 하는 등의 일을 할 수 있다.
// defer가 여러 개가 있는 경우 가장 마지막 줄부터 실행된다. -> 'Bottom-up' 방식으로 진행된다.
/*
    func processFile(filename: String) throws {
        if exists(filename) {
            let file = open(filename)
            defer {
                close(file) // block이 끝나기 직전에 실행, 주로 자원 해제나 정지에 사용
            }
            while let line = try file.readline() {
                // Work with the file.
            }
            // close(file) is called here, at the end of the scope.
        }
    }
*/
// 위의 코드에서 defer 구문을 이용해 open(:) 함수와 짝을 이루는 close(:) 함수를 실행한다.
// defer 구문은 에러 처리 이외의 경우에도 사용할 수 있다.
