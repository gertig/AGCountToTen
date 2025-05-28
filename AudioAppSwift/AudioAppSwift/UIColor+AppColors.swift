import UIKit

extension UIColor {

    // MARK: - Custom App Colors

    static var agBlue: UIColor {
        return UIColor.color(fromHexString: "#3b99b1")
    }

    static var agGreen: UIColor {
        return UIColor.color(fromHexString: "#26972b")
    }

    static var agLightBlue: UIColor {
        return UIColor.color(fromHexString: "#6ccbce")
    }

    static var agLightGreen: UIColor {
        return UIColor.color(fromHexString: "#9bd146")
    }

    static var agRed: UIColor {
        return UIColor.color(fromHexString: "#b04f4b")
    }

    static var agPink: UIColor {
        return UIColor.color(fromHexString: "#da6bc8")
    }

    static var agOrange: UIColor {
        return UIColor.color(fromHexString: "#FF8A19")
    }

    static var agPurple: UIColor {
        return UIColor.color(fromHexString: "#7b46d1")
    }

    static var agVeryLightBlue: UIColor {
        return UIColor.color(fromHexString: "#c8dff1")
    }

    static var agDarkBlue: UIColor {
        return UIColor.color(fromHexString: "#6899be")
    }

    static var agVeryLightGreen: UIColor {
        return UIColor.color(fromHexString: "#98e5b2")
    }

    static var agDarkGreen: UIColor {
        return UIColor.color(fromHexString: "#4cb26e")
    }

    static var agRedBrown: UIColor {
        return UIColor.color(fromHexString: "#633021")
    }

    // MARK: - Private Helper Function

    private static func color(fromHexString hexString: String) -> UIColor {
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count != 6) && (cString.count != 8) { // Check for 6 (RGB) or 8 (ARGB)
            return UIColor.black // Default color for invalid hex string
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        let red, green, blue, alpha: CGFloat
        
        if cString.count == 8 { // ARGB
            alpha = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
            red   = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
            green = CGFloat((rgbValue & 0x0000FF00) >> 8)  / 255.0
            blue  = CGFloat(rgbValue & 0x000000FF)        / 255.0
        } else { // RGB
            alpha = 1.0
            red   = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgbValue & 0x00FF00) >> 8)  / 255.0
            blue  = CGFloat(rgbValue & 0x0000FF)        / 255.0
        }
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
