import Foundation


// Deinitialization
// 초기화 해지
// :Class Instance가 소멸되기 직전에 호출된다.
// Keyword로 "deinit"을 사용한다.


// 초기화 해지의 동작 - How Deinitialization Works
// Deinitializer는 Class당 하나만 선언이 가능하다.
// Swift는 원래 자동으로 자원을 해제해주는데 수동으로 해제해줘야하는 경우 deinitializer를 사용한다.
// Deinitializer는 수동으로 호출 할 수 없고 지정하면 자동으로 호출된다. 또한 SuperClass의 deinitializer는 subclass에서 자동으로 호출된다.
class Bank {
    static var coinsInBank = 10_000
    static func distribute(coins numberOfCoinsRequested: Int) -> Int {
        let numberOfCoinsToVend = min(numberOfCoinsRequested, coinsInBank)
        coinsInBank -= numberOfCoinsToVend
        return numberOfCoinsToVend  // 사용한 금액
    }
    static func receive(coins: Int) {
        coinsInBank += coins
    }
}
class Player {
    var coinsInPurse: Int
    init(coins: Int) {
        coinsInPurse = Bank.distribute(coins: coins)
    }
    func win(coins: Int) {
        coinsInPurse += Bank.distribute(coins: coins)
    }
    deinit {
        Bank.receive(coins: coinsInPurse)
    }
}
// << phase 1 >>
var playerOne: Player? = Player(coins: 100)
print("A new player has joined the game with \(playerOne!.coinsInPurse) coins")
// 사용자는 100 코인을 갖고 시작함
print("There are now \(Bank.coinsInBank) coins left in the bank")
// 현 시점에 은행은 9900의 코인을 소유함

// << phase 2 >>
playerOne!.win(coins: 2_000)
print("PlayerOne won 2000 coins & now has \(playerOne!.coinsInPurse) coins")
// 사용자가 게임에 이겨 2000코인을 받아 처음에 갖고 있던 100 코인과 더불어 현재 총 2100 코인을 소유함
print("The bank now only has \(Bank.coinsInBank) coins left")
// 사용자에게 2100 코인을 나눠준 은행에는 현재 7900 코인이 남음

// << phase 3 >>
// 객체를 nil로 설정하면 deinitializer가 활성화 된다.
// nil의 의미는 더 이상 instance를 사용하지 않는다는 의미이다.
playerOne = nil
print("PlayerOne has left the game")
// Prints "PlayerOne has left the game"
print("The bank now has \(Bank.coinsInBank) coins")
// Prints "The bank now has 10000 coins"
