import Foundation

public func exampleOf(_ description: String, action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}
