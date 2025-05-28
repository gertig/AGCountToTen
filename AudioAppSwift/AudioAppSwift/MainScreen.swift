import UIKit
import AVFoundation // Required for playPageSound if Player needs it for errors etc.

class MainScreen: UIViewController, UIScrollViewDelegate {

    private let numbers = [10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1] // Looping numbers
    private var myScrollView: AGScrollView!
    private var audioPlayer: Player?
    // No direct @fileUrl, FileUrl instances will be created locally in methods.

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white // Default background

        setupScrollView()
        createPages()
        
        // Scroll to the first actual '1' (index 1) not the '10' at index 0
        scrollToPage(index: 1, animated: false)
        // Play sound for the initial page, which is '1'
        playPageSound(pageNumber: 1)
    }

    private func setupScrollView() {
        myScrollView = AGScrollView(frame: view.bounds)
        myScrollView.isPagingEnabled = true
        myScrollView.delegate = self
        
        let contentWidth = view.bounds.width * CGFloat(numbers.count)
        myScrollView.contentSize = CGSize(width: contentWidth, height: view.bounds.height)
        
        // Disable content inset adjustment for scroll view under navigation bars or tab bars
        myScrollView.contentInsetAdjustmentBehavior = .never
        
        view.addSubview(myScrollView)
    }

    private func createPages() {
        let labelHeight: CGFloat = 260 // As per AGLabel default, might need adjustment
        // Center label vertically, considering potential navigation bar or status bar.
        // Using view.bounds.height assumes full screen. If under a nav bar, view.safeAreaLayoutGuide might be better.
        let labelY = (view.bounds.height - labelHeight) / 2.0

        for (index, num) in numbers.enumerated() {
            let pageFrame = CGRect(x: view.bounds.width * CGFloat(index),
                                   y: 0,
                                   width: view.bounds.width,
                                   height: view.bounds.height)
            
            let wrapperView = UIView(frame: pageFrame)
            
            let numberLabelFrame = CGRect(x: 0, y: labelY, width: pageFrame.width, height: labelHeight)
            let numberLabel = AGLabel(frame: numberLabelFrame)
            numberLabel.text = "\(num)"
            
            configureColors(for: num, wrapperView: wrapperView, label: numberLabel)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePageTap(_:)))
            wrapperView.addGestureRecognizer(tapGesture)
            wrapperView.isUserInteractionEnabled = true
            
            wrapperView.addSubview(numberLabel)
            myScrollView.addSubview(wrapperView)
        }
    }

    @objc func handlePageTap(_ gesture: UITapGestureRecognizer) {
        let settingsScreen = SettingsScreen()
        settingsScreen.modalTransitionStyle = .flipHorizontal
        // .formSheet is good for iPads, on iPhone it's full screen by default unless customized.
        settingsScreen.modalPresentationStyle = .formSheet 
        present(settingsScreen, animated: true, completion: nil)
    }

    // MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Can be used for parallax effects or other scroll-time updates if needed.
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = myScrollView.frame.size.width
        // Calculate current page index based on content offset
        let currentPageIndex = Int(floor((myScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)

        if currentPageIndex == 0 { // User scrolled to the duplicate '10' at the beginning
            scrollToPage(index: numbers.count - 2, animated: false) // Go to actual '10' (second to last)
            playPageSound(pageNumber: 10)
        } else if currentPageIndex == numbers.count - 1 { // User scrolled to the duplicate '1' at the end
            scrollToPage(index: 1, animated: false) // Go to actual '1' (second item)
            playPageSound(pageNumber: 1)
        } else {
            // This will play sound for numbers[0] and numbers[numbers.count -1] if not handled by above conditions
            // However, the logic above should correctly redirect before this else is hit for those edge cases.
            playPageSound(pageNumber: numbers[currentPageIndex])
        }
    }

    // MARK: - Helper Methods

    private func scrollToPage(index: Int, animated: Bool) {
        guard index >= 0 && index < numbers.count else {
            print("Error: scrollToPage index \(index) is out of bounds.")
            return
        }
        let x = view.frame.size.width * CGFloat(index)
        let rect = CGRect(x: x, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        myScrollView.scrollRectToVisible(rect, animated: animated)
    }

    private func configureColors(for number: Int, wrapperView: UIView, label: AGLabel) {
        // Default alignment
        label.textAlignment = .center
        
        switch number {
        case 1:
            wrapperView.backgroundColor = UIColor.agLightGreen
            label.textColor = UIColor.agDarkGreen
        case 2:
            wrapperView.backgroundColor = UIColor.agVeryLightBlue
            label.textColor = UIColor.agDarkBlue
        case 3:
            wrapperView.backgroundColor = UIColor.agRed
            label.textColor = UIColor.agRedBrown
        case 4:
            wrapperView.backgroundColor = UIColor.agOrange
            label.textColor = .white
        case 5:
            wrapperView.backgroundColor = UIColor.agPurple
            label.textColor = .white
        case 6:
            wrapperView.backgroundColor = UIColor.agPink
            label.textColor = .white
        case 7:
            wrapperView.backgroundColor = UIColor.agGreen
            label.textColor = UIColor.agLightGreen
        case 8:
            wrapperView.backgroundColor = UIColor.agBlue
            label.textColor = UIColor.agLightBlue
        case 9:
            wrapperView.backgroundColor = UIColor.agDarkGreen
            label.textColor = UIColor.agVeryLightGreen
        case 10:
            wrapperView.backgroundColor = UIColor.agDarkBlue
            label.textColor = UIColor.agVeryLightBlue
            label.textAlignment = .left // Specific alignment for 10
        default:
            wrapperView.backgroundColor = .gray
            label.textColor = .white
        }
    }

    private func playPageSound(pageNumber: Int) {
        let fileName = String(pageNumber)
        let fileUrlHelper = FileUrl(fileName: fileName)

        var urlToPlay: URL?

        if fileUrlHelper.exists() {
            urlToPlay = fileUrlHelper.recorderFileURL
            print("Playing custom recording for \(fileName)")
        } else {
            urlToPlay = fileUrlHelper.defaultFileURL
            if urlToPlay != nil {
                print("Playing default sound for \(fileName)")
            } else {
                print("No default sound found for \(fileName)")
            }
        }

        if let finalURL = urlToPlay {
            audioPlayer?.stop() // Stop any currently playing sound
            audioPlayer = Player(recordingURL: finalURL) // loop is false by default
            if audioPlayer == nil {
                print("Failed to initialize player for URL: \(finalURL)")
            }
            audioPlayer?.play()
        } else {
            print("Could not find a sound file to play for page \(pageNumber).")
        }
    }
    
    // Ensure status bar is light content if view backgrounds are dark
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
