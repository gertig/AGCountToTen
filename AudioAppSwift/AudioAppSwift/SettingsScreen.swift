import UIKit

class SettingsScreen: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray // Placeholder color
        title = "Settings" // If nav_bar: true was intended for a navigation controller

        // Add a dismiss button if presented modally without a nav bar providing one
        // Check if it's presented modally and if there's no navigation controller managing it
        if presentingViewController != nil && navigationController == nil {
            let dismissButton = UIButton(type: .system)
            dismissButton.setTitle("Dismiss", for: .normal)
            dismissButton.addTarget(self, action: #selector(dismissScreen), for: .touchUpInside)
            
            // Basic layout for the button
            dismissButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(dismissButton)
            
            NSLayoutConstraint.activate([
                dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                dismissButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                dismissButton.widthAnchor.constraint(equalToConstant: 100),
                dismissButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }

    @objc func dismissScreen() {
        dismiss(animated: true, completion: nil)
    }
}
