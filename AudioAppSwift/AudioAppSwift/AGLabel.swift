import UIKit

class AGLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }

    private func sharedInit() {
        self.textColor = .white
        // The font size 280 seems excessively large for a typical label.
        // It might be a direct translation from a different layout system (e.g. Mac OS)
        // or a specific design choice. For iOS, this will likely make text very big.
        // Adjust if needed based on actual UI requirements.
        self.font = UIFont.systemFont(ofSize: 280)
        self.textAlignment = .center
        self.backgroundColor = .clear
        // For very large fonts, ensure the label's frame is tall enough,
        // or consider using adjustsFontSizeToFitWidth if appropriate.
        // self.adjustsFontSizeToFitWidth = true
        // self.minimumScaleFactor = 0.1
    }
}
