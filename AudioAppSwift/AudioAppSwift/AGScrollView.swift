import UIKit

class AGScrollView: UIScrollView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        // Optional: print statement for debugging, similar to the RubyMotion version.
        print("AGScrollView init")
        sharedInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // Optional: print statement for debugging.
        print("AGScrollView init(coder:)")
        sharedInit()
    }
    
    private func sharedInit() {
        // Common initialization code can go here if needed in the future.
        // For now, it's empty as the original RubyMotion version didn't
        // have shared UI setup beyond the print statement in the init.
        self.backgroundColor = .black // A common default for scroll views, can be changed
    }

    // Note: Delegate methods like scrollViewDidScroll, scrollViewDidEndDecelerating,
    // and rotation methods like shouldAutorotateToInterfaceOrientation
    // are typically handled by the UIScrollView's delegate (e.g., a UIViewController),
    // not within the UIScrollView subclass itself in Swift/iOS development.
}
