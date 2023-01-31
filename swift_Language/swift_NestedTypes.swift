import Foundation

// 중첩 타입 (Nested Types)

// 열거형과 비슷하게 특정 문맥에서 좀 더 복잡한 타입을 위해 사용할 수 있는 유틸리티 클래스나 구조체를 정의 할 수 있다.
// Swift에서는 이 기능을 위해 중첩 타입(nested types)를 지원한다.
// 열거형, 클래스, 구조체를 그 타입 안에서 다시 정의할 수 있다.


// 중첩 타입의 사용 (Example)
struct BlackjackCard {

     // nested Suit enumeration
        // struct 안에 enum이 들어갈 수 있다.
     enum Suit: Character {
         case spades = "♠", hearts = "♡", diamonds = "♢", clubs = "♣"
     }

     // nested Rank enumeration
     enum Rank: Int {
         case two = 2, three, four, five, six, seven, eight, nine, ten
         case jack, queen, king, ace
         struct Values { // enum안에 struct가 들어가는 것도 가능합니다.
             let first: Int, second: Int?
         }
         var values: Values {
             switch self {
             case .ace:
                 return Values(first: 1, second: 11)
             case .jack, .queen, .king:
                 return Values(first: 10, second: nil)
             default:
                 return Values(first: self.rawValue, second: nil)
             }
         }
     }

     // BlackjackCard properties and methods
     let rank: Rank, suit: Suit
     var description: String {
         var output = "suit is \(suit.rawValue),"
         output += " value is \(rank.values.first)"
         if let second = rank.values.second {
             output += " or \(second)"
         }
         return output
     }
 }

let theAceOfSpades = BlackjackCard(rank: .ace, suit: .spades)
print("theAceOfSpades: \(theAceOfSpades.description)")
// Prints "theAceOfSpades: suit is ♠, value is 1 or 11"


// 중첩 타입의 언급 (Referring to Nested Types)
// 중첩 타입을 선언 밖에서 사용하기 위해선 시작부터 끝까지 명시를 해줘야 한다.
let heartsSymbol = BlackjackCard.Suit.hearts.rawValue
// heartsSymbol is "♡"
