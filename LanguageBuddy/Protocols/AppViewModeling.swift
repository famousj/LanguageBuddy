import Foundation

protocol AppViewModeling: ObservableObject {
    var messages: [Message] { get }    
}
