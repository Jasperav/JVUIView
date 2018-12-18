import UIKit

public extension UIView {
    
    func setHuggingAndCompression(to: CGFloat){
        setContentHugging(to: to)
        setCompressionResistance(to: to)
    }
    
    func setContentHugging(to: CGFloat) {
        setContentHuggingPriority(UILayoutPriority(rawValue: UILayoutPriority.RawValue(to)), for: .horizontal)
        setContentHuggingPriority(UILayoutPriority(rawValue: UILayoutPriority.RawValue(to)), for: .vertical)
    }
    
    func setCompressionResistance(to: CGFloat) {
        setContentCompressionResistancePriority(UILayoutPriority(rawValue: UILayoutPriority.RawValue(to)), for: .horizontal)
        setContentCompressionResistancePriority(UILayoutPriority(rawValue: UILayoutPriority.RawValue(to)), for: .vertical)
    }
    
    func animateBackgroundColor(color: UIColor, duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.backgroundColor = color
        }
    }
    
    func removeSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    func removeLayers() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    func animateAlpha(newAlpha: CGFloat, duration: TimeInterval, options: UIView.AnimationOptions = .curveLinear) {
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.alpha = newAlpha
        })
    }
    
}
