import JVContentType
import JVColorBlender
import JVRandomNumberGenerator

public struct ContentTypeShapeSpawner: ContentType {

    public static var allTypes = Set<ContentTypeShapeSpawner>()
    
    public var contentTypeId: String?
    public var onRepeat = true
    public var randomSpawnRate: RandomNumberDouble!
    public var randomSpawnDuration: RandomNumberDouble!
    public var randomShapeRelativeSize: RandomNumberCGFloat!
    
    /// A value of 1 means exactly the bounds of the view. 1.5 is for example 1.5 * the width of the view.
    public var randomEndPoint: RandomNumberCGFloat!
    public var randomStartAlpha: RandomNumberCGFloat!
    public var animationType: ShapeSpawnerAnimationTypes = .random
    public var rotationSpeed: TimeInterval = 0
    
    /// A shape will fade out. This value will indicate when that will happen.
    /// Set a value of 0.5 to let the shape fade out after half of it's spawndurationtime has passed.
    public var percentSpawnDurationWhenAnimatingShapeAlphaToZero: TimeInterval = 0
    public var baseSpawnDurationOnShapeSize = true
    
    /// When the user presses on this view, the shapes will change their colors accordingly.
    /// New colors also will spawn with the given colors.
    public var onTouchDownColorChange: (fillColor: UIColor, borderColor: UIColor)?
    
    public var onTouchDownIncreaseSpeedBy: Float?
    
    public init(contentTypeId: String?) {
        self.contentTypeId = contentTypeId
    }
    
    public init(contentTypeId: String?, randomSpawnRate: RandomNumberDouble, randomSpawnDuration: RandomNumberDouble, randomShapeRelativeSize: RandomNumberCGFloat, randomEndPoint: RandomNumberCGFloat, rotationSpeed: TimeInterval, randomStartAlpha: RandomNumberCGFloat, percentSpawnDurationWhenAnimatingShapeAlphaToZero: TimeInterval, baseSpawnDurationOnShapeSize: Bool) {
        self.contentTypeId = contentTypeId
        self.randomSpawnDuration = randomSpawnDuration
        self.randomSpawnRate = randomSpawnRate
        self.randomShapeRelativeSize = randomShapeRelativeSize
        self.randomEndPoint = randomEndPoint
        self.rotationSpeed = rotationSpeed
        self.randomStartAlpha = randomStartAlpha
        self.percentSpawnDurationWhenAnimatingShapeAlphaToZero = percentSpawnDurationWhenAnimatingShapeAlphaToZero
        self.baseSpawnDurationOnShapeSize = baseSpawnDurationOnShapeSize
    }
    
}
