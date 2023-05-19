# ETtodayAssignment

## Design decision
* Implemented modular system by respecting S.O.L.I.D. principle to create feature (business), UI, API and Streaming layers and composing them in the composite layer. This way, they can be separated into different modules if needed.

#### Test suite
* Developed UI layer with TDD approach to guarantee UI acting as intended during development. Please refer to my side project [FindYourOnlysClone](https://github.com/h88377/FindYourOnlysClone) if you want to see how I implemented the whole app with TDD and test suite configuration.

#### Feature layer (Business logic)
* Defined feature abstraction components instead of concrete types. This way, the system can be more flexible when facing requirements changes by creating different implementations of the abstraction and composing them differently without altering the existed components.  

#### UI layer (Includes Presentation layer)
* Implemented MVVM as UI architecture to separate iOS-specific components (import UIKit) from feature logic (platform-agnostic) by using platform-agnostic presentation components (ViewModel). This way, the ViewModel can be reused across platforms if needed.
* Used RxSwift as binding strategy. 
* Implemented multiple MVVMs in one scene to avoid components holding too many responsibilities (massive view controller).

#### API/Streaming layer
* Hid the 3rd party/API/Streaming frameworks' details by depending on an layer-specific abstraction. This way, I can easily switch the frameworks based on the needs without altering current system.
* Separated the frameworks' details from business logic also make the framework components easy to test, develop and maintain since it just obeys the command.
* Created layer-specific models to avoid leaking framework-specific logic into feature layer. For instance, avoiding feature model to conform `Decodable` protocol.

#### Composite layer
* Acted as all layers' clients to initialize all components this application needs.
* Also decorated components differently based on the requirements.

## Libraries
* [Kingfisher](https://github.com/onevcat/Kingfisher) - Facilitated the image cache mechanism.
* [SnapKit](https://github.com/SnapKit/SnapKit) - Facilitated the UI layout.
* [RxSwift](https://github.com/ReactiveX/RxSwift) - Acted as binding strategy.

## Requirements
> pod install would be needed
> 
> Xcode 13 or later  
> iOS 15.0 or later  
> Swift 4 or later

## Contact
Wayne Cheng｜h88377@gmail.com   

## Licence
ETtodayAssignment is released under the MIT license.
