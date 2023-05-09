import Foundation

protocol AppViewModelable: ObservableObject {
    var messages: [Message] { get }    
}
