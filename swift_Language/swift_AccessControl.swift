import Foundation

/* - MARK: Access Control

 1. 접근 제어는 특정 코드의 접근을 다른 소스파일이나 모듈에서 제한하는 것을 의미한다.
 2. 이렇게 하는 이유는 특정 코드의 세부적인 구현을 감추고 딱 필요한 만큼만 공개해 다른 곳에서 사용 가능하도록 하기 위함이다.
 3. 접근 제어는 Swift의 거의 모든 문법에서 가능하다.
 4. Swift에서는 기본 접근레벨을 제공하여 접근레벨의 처리를 용이하도록 한다.
 5. 단일 타깃 앱에서는 특별히 접근 레벨을 명시하지 않아도 된다.
 6. Public이 Private보다 높은 접근 레벨을 갖는다고 정의한다.
 
*/


/* - MARK: Module & Source File

 1. Module: 코드를 배포하는 단일의 단위를 의미한다.하나의 프레임워크나 앱이 이 단위로 배포되고 다른 모듈을 사용할 시 import keyword를 사용한다.
 1-1. Xcode의 build target은 Swift에서 분리된 단일 모듈로 취급된다.
 2. Source File: Module을 이루고 있는 여러 파일들 중 소스파일을 의미한다.

*/


/* - MARK: Access Level

// - MARK: Open & Public
 1. 둘 다 다른 모듈에서 import하여 사용할 수 있다.
 2. 다른 점은 Open은 오버라이딩 및 서브클래싱을 통해 함수 및 변수를 변형하여 사용 가능하지만, Public은 사용이 불가능하다.
 3. 가장 높은 접근 레벨이다.

// - MARK: Internal
 1. 기본 접근레벨로 아무 접근 레벨도 설정하지 않으면 Internal로 간주된다.
 2. Internal Level과 같은 경우 해당 모듈 전체에서 사용이 가능하도록 설정된다.
 3. 해당 모듈에서 사용이 가능하다는 것은 하나의 앱을 구성하는 타겟 안에서는 모두 사용이 가능한 코드라는 말이 된다.

// - MARK: File Private
 1. 특정 엔티티를 선언한 파일 안에서만 사용이 가능하다.
 2. 쉽게 설명하면 같은 소스파일 안에서만 해당 타입이 사용 가능함을 의미한다.

// - MARK: Private
 1. 특정 엔티티가 선언된 ({})안에서만 사용이 가능하다.
 2. 쉽게 말해 특정 클래스, 구조체, 열거형, 익스텐션에 한해 사용이 가능함을 이야기한다.
 3. 가장 낮은 접근 레벨이다.
 
*/


/* - MARK: Guiding Principle of Access Level
 
 1. Swift에서는 더 낮은 접근 수준을 가진 엔티티에 특정 엔티티를 선언해 사용할 수 없다는 일반 가이드의 원칙을 따른다.
 1-1. 예를 들어, Public 변수는 다른 internal, file-private, private 타입 등에서 정의될 수 없다. 왜냐하면 이렇게 되면 Public 변수는 Public 변수가 사용 될 곳들에서 사용이 불가해지기 때문이다.
 2. 함수에서는 parameter 혹은 return value보다 더 높은 접근 레벨을 가질 수 없다.
 2-1. 예를 들어, 함수가 더 높은 접근 레벨을 가진다고 가정하게 되면 함수에는 접근했는데 parameter 혹은 return value에 접근을 못해 함수를 사용할 수 없게 되기 때문이다.

// - MARK: Default Access Level
 1. 기본적으로 아무런 접근 레벨을 명시하지 않은 경우 Internal access Level을 가지게 된다.
 
// - MARK: Access Levels for Single-target App
 1. 단일 타깃 앱에서는 접근 레벨을 정의할 필요가 없지만, file-private 이나 private을 통해 앱 내에서 구현 사항을 숨길 수 있다.
 
// - MARK: Access Levels for Frameworks
 1. 프레임워크 개발 시, 다른 사람들이 해당 모듈에 접근 가능하도록 만들어야하기 때문에 public 혹은 open으로 만들어야 한다.
 2. 프레임워크 개발 시, 구현의 감추고 싶은 부분이 존재한다면 internal을 선언해 감추면 된다.
 
*/


/* - MARK: Access levels for Test Targets
 
 1. 기본적으로 open 혹은 public으로 지정된 엔티티만 외부 모듈에서 접근이 가능하다.
 2. 하지만 유닛 테스트를 하는 경우에 모듈을 import 하기 위해 import 앞에 @testable이라는 attribute을 사용하여 붙여주면 해당 모듈을 테스트가 가능한 모듈로 컴파일하여 사용한다.
 
*/


/* - MARK: Access Control Syntax
 
     /*
     public class SomePublicClass {}
     internal class SomeInternalClass {}
     fileprivate class SomeFilePrivateClass {}
     private class SomePrivateClass {}

     public var somePublicVariable = 0
     internal let someInternalConstant = 0
     fileprivate func someFilePrivateFunction() {}
     private func somePrivateFunction() {}
     */
 
 1. 위의 구조처럼 각 접근차를 변수 타입 앞에 선언해주어 접근자를 명시 할 수 있다.
 2. Interal 접근자는 생략하여 사용할 수 있다.
 
*/


/* - MARK: Custom Types

 1. 커스텀 클래스에 특정 접근 레벨을 부여하면 해당 클래스 안의 프로퍼티, 매소드 등 모든 멤버의 접근 권한에 영향을 미친다.
 2. Public Type은 기본적으로 Internal 맴버를 갖는다. 그 이유는 Framework 개발 시, 노출되면 안되는 API를 보호하기 위해서 설정되어 있는 것이다.
 2-1. 만약 Public Type안의 맴버를 public하게 사용하고 싶다면 public 접근자를 붙여주면 된다.
 
     /*
     public class SomePublicClass {                  // explicitly public class
         public var somePublicProperty = 0            // explicitly public class member
         var someInternalProperty = 0                 // implicitly internal class member
         fileprivate func someFilePrivateMethod() {}  // explicitly file-private class member
         private func somePrivateMethod() {}          // explicitly private class member
     }

     class SomeInternalClass {                       // implicitly internal class
         var someInternalProperty = 0                 // implicitly internal class member
         fileprivate func someFilePrivateMethod() {}  // explicitly file-private class member
         private func somePrivateMethod() {}          // explicitly private class member
     }

     fileprivate class SomeFilePrivateClass {        // explicitly file-private class
         func someFilePrivateMethod() {}              // implicitly file-private class member
         private func somePrivateMethod() {}          // explicitly private class member
     }

     private class SomePrivateClass {                // explicitly private class
         func somePrivateMethod() {}                  // implicitly private class member
     }
     */
 
*/


/* - MARK: Tuple Types
 
 1. 튜플 타입은 사용되는 클래스, 구조체, 열거형, 함수등에 따라 자동으로 최소 레벨을 부여받는다.
 2. 튜플은 가장 제한적인 레벨을 부여받기 때문에 명시적으로 접근자를 지정하지 않는다.
 
*/


/* - MARK: Function Types
 
 1. 함수 타입의 접근 레벨은 파라미터 타입과 리턴 타입의 접근 레벨을 고려해 가장 낮은 최소의 접근레벨 이하의 레벨을 사용 해야 한다.
 2. 그렇지 않으면 컴파일 시 에러를 발생시키게 된다.

 [Example]
 
 1. Make Error:
 func someFunction() -> (SomeInternalClass, SomePrivateClass) {
     // function implementation goes here
 }
 
 2. Fixed
 private func someFunction() -> (SomeInternalClass, SomePrivateClass) {
     // function implementation goes here
 }
 
*/


/* - MARK: Enumeration Types
 
 1. 열거형의 각 Case는 열거형의 접근 레벨과 같은 접근 레벨을 부여 받는다.
 2. 열거형의 각 Case는 개별적인 접근 레벨을 가질 수 없다.
 
*/


/* - MARK: Raw Values & Associate Value
 
 1. 고유 값과 연관 값을 사용하는 경우 반드시 해당 타입보다 높은 접근 레벨을 가져야한다.
 
// - MARK: Raw Values
 class Car: Int {
     case modelA = 0
     case modelB = 1
     case modelC = 2
 }
 
// - MARK: Associate Values
 class Animal {
     case dog(name: String)
     case cat(name: String)
 }
 
*/


/* - MARK: Nested Types

 1. 중첩 타입으로 선언 된 타입은 상위에 묶여있는 타입의 접근 레벨과 동일한 접근 레벨을 갖는다.
 2. 절대 더 낮은 접근 레벨을 갖을 수 없다.
 
*/


/* -MARK: SubClassing

 1. 서브클래스는 수퍼클래스보다 더 높은 접근 레벨을 가질 수 없다.
 1-1. 하지만 가끔 superClass보다 더 높은 접근 레벨을 갖는 경우가 있다. 예를 들어, 특정 method를 더 높은 접근 레벨로 오버라이드 했다고 가정했을 때, super.someMethod()를 호출하는 것이 가능하기 때문이다.
 1-2. 서브 클래스에서 super.someMethod()를 호출하는 코드를 넣게 되면 결국 그 매소드를 사용하려면 접근 레벨이 그만큼 낮아지기 때문에 이러한 행위가 가능해지는 것이다.

*/


/* - MARK: Constants, Variables, Properties and Subscripts
 
 1. 상수, 변수, 프로퍼티, 서브스크립트는 해당 타입보다 더 낮거나 높은 접근 레벨을 가질 수 없다.
 2. 즉 같은 접근 레벨 혹은 더 낮은 접근 레벨을 가져야 한다.
 
// - MARK: Getters & Setters
 1. 상수, 변수, 프로퍼티, 서브스크립트와 동일한 접근 레벨을 갖는다.
 2. 필요에 따라 Setter의 접근 레벨을 Getter의 접근 레벨보다 낮게 갖게 할 수 있다.
 
 - MARK: Set Setter's Access Level
 /*
  struct TrackedString {
      private(set) var numberOfEdits = 0
      var value: String = "" {
          didSet {
              numberOfEdits += 1
          }
      }
  }
 */
 - MARK: Set Getter's Access Level too
 /*
  public struct TrackedString {
      public private(set) var numberOfEdits = 0
      public var value: String = "" {
          didSet {
              numberOfEdits += 1
          }
      }
      public init() {}
  }
 */
 
*/


/* - MARK: Initializers
 
 1. 기본적으로 초기자의 접근 레벨은 해당 타입과 같거나 낮아야 한다.
 2. 예외적으로 지정 초기자(required initalizer)는 무조건 접근 레벨이 해당 타입과 같아야 한다.
 2-1. 만약 지정 초기자의 접근 레벨이 더 낮은 경우 지정 초기자를 초기화 할 수 없는 경우가 발생할 수 있기 때문이다.
 
// - MARK: Default Initializers
 1. 기본 초기자는 Public 타입의 초기자가 아닌 이상 해당 타입과 동일한 접근 레벨을 갖는다.
 2. 만약 public 타입으로 설정되어 있다면, 기본 초기자는 internal 접근 레벨을 기본적으로 갖는다.

// - MARK: Default Memberwise Initializers for Structure Types
 1. private, file-private 접근 레벨을 제외하고 다른 경우는 모두 internal level을 갖는다.
 2. 위의 두 경우에는 동일한 접근 레벨을 갖는다
 
*/


/* - MARK: Protocols
 
 1. 기본적으로 protocol의 접근 레벨과 그 안의 요구사항들의 접근 레벨은 동일하다.
 
// - MARK: Protocol Inheritance
 1. 이미 존재하는 프로토콜을 상속받은 경우 상속받은 프로토콜은 같은 접근 레벨을 갖는다.
 
// - MARK: Protocol Conformance
 1. 해당 프로토콜에 순응할 시, 프로토콜에서의 요구사항의 구현은 무조건 protocol의 접근레벨에 맞게 제어해줘야 한다.
 
*/


/* - MARK: Extensions
 
 1. 기존의 타입이 선언될 때 설정한 접근 레벨과 같은 레벨을 갖는다.
 2. 익스텐션에 명시적으로 접근자를 제어할 수 있다.
 3. 프로토콜의 Extension에서는 접근자를 제어할 수 없다.

// - MARK: Private Members of Extension
 1. 원본 선언에서 private 맴버로 선언한 것을 익스텐션에서 맴버로 접근할 수 있다.
 2. 하나의 익스텐션에서 private으로 설정한 맴버를 같은 파일의 다른 익스텐션에서 맴버로 접근할 수 있다.
 3. 하나의 익스텐션에서 private으로 선언한 맴버는 원본 선언에서 맴버로 사용할 수 있다.
 
*/


/* - MARK: Generic
 
 1. 지네릭 타입은 해당 타입 혹은 함수, 자체 파라미터 타입 중 최소 접근 레벨을 갖는다.
 
*/


/* - MARK: Type aliases
 
 1. 기존 타입을 다른 별칭으로 지정하는 타입은 본래의 타입이랑 같거나 낮은 접근 레벨을 갖는다.
 2. 예를 들어, private인 타입이 존재한다고 할 때 별칭 타입은 private, file-private, public, open, internal 타입으로 선언 할 수 있다.
 
*/
