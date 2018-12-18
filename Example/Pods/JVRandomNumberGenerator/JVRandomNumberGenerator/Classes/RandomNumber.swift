import UIKit

// For performance reasons, I like the the methods seperate
public struct RandomNumberDouble {
    public let low: Double
    public let high: Double
    
    public init(inclusiveLow: Double, inclusiveHigh: Double) {
        self.low = inclusiveLow
        self.high = inclusiveHigh
        assert(high > low)
    }
    
    public func random() -> Double {
        return Double.random(inclusiveLow: low, inclusiveHigh: high)
    }
}

public struct RandomNumberFloat {
    public let low: Float
    public let high: Float
    
    public init(inclusiveLow: Float, inclusiveHigh: Float) {
        self.low = inclusiveLow
        self.high = inclusiveHigh
        assert(high > low)
    }
    
    public func random() -> Float {
        return Float.random(inclusiveLow: low, inclusiveHigh: high)
    }
}

public struct RandomNumberCGFloat {
    public let low: CGFloat
    public let high: CGFloat
    
    public init(inclusiveLow: CGFloat, inclusiveHigh: CGFloat) {
        self.low = inclusiveLow
        self.high = inclusiveHigh
        assert(high > low)
    }
    
    public func random() -> CGFloat {
        return CGFloat.random(inclusiveLow: low, inclusiveHigh: high)
    }
}

public struct RandomNumberInt {
    public let low: Int
    public let high: Int
    
    public init(inclusiveLow: Int, inclusiveHigh: Int) {
        self.low = inclusiveLow
        self.high = inclusiveHigh
        assert(high > low)
    }
    
    public func random() -> Int {
        return Int.random(inclusiveLow: low, inclusiveHigh: high)
    }
}
