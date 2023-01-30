import Foundation

// Type Casting
// 타입캐스팅은 인스턴스의 타입을 확인하거나 인스턴스를 같은 계층에 있는 다른 superclass나 subclass로 취급하는 방법이다.
// is와 as 연산자가 존재한다.
// 타입 캐스팅을 이용하면 특정 프로토콜을 따르는지(conforms) 확인할 수 있다.


// 타입캐스팅을 위한 클래스 계층구조 선언 (Defining a Class Hierachy for Type Casting)
class MediaItem {
    var name: String
    init(name: String) {
        self.name = name
    }
}

class Movie: MediaItem {
    var director: String
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}

class Song: MediaItem {
    var artist: String
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}

let library = [
    Movie(name: "Casablanca", director: "Micheal Curtiz"),
    Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
    Movie(name: "Citizen Kane", director: "Orson Welles"),
    Song(name: "The One And Only", artist: "Chesney Hawkes"),
    Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
]
// library의 type은 [MediaItem]으로 추론될 것이다.
// 가지고 있는 인스턴스의 공통 분모가 MediaItem이기 때문
// library를 순회하는 경우 배열의 아이템은 Movie, Song이 아니라 MediaItem 타입이다.
// 때문에 타입 지정을 위해 downCasting을 사용


// 형 확인 (Checking Type)
// is 연산자를 이용해 특정 인스턴스의 타입을 확인 할 수 있다.

// Example
var movieCount = 0
var songCount = 0

for item in library {
    if item is Movie {  // is를 통해서 Movie 형을 확인
        movieCount += 1
    } else if item is Song { // is를 통해서 item 형을 확인
        songCount += 1
    }
}

print("Media library contains \(movieCount) movies and \(songCount) songs")
// "Media library contains 2 movies and 3 songs" 출력


// DownCasting (다운캐스팅)
// 특정 클래스 타입의 상수나 변수는 특정 서브클래스의 인스턴스를 참조하고 있을 수 있다.
// as? as! 연산자를 이용해 어떤 타입의 인스턴스인지 확인 할 수 있다.
// as?는 특정 타입이 맞는지 확신할 수 없을 때 사용한다.
// as!는 특정 타입이 맞는지 확실할 수 있을 때 사용한다.

// Example
for item in library {
    if let movie = item as? Movie {
        print("Movie: \(movie.name), dir. \(movie.director)")
    } else if let song = item as? Song {
        print("Song: \(song.name), by \(song.artist)")
    }
}
// Casting은 실제 인스턴스나 값을 바꾸는 것이 아니라 지정 타입으로 취급하는 것 뿐이다.


// Any, AnyObject의 타입 캐스팅
// Any: 함수 타입을 포함해 모든 타입을 나타낸다.
// AnyObject: 모든 클래스 타입의 인스턴스를 나타낸다.

// Any Example
var things = [Any]()

things.append(0)
things.append(0.0)
things.append(42)
things.append(3.14159)
things.append("hello")
things.append((3.0, 5.0))
things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))
things.append({ (name: String) -> String in "Hello, \(name)" })

// iterater
for thing in things {
    switch thing {
    case 0 as Int:
        print("zero as an Int")
    case 0 as Double:
        print("zero as a Double")
    case let someInt as Int:
        print("an integer value of \(someInt)")
    case let someDouble as Double where someDouble > 0:
        print("a positive double value of \(someDouble)")
    case is Double:
        print("some other double value that I don't want to print")
    case let someString as String:
        print("a string value of \"\(someString)\"")
    case let (x, y) as (Double, Double):
        print("an (x, y) point at \(x), \(y)")
    case let movie as Movie:
        print("a movie called \(movie.name), dir. \(movie.director)")
    case let stringConverter as (String) -> String:
        print(stringConverter("Michael"))
    default:
        print("something else")
    }
}
