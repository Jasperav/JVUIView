import UIKit
import JVUIViewExtensions
import JVCALayerExtensions

public class SunBurstView: UIView {
    
    @IBInspectable var contentTypeId: String = "" {
        didSet {
            self.contentType = contentTypeId.contentTypeSunBurstView
            setContentType()
        }
    }
    
    public var contentType: ContentTypeSunBurstView!
    
    internal var currentRotationSpeed: Float = 1.0
    internal var timers = [Timer]()
    
    public init(contentType: ContentTypeSunBurstView) {
        super.init(frame: CGRect.zero)
        
        self.contentType = contentType
        setContentType()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func touchUp(duration: TimeInterval?) {
        setSpeedToNormal(duration: duration)
    }
    
    public func touchDown(duration: TimeInterval?) {
        let change = (contentType.rotationSpeedTouchDown - contentType.rotationSpeed) / contentType.rotationSpeed
        setSpeed(1 + change, duration: duration)
    }
    
    public func setContentType() {
        layer.startRotation(duration360Degress: TimeInterval(contentType.rotationSpeed))
    }
    
    public override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath()
        let radius: CGFloat = rect.size.width / 2
        let centerPoint = CGPoint(x: rect.origin.x + radius, y: rect.size.height / 2)
        let sliceDegrees: CGFloat = 360.0 / CGFloat(contentType.slices) / 2.0
        
        var currentSlice = CGPoint(x: centerPoint.x + radius, y: centerPoint.y + radius)
        var currentAngle: CGFloat = 0.0
        
        if let strokeColor = contentType.strokeColor {
            strokeColor.setStroke()
        }
        
        bezierPath.move(to: centerPoint)
        for _ in 0..<contentType.slices {
            let x = radius * CGFloat(cosf(Float((currentAngle + sliceDegrees).degreesToRadians))) + centerPoint.x
            let y = radius * CGFloat(sinf(Float((currentAngle + sliceDegrees).degreesToRadians))) + centerPoint.y
            
            currentSlice = CGPoint(x: x, y: y)
            bezierPath.addLine(to: currentSlice)
            currentAngle += sliceDegrees
            
            let x2 = radius * CGFloat(cosf(Float((currentAngle + sliceDegrees).degreesToRadians))) + centerPoint.x
            let y2 = radius * CGFloat(sinf(Float((currentAngle + sliceDegrees).degreesToRadians))) + centerPoint.y
            
            currentSlice = CGPoint(x: x2, y: y2)
            bezierPath.addLine(to: currentSlice)
            bezierPath.addLine(to: centerPoint)
            currentAngle += sliceDegrees
        }
        
        bezierPath.close()
        bezierPath.lineWidth = contentType.lineWidth
        bezierPath.fill()
        
        UIGraphicsGetCurrentContext()?.setBlendMode(.sourceIn)
        let gradient = CGGradient(colorsSpace: nil, colors: contentType.colors, locations: nil)
        let endPosition = min(frame.width, frame.height) / 2
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        UIGraphicsGetCurrentContext()?.drawRadialGradient(gradient!, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: endPosition, options: .drawsAfterEndLocation)
        
        bezierPath.stroke()
    }
    
    public func setSpeed(_ newSpeed: Float, duration: TimeInterval?) {
        guard newSpeed != contentType.rotationSpeed else { return }
        let difference = (newSpeed - currentRotationSpeed) * 100
        changeSpeedBy(percent: difference, duration: duration)
    }
    
    public func setSpeedToNormal(duration: TimeInterval?) {
        guard currentRotationSpeed != 1 else { return }
        
        removeTimers()
        guard let _duration = duration else {
            self.currentRotationSpeed = 1
            resetLayer()
            return
        }
        
        var percent: Float
        if currentRotationSpeed > 1 {
            percent = (currentRotationSpeed - 1) * 0.05
        } else {
            percent = (currentRotationSpeed + 1) * 0.05
        }
        var counter = 0.0
        var timesToLoop = _duration / (_duration * 0.05)
        
        while timesToLoop > 0 {
            let timer = Timer.scheduledTimer(withTimeInterval: counter, repeats: false, block: { (_) in
                if self.currentRotationSpeed > 1 {
                    self.currentRotationSpeed -= percent
                }else{
                    self.currentRotationSpeed += percent
                }
                self.resetLayer()
            })
            timers.append(timer)
            counter += _duration * 0.05
            timesToLoop -= 1
        }
    }
    
    public func changeSpeedBy(percent: Float, duration: TimeInterval?) {
        let speedToSet = percent / 100
        removeTimers()
        
        guard let _duration = duration else {
            currentRotationSpeed = currentRotationSpeed * speedToSet
            resetLayer()
            return
        }
        
        var counter = 0.0
        while counter < _duration {
            let timer = Timer.scheduledTimer(withTimeInterval: counter, repeats: false, block: { (_) in
                self.currentRotationSpeed += speedToSet * 0.05
                self.resetLayer()
            })
            
            timers.append(timer)
            counter += _duration * 0.05
        }
    }
    
    internal func removeTimers() {
        for timer in timers{
            timer.invalidate()
        }
        
        timers.removeAll()
    }
    
    internal func resetLayer() {
        self.layer.timeOffset = self.layer.convertTime(CACurrentMediaTime(), from: nil)
        self.layer.beginTime = CACurrentMediaTime()
        self.layer.speed = currentRotationSpeed
    }
    
    deinit {
        removeTimers()
    }
    
}
