import UIKit

public extension CALayer {
    
    static let rotationKey = "rotate"
    
    func startRotation(duration360Degress: TimeInterval, repeatCount: Float = Float.infinity) {
        guard duration360Degress > 0.0 else { return }
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0.0
        animation.toValue = CGFloat(.pi * 2.0)
        animation.duration = duration360Degress
        animation.repeatCount = repeatCount
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.isRemovedOnCompletion = false
        add(animation, forKey: CALayer.rotationKey)
    }
    
    func animateOpacity(duration: TimeInterval, beginTime: CFTimeInterval, fromValue: Double = 1, toValue: Double = 0) {
        let animation = CABasicAnimation(keyPath: "opacity")
        
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = duration
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.beginTime = beginTime
        animation.isRemovedOnCompletion = false
        
        add(animation, forKey: "opacity")
    }
    
    func animateBorderColor(color: CGColor, duration: TimeInterval, delay: TimeInterval? = nil) {
        let currentBorderColor = self.borderColor ?? UIColor.clear.cgColor
        let animation = CABasicAnimation(keyPath: "borderColor")
        
        self.borderColor = color
        
        animation.fromValue = currentBorderColor
        animation.toValue = color
        animation.duration = duration
        
        if let delay = delay {
            animation.beginTime = CACurrentMediaTime() + delay
        }
        
        add(animation, forKey: "borderColor")
    }
    
    
}
