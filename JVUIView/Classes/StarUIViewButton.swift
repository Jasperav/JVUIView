import JVView
import JVGradientLayer
import JVShapeHalfMoon
import JVSunBurstView

open class JVUIViewButton: JVButton {
    
    private static let delayTouchUpAnimation: TimeInterval = 0.1
    
    // maybe this should be weak
    public var backgroundLayerOnButtonTouchDown: JVGradientLayer?
    
    public var timeOfTouchDown: TimeInterval = 0
    public var timer: Timer?
    
    open override func touchUp(_ sender: UIButton) {
        super.touchUp(sender)
        removeTimer()
        let currentTime = Date().timeIntervalSince1970
        let differenceInSeconds = currentTime - timeOfTouchDown
        if (JVUIViewButton.delayTouchUpAnimation > differenceInSeconds) {
            timer = Timer.scheduledTimer(withTimeInterval: JVUIViewButton.delayTouchUpAnimation - differenceInSeconds, repeats: false) { (_) in
                self.backgroundLayerOnButtonTouchDown?.animateColor(color: UIColor.clear.cgColor, duration: self.contentType.animationClickDuration)
            }
        } else {
            self.backgroundLayerOnButtonTouchDown?.animateColor(color: UIColor.clear.cgColor, duration: self.contentType.animationClickDuration)
        }
    }
    
    @objc open override func touchDown(_ sender: UIButton) {
        timeOfTouchDown = Date().timeIntervalSince1970
        super.touchDown(sender)
        
        guard let backgroundLayerOnButtonTouchDown = backgroundLayerOnButtonTouchDown else { return }
        backgroundLayerOnButtonTouchDown.colors = contentType.contentTypeBackgroundLayer!.map { $0.color }
    }
    
    func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        removeTimer()
    }
    
}

