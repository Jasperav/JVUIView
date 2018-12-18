import UIKit
import JVRandomNumberGenerator
import JVUIViewExtensions
import JVCALayerExtensions
import JVRestartable
import JVContentType
import JVCAShapeLayerExtensions
import JVTimeable

open class ShapeSpawnerView: UIView, Restartable {
    
    @IBInspectable var contentTypeShapeSpawnerId: String = "" {
        didSet {
            contentTypeShapeSpawner = contentTypeShapeSpawnerId.contentTypeShapeSpawner
        }
    }
    
    @IBInspectable var contentTypeShapeGroupId: String = "" {
        didSet {
            contentTypeShapes = contentTypeShapeGroupId.contentTypeShapes
        }
    }
    
    private var viewHasBeenLayedOut = false
    private var isBeingPressed = false
    public private(set) var timerSpawner: TimeableWrapper!
    public private(set) var timerChangingColors: TimeableWrapper?
    
    public private(set) var randomSpawnProbability: RandomProbability!
    public private(set) var randomShapeStartSize: RandomNumberCGFloat!
    public private(set) var randomTimeInterval: RandomNumberDouble!
    
    public private(set) var relativeSizeInnerCircle: CGFloat!
    public private(set) var relativeSizeOuterCircle: CGFloat!
    
    /// Call resetContentTypes() to push this change
    public var colorChanger: ColorChanger?
    /// Call resetContentTypes() to push this change
    public var contentTypeShapes: [ContentTypeShape]!
    /// Call resetContentTypes() to push this change
    public var contentTypeShapeSpawner: ContentTypeShapeSpawner!
    
    public private(set) var fixedColors: (fillColor: UIColor, borderColor: UIColor)?
    public private(set) var state: RestartableState = .active
    
    // Sometimes the values gets added later on
    public init(contentTypeShapeSpawner: ContentTypeShapeSpawner?, contentTypeShapes: [ContentTypeShape]?) {
        super.init(frame: CGRect.zero)
        
        self.contentTypeShapeSpawner = contentTypeShapeSpawner
        self.contentTypeShapes = contentTypeShapes
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func pause() {
        removeAnimations()
        
        // Some shapes have an color changer object on them that needs to be paused as well.
        for subview in subviews as! [Shape] {
            subview.pause()
        }
        
        state = .paused
    }
    
    public func resume() {
        removeAnimations()
        
        if layer.animation(forKey: CALayer.rotationKey) == nil {
            layer.startRotation(duration360Degress: contentTypeShapeSpawner.rotationSpeed)
        }
        
        calculateLayout()
        newLoop()
        
        if let timer = timerChangingColors {
            timer.startTimer(colorChanger!.contentType.randomColorChangeRate.random())
        }
        
        // Some shapes have an color changer object on them that needs to be resumed as well.
        for subview in subviews as! [Shape] {
            subview.resume()
        }
        
        state = .active
    }
    
    public func touchDown(clickDuration: TimeInterval) {
        isBeingPressed = true
        if let onTouchDownColorChange = contentTypeShapeSpawner.onTouchDownColorChange {
            self.fixedColors = onTouchDownColorChange
            changeCurrentSubviewsToColor(duration: 1.5)
        }
        
        if let onTouchDownIncreaseSpeedBy = contentTypeShapeSpawner.onTouchDownIncreaseSpeedBy {
            for subview in subviews {
                subview.layer.timeOffset = subview.layer.convertTime(CACurrentMediaTime(), from: nil)
                subview.layer.beginTime = CACurrentMediaTime()
                subview.layer.speed += onTouchDownIncreaseSpeedBy
            }
        }
    }
    
    public func touchUpEvent(clickDuration: TimeInterval) {
        isBeingPressed = false
        fixedColors = nil
        
        if let timer = timerChangingColors {
            timer.startTimer(colorChanger!.contentType.randomColorChangeRate.random())
        } else {
            for view in subviews as! [Shape] {
                let randomColor = contentTypeShapes[randomSpawnProbability.random]
                
                view.shapeLayer.animateStrokeColor(color: randomColor.contentTypeColorBlenderBorderColor.randomColor.cgColor, duration: clickDuration)
                view.shapeLayer.animateFillColor(color: randomColor.contentTypeColorBlenderFillColor.randomColor.cgColor, duration: clickDuration)
            }
        }
        
        if contentTypeShapeSpawner.onTouchDownIncreaseSpeedBy != nil {
            for subview in subviews {
                subview.layer.timeOffset = subview.layer.convertTime(CACurrentMediaTime(), from: nil)
                subview.layer.beginTime = CACurrentMediaTime()
                subview.layer.speed = 1
            }
        }
        
        if timerChangingColors != nil {
            animateChangingColors()
        }
    }
    
    private func changeCurrentSubviewsToColor(duration: TimeInterval) {
        guard let fixedColors = fixedColors else { return }
        
        timerChangingColors?.pause()
        
        for view in subviews as! [Shape] {
            view.shapeLayer.animateStrokeColor(color: fixedColors.borderColor.cgColor, duration: duration)
            view.shapeLayer.animateFillColor(color: fixedColors.fillColor.cgColor, duration: duration)
        }
    }
    
    public func removeAnimations() {
        timerSpawner?.pause()
        timerChangingColors?.pause()
        layer.removeAllAnimations()
        removeLayers()
    }
    
    public func newLoop() {
        if contentTypeShapeSpawner.onRepeat || !viewHasBeenLayedOut {
            if isBeingPressed, let onTouchDownIncreaseSpeedBy = contentTypeShapeSpawner.onTouchDownIncreaseSpeedBy {
                timerSpawner.startTimer(contentTypeShapeSpawner.randomSpawnRate.random() / Double(onTouchDownIncreaseSpeedBy))
            } else {
                timerSpawner.startTimer(contentTypeShapeSpawner.randomSpawnRate.random())
            }
        }
        
        guard viewHasBeenLayedOut else { return }
        
        switch contentTypeShapeSpawner.animationType {
        case .random:
            randomSpawnShape()
        case .burstCircle(let burstShapeCount):
            burstInCircle(shapeCount: burstShapeCount)
        }
    }
    
    public func burstInCircle(shapeCount: Int) {
        assert(shapeCount > 0)
        let radius = relativeSizeOuterCircle!
        let animationDuration = contentTypeShapeSpawner.randomSpawnDuration.random()
        
        for i in 1...shapeCount {
            let percent = CGFloat(shapeCount) / CGFloat(i)
            let angle = 360 / percent / 180 * CGFloat.pi
            let endPoint = getEndPointCircle(radius: radius, angle: angle)
            
            let shape = getShape()
            
            animateShapeToEndPoint(shape: shape, endPoint: endPoint, animationDuration: animationDuration)
        }
    }
    
    public func animateShapeToEndPoint(shape: UIView, endPoint: CGPoint, animationDuration: TimeInterval) {
        var _animationDuration = animationDuration
        
        if contentTypeShapeSpawner.baseSpawnDurationOnShapeSize {
            _animationDuration = calculateAnimationDurationBasedOnSize(size: shape.frame.size)
        }
        
        addSubview(shape)
        
        fadeOutShapeAnimation(shape: shape, animationDuration: _animationDuration)
        
        shape.center = convert(center, from: superview)
        
        // TODO: in a view that has a larger width than height, spawn the shapes near the view. Now the shapes will spawn to height and to low...
        UIView.animate(withDuration: _animationDuration, delay: 0, options: [.curveLinear], animations: {
            shape.center = CGPoint(x: endPoint.x + self.bounds.width / 2,
                                   y: endPoint.y + self.bounds.height / 2)
        }, completion: { _ in
            shape.removeFromSuperview()
        })
        
        if isBeingPressed, let onTouchDownIncreaseSpeedBy = contentTypeShapeSpawner.onTouchDownIncreaseSpeedBy {
            shape.layer.timeOffset = shape.layer.convertTime(CACurrentMediaTime(), from: nil)
            shape.layer.beginTime = CACurrentMediaTime()
            shape.layer.speed += onTouchDownIncreaseSpeedBy
        }
    }
    
    public func resetContentTypes() {
        randomSpawnProbability = RandomProbability(probability: self.contentTypeShapes.map { $0.spawnPropability })
        
        // On the timers, repeatTimerAfterCompletion is set to false.
        // This is needed because the time when the timer has to fire is a computed property that changes after each run.
        // This gets calculated in the newLoop function()
        timerSpawner = TimeableWrapper(timerIntervalSeconds: 0, continueTimingWhenPaused: false, repeatTimerAfterCompletion: false, runLoop: .commonModes)
        if colorChanger != nil {
            timerChangingColors = TimeableWrapper(timerIntervalSeconds: 0, continueTimingWhenPaused: false, repeatTimerAfterCompletion: false, runLoop: .commonModes)
            timerChangingColors!.timerHasFired = { [weak self] in
                self?.animateChangingColors()
            }
        }
        
        timerSpawner.timerHasFired = { [weak self] in
            self?.newLoop()
        }
    
    }
    
    private func calculateAnimationDurationBasedOnSize(size: CGSize) -> TimeInterval {
        let maximumSizeShape = contentTypeShapeSpawner.randomShapeRelativeSize.high
        
        let minimumDuration = contentTypeShapeSpawner.randomSpawnDuration.low
        let maximumDuration = contentTypeShapeSpawner.randomSpawnDuration.high
        
        let differenceInDuration = maximumDuration - minimumDuration
        
        let relativeSizePercentage = size.height / (maximumSizeShape * frame.height)
        
        return differenceInDuration * Double(relativeSizePercentage) + minimumDuration
    }
    
    private func animateChangingColors() {
        guard colorChanger != nil, let timerChangingColors = timerChangingColors else { fatalError("shouldnt be nil...") }
        
        colorChanger!.nextColors()
        
        timerChangingColors.startTimer(colorChanger!.contentType.randomColorChangeRate.random())
        
        for subview in subviews as! [Shape] {
            let animationDuration = colorChanger!.contentType.randomColorChangeDuration.random()
            let newBorderColor = colorChanger!.borderColor.cgColor
            subview.shapeLayer.animateStrokeColor(color: newBorderColor, duration: animationDuration)
            subview.shapeLayer.animateFillColor(color: colorChanger!.fillColor.cgColor, duration: animationDuration)
        }
    }
    
    private func fadeOutShapeAnimation(shape: UIView, animationDuration: TimeInterval) {
        shape.layer.animateOpacity(duration: animationDuration * (1 - contentTypeShapeSpawner.percentSpawnDurationWhenAnimatingShapeAlphaToZero),
                                   beginTime: CACurrentMediaTime() + animationDuration * contentTypeShapeSpawner.percentSpawnDurationWhenAnimatingShapeAlphaToZero)
    }
    
    private func randomSpawnShape() {
        let shape = getShape()
        
        // If this class has a color changer, the shape can not have one.
        assert(colorChanger != nil ? shape.colorChanger == nil : true)
        let endPoint = getEndPoint()
        
        let animationDuration = contentTypeShapeSpawner.randomSpawnDuration.random()
        
        animateShapeToEndPoint(shape: shape, endPoint: endPoint, animationDuration: animationDuration)
    }
    
    private func getShape() -> Shape {
        let contentTypeShape = contentTypeShapes[randomSpawnProbability.random]
        var colors: (fillColor: UIColor, borderColor: UIColor)? = nil
        
        if let fixedColors = fixedColors {
            colors = fixedColors
        } else if let colorChanger = colorChanger {
            colors = (fillColor: colorChanger.fillColor, borderColor: colorChanger.borderColor)
        }
        
        let shape = contentTypeShape.getShape(size: randomShapeStartSize.random(), fixedFillColor: colors?.fillColor, fixedBorderColor: colors?.borderColor, contentTypeColorChanger: contentTypeShape.contentTypeColorChanger)
        shape.alpha = contentTypeShapeSpawner.randomStartAlpha.random()
        
        return shape
    }
    
    deinit {
        pause()
    }
    
}

// MARK: Layout calculator
extension ShapeSpawnerView {
    
    private func getEndPoint() -> CGPoint {
        let radius = CGFloat.random(inclusiveLow: relativeSizeOuterCircle - relativeSizeInnerCircle, inclusiveHigh: relativeSizeInnerCircle)
        let angle = CGFloat(arc4random_uniform(360)) / 180 * CGFloat.pi
        return getEndPointCircle(radius: radius, angle: angle)
    }
    
    private func getEndPointCircle(radius: CGFloat, angle: CGFloat) -> CGPoint {
        let finalX = cos(angle) * radius
        let finalY = sin(angle) * radius
        return CGPoint(x: finalX, y: finalY)
    }
    
    // It is up to the user to make sure the resume() function is being called in the ViewController's viewDidAppear method.
    // It firstly was in layoutSubviews, but than every time a shape has spawned, the function ran.
    // Although we had a flag setup, it is a little bit expensive.
    private func calculateLayout() {
        if !viewHasBeenLayedOut {
            viewHasBeenLayedOut = true
        }
        let sizeToUse = max(frame.height, frame.width)
        randomShapeStartSize = RandomNumberCGFloat(inclusiveLow: sizeToUse * contentTypeShapeSpawner.randomShapeRelativeSize.low,
                                                   inclusiveHigh: sizeToUse * contentTypeShapeSpawner.randomShapeRelativeSize.high)
        relativeSizeInnerCircle = sizeToUse * contentTypeShapeSpawner.randomEndPoint.low
        relativeSizeOuterCircle = sizeToUse * contentTypeShapeSpawner.randomEndPoint.high
    }
    
}
