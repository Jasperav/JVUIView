import UIKit
import JVRestartable
import JVTimeable

open class Shape: UIView, Restartable {
    public let contentType: Shapes
    public let borderWidth: CGFloat
    public let fillColor: UIColor
    public let borderColor: UIColor
    public let shapeLayer = CAShapeLayer()
    
    public private(set) var colorChanger: ColorChanger?
    public private(set) var timerChangingColors: TimeableWrapper?
    
    init(frame: CGRect,
         borderWidth: CGFloat,
         fillColor: UIColor,
         borderColor: UIColor,
         contentTypeColorChanger: ContentTypeColorChanger?,
         contentType: Shapes) {
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.fillColor = fillColor
        self.contentType = contentType
        super.init(frame: frame)
        
        shapeLayer.path = determinePath(frame: frame)
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.borderWidth = borderWidth
        shapeLayer.strokeColor = borderColor.cgColor
        
        layer.addSublayer(shapeLayer)
        
        guard let contentTypeColorChanger = contentTypeColorChanger else { return }
        self.colorChanger = ColorChanger(contentType: contentTypeColorChanger)
        timerChangingColors = TimeableWrapper(timerIntervalSeconds: contentTypeColorChanger.randomColorChangeRate.random(), continueTimingWhenPaused: false, repeatTimerAfterCompletion: false, runLoop: .commonModes)
        timerChangingColors!.timerHasFired = { [weak self] in
            self?.timerChangingColors!.startTimer(contentTypeColorChanger.randomColorChangeRate.random())
            self?.changeColors()
        }
        
        timerChangingColors?.startTimer(contentTypeColorChanger.randomColorChangeRate.random())
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func determinePath(frame: CGRect) -> CGPath {
        fatalError()
    }
    
    public func changeColors() {
        guard colorChanger != nil else { fatalError() }
        
        colorChanger!.nextColors()
        let animationDuration = colorChanger!.contentType.randomColorChangeDuration.random()
        
        shapeLayer.animateFillColor(color: colorChanger!.fillColor.cgColor, duration: animationDuration)
        shapeLayer.animateStrokeColor(color: colorChanger!.borderColor.cgColor, duration: animationDuration)
    }
    
    public func pause() {
        timerChangingColors?.pause()
    }
    
    public func resume() {
        timerChangingColors?.timerHasFired()
    }
    
    deinit {
        timerChangingColors?.removeTimer()
    }
    
}
