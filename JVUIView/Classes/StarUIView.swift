import UIKit
import JVGradientLayer
import JVCurrentDevice
import JVUIViewExtensions
import JVResizableViewBorder
import JVShadowView
import JVConstraintEdges
import JVShapeHalfMoon
import JVView
import JVSunBurstView
import JVShapes
import JVContentType
import JVSizeable

open class JVUIView: UIView, Sizeable {
    
    @IBInspectable public var contentTypeId: String = "" {
        didSet{
            contentType = contentTypeId.contentTypeJVUIView
            setContentType()
        }
    }
    
    public var contentView = UIView()
    public var contentType: ContentTypeJVUIView!
    public var halfMoon: ShapeHalfMoon?
    public var button: JVUIViewButton!
    public var backgroundLayerOnButtonTouchDown: JVGradientLayer?
    public var sunBurstView: SunBurstView?
    public var shapeSpawnerView: ShapeSpawnerView?
    public var starGradientLayerBackgroundActiveState: JVGradientLayer?
    public weak var delegate: JVUIViewDelegate?
    private var bottomConstraintForJVUIViewTop: NSLayoutConstraint?
    private var topConstraintForJVUIViewTop: NSLayoutConstraint?
    public var starUIViewTop: JVUIView?
    public var backgroundImage = UIImageView(frame: CGRect.zero)
    
    public var width: CGFloat {
        get {
            return JVUIView.getWidth(contentType: contentType)
        }
    }
    
    public var height: CGFloat {
        get {
            return frame.height
        }
    }
    
    internal var gradientBackground: JVGradientLayer!
    internal var minimumWidthConstraint: NSLayoutConstraint!
    
    public init(contentType: ContentTypeJVUIView) {
        super.init(frame: CGRect.zero)
        self.contentType = contentType
        setContentType()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public static func getWidth(contentType: ContentTypeJVUIView) -> CGFloat {
        return (contentType.useMinimumWidth ?? false) ? contentType.minimumWidth! : 0
    }
    
    public class func getHeight(contentType: ContentTypeJVUIView) -> CGFloat {
        return 0
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        // For dynamic content types it is sometimes nil
        guard contentType != nil else { return }
        
        gradientBackground?.frame = bounds
        backgroundLayerOnButtonTouchDown?.frame = bounds // this cannot be done on the button itself
        halfMoon?.frame = bounds
        starGradientLayerBackgroundActiveState?.frame = bounds
        
        if contentType.isRounded {
            assert(contentType.contentTypeResizableViewBorderRoundedEdges == nil)
            assert(contentType.cornerRadius == nil)
            assert(contentType.contentTypeResizableViewBorder == nil)
            assert(bounds.width == bounds.height)
            
            contentView.layer.cornerRadius = bounds.width / 2
            
            if let contentTypeJVShadow = contentType.contentTypeJVShadow {
                layer.shadowPath = UIBezierPath(roundedRect: bounds.enlarged(by: contentTypeJVShadow.enlargeBoundsByAbsoluteValue,
                                                                             bounds: bounds),
                                                cornerRadius: bounds.width / 2).cgPath
            }
        } else if let contentTypeShadow = contentType.contentTypeJVShadow {
            layer.shadowPath = UIBezierPath(roundedRect: bounds.enlarged(by: contentTypeShadow.enlargeBoundsByAbsoluteValue,
                                                                         bounds: bounds),
                                            cornerRadius: contentTypeShadow.radius).cgPath
        }
        
        guard let sunBurstView = sunBurstView else { return }
        
        let highestPoint: CGFloat = {
            if frame.height >= frame.width && sunBurstView.contentType.useLargestFrameToLayoutSlices {
                return frame.height * 1.05
            }else if frame.height >= frame.width && !sunBurstView.contentType.useLargestFrameToLayoutSlices {
                return frame.width
            }else if frame.height < frame.width && sunBurstView.contentType.useLargestFrameToLayoutSlices{
                return frame.width * 1.05
            }else{
                return frame.height
            }
        }()
        
        sunBurstView.frame = CGRect(x: 0, y: 0, width: highestPoint, height: highestPoint)
        sunBurstView.center = contentView.center
        sunBurstView.setNeedsDisplay()
    }
    
    open func setGradientColor(colors: [CGColor], duration: CFTimeInterval? = nil) {
        gradientBackground.animateColors(colors: colors, duration: duration)
    }
    
    public func getEdgesForButton() -> ConstraintEdges {
        return ConstraintEdges.zero
    }
    
    public func setMinimumWidth(constant: CGFloat) {
        minimumWidthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: constant)
        minimumWidthConstraint.isActive = true
    }
    
    // This will prop not work :P
    public func animateGradientFlash(colors: [CGColor]) {
        gradientBackground.animateColors(colors: colors, duration: contentType.gradientAnimationFlash!, autoreverse: true)
    }
    
    public func stopAnimationFlash() {
        gradientBackground.animateColors(colors: [UIColor.clear.cgColor], duration: contentType.gradientAnimationFlash!)
    }
    
    public func addGradientBackground() {
        if var backgroundContentTypeJVGradientLayer = contentType.backgroundContentTypeJVGradientLayer?.copy() {
            if let baseBackgroundColorForBackgroundGradientLayer = contentType.baseBackgroundColorForBackgroundGradientLayer {
                let colorCount = backgroundContentTypeJVGradientLayer.count
                let difference = baseBackgroundColorForBackgroundGradientLayer.lastColorAdjustedBrightness
                    - baseBackgroundColorForBackgroundGradientLayer.firstColorAdjustedBrightness
                let increaseSteps = difference / (CGFloat(colorCount) - 1)
                
                for (i, _) in backgroundContentTypeJVGradientLayer.enumerated() {
                    let color = contentView.backgroundColor!.adjustBrightness(by: increaseSteps * CGFloat(i) + baseBackgroundColorForBackgroundGradientLayer.firstColorAdjustedBrightness).cgColor
                    
                    backgroundContentTypeJVGradientLayer[i].color = color
                }
            }
            
            if gradientBackground == nil {
            gradientBackground = JVGradientLayer(contentType: backgroundContentTypeJVGradientLayer,
                                                   contentTypePoint: contentType.backgroundContentTypeJVGradientLayerPoint,
                                                   setColorsInstant: true)
            
            contentView.layer.insertSublayer(self.gradientBackground!, at: 0)
            } else {
                gradientBackground.colors = backgroundContentTypeJVGradientLayer.map { $0.color }
            }
        }
    }
    
    public func addShadow() {
        // Shadow gets applied to the real UIView
        // It is presumed that nearly all JVUIView's will have shadows
        if var contentTypeJVShadow = contentType.contentTypeJVShadow?.copy() {
            if let baseBackgroundColorForJVShadowByPercent = contentType.baseBackgroundColorForJVShadowByPercent {
                contentTypeJVShadow.color = contentView.backgroundColor!.darker(by: baseBackgroundColorForJVShadowByPercent).cgColor
            }
            
            JVShadow.applyShadow(toLayer: layer, contentType: contentTypeJVShadow)
        }
    }
    
    open func setContentType() {
        backgroundColor = .clear
        
        // When existing other subviews are added, we save them in an array
        // and at the end, we pull all the subviews to the front
        // else, the existing current subviews may be hidden by the actions in the function.
        let existingViews = subviews
        
        contentView.fill(toSuperview: self)
        contentView.clipsToBounds = true
        contentView.backgroundColor = contentType.backgroundColor
        
        if contentType.addShapeSpawnerView {
            shapeSpawnerView = ShapeSpawnerView(contentTypeShapeSpawner: contentType.contentTypeShapeSpawner,
                                                contentTypeShapes: contentType.shapeGroupIdForContentTypeShapeSpawner?.contentTypeShapes)
            shapeSpawnerView!.fill(toSuperview: self)
            sendSubview(toBack: shapeSpawnerView!)
        }
        
        addShadow()
        
        if let cornerRadius = contentType.cornerRadius {
            contentView.layer.cornerRadius = cornerRadius
        }
        
        if let contentTypeResizableViewBorder = contentType.contentTypeResizableViewBorder {
            assert(contentType.cornerRadius == nil)
            assert(contentType.borderColor == nil)
            assert(contentType.borderWidth == nil)
            let view: UIView
            
            if let contentTypeUIRectEdges = contentType.contentTypeUIRectEdges {
                view = ResizableViewBorder(contentTypeResizableViewBorder: contentTypeResizableViewBorder, contentTypeRectEdges: contentTypeUIRectEdges)
            } else {
                // Below variable can be forced unwrapped. If an error occured, please check the contentType of this JVUIView
                let contentTypeResizableViewBorderRoundedEdges = contentType.contentTypeResizableViewBorderRoundedEdges!
                
                view = ResizableViewBorderRoundedEdges(contentTypeResizableViewBorder: contentTypeResizableViewBorder, contentTypeResizableViewBorderRoundedEdges: contentTypeResizableViewBorderRoundedEdges)
                
                contentView.layer.cornerRadius = (view as! ResizableViewBorderRoundedEdges).getCornerRadius()
                contentView.layer.maskedCorners = (view as! ResizableViewBorderRoundedEdges).getCornerMask()
            }
            
            view.fill(toSuperview: contentView)
            contentView.sendSubview(toBack: view)
            
        } else {
            if let borderColor = contentType.borderColor {
                contentView.layer.borderColor = borderColor
            }
            if let borderWidth = contentType.borderWidth {
                contentView.layer.borderWidth = borderWidth
            }
        }
        
        if let backgroundImage = contentType.backgroundImage {
            self.backgroundImage.image = backgroundImage
            
            self.backgroundImage.contentMode = contentType.backgroundImageContentMode
            self.backgroundImage.fill(toSuperview: contentView)
            self.backgroundImage.setHuggingAndCompression(to: 200)
            self.backgroundImage.alpha = contentType.backgroundImageAlpha ?? 1
            
            contentView.sendSubview(toBack: self.backgroundImage)
        }
        
        if let contentTypeSunBurstView = contentType.contentTypeSunBurstView {
            sunBurstView = SunBurstView(contentType: contentTypeSunBurstView)
            sunBurstView!.backgroundColor = .clear
            contentView.addSubview(sunBurstView!)
        }
        
        
        addGradientBackground()
        
        
        if let contentTypeJVGradientLayerBackgroundActiveState = contentType.contentTypeJVGradientLayerBackgroundActiveState {
            starGradientLayerBackgroundActiveState = JVGradientLayer(contentType: contentTypeJVGradientLayerBackgroundActiveState,
                                                                       contentTypePoint: contentType.contentTypeJVGradientLayerBackgroundPointActiveState,
                                                                       setColorsInstant: false)
            
            contentView.layer.addSublayer(self.starGradientLayerBackgroundActiveState!)
        }
        
        if let contentTypeShapeHalfMoon = contentType.contentTypeShapeHalfMoon {
            halfMoon = ShapeHalfMoon(contentType: contentTypeShapeHalfMoon)
            contentView.layer.insertSublayer(halfMoon!, at: UInt32(contentView.layer.sublayers!.count - 1))
        }
        
        if let contentTypeJVButton = contentType.contentTypeJVButton {
            button = JVUIViewButton(contentType: contentTypeJVButton)
            button.fill(toSuperview: self, edges: getEdgesForButton())
            button.setHuggingAndCompression(to: 1)
            button.delegate = self
            
            if let contentTypeBackgroundLayer = button.contentType.contentTypeBackgroundLayer {
                button.backgroundLayerOnButtonTouchDown = JVGradientLayer(contentType: contentTypeBackgroundLayer,
                                                                            contentTypePoint: button.contentType.contentTypeBackgroundLayerPoint,
                                                                            setColorsInstant: false)
                backgroundLayerOnButtonTouchDown = button.backgroundLayerOnButtonTouchDown
                contentView.layer.insertSublayer(backgroundLayerOnButtonTouchDown!, at: UInt32((contentView.layer.sublayers?.count ?? 0)))
            }
        }
        
        if let contentTypeJVUIViewOnTop = contentType.contentTypeJVUIViewOnTop {
            starUIViewTop = JVUIViewUtils.dynamicInit(contentType: contentTypeJVUIViewOnTop)
            
            starUIViewTop!.fill(toSuperview: self, edges: ConstraintEdges())
            
            bottomConstraintForJVUIViewTop = NSLayoutConstraint(item: starUIViewTop!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
            
            topConstraintForJVUIViewTop = NSLayoutConstraint(item: starUIViewTop!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
            
            starUIViewTop!.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            
            bottomConstraintForJVUIViewTop!.isActive = true
            sendSubview(toBack: starUIViewTop!)
        }
        
        for subview in existingViews {
            bringSubview(toFront: subview)
        }
        
        guard contentType.useMinimumWidth ?? false, let constant = contentType.minimumWidth else { return }
        setMinimumWidth(constant: constant)
    }
    
    public func checkMinimumHeight() {
        
    }
    
    public func hideJVUIViewTop(animationTimeInterval: TimeInterval) {
        bottomConstraintForJVUIViewTop!.isActive = false
        topConstraintForJVUIViewTop!.isActive = true
        
        UIView.animate(withDuration: animationTimeInterval) {
            self.layoutIfNeeded()
            self.starUIViewTop!.alpha = 0
        }
    }
    
    public func showJVUIViewTop(animationTimeInterval: TimeInterval) {
        bottomConstraintForJVUIViewTop!.isActive = true
        topConstraintForJVUIViewTop!.isActive = false
        
        UIView.animate(withDuration: animationTimeInterval) {
            self.layoutIfNeeded()
            self.starUIViewTop!.alpha = 1
        }
    }
    
    open func becameActive(animateColors: Bool = true) {
        isUserInteractionEnabled = false
        starGradientLayerBackgroundActiveState!.animateColors(duration: animateColors ? button.contentType.animationClickDuration : nil)
    }
    
    open func resignedActive(animateColors: Bool = true) {
        isUserInteractionEnabled = true
        starGradientLayerBackgroundActiveState!.animateColor(color: UIColor.clear.cgColor, duration: animateColors ? button.contentType.animationClickDuration : nil)
    }
    
}

extension JVUIView: JVButtonDelegate {
    public func touchDown(_ sender: JVButton) {
        halfMoon?.animateFillColorOnButtonClick(duration: 0)
        sunBurstView?.touchDown(duration: 0)
        shapeSpawnerView?.touchDown(clickDuration: 0)
    }
    
    public func touchUp(_ sender: JVButton) {
        halfMoon?.animateFillColorToOriginal(duration: sender.contentType.animationClickDuration)
        sunBurstView?.touchUp(duration: sender.contentType.animationClickDuration)
        shapeSpawnerView?.touchUpEvent(clickDuration: sender.contentType.animationClickDuration)
    }
}
