import UIKit

public extension Int {
    public static func random(inclusiveLow: Int, inclusiveHigh: Int) -> Int {
        return Int.random(in: inclusiveLow...inclusiveHigh)
    }
}

public extension Double {
    public static func random(inclusiveLow: Double, inclusiveHigh: Double) -> Double {
        return Double.random(in: inclusiveLow...inclusiveHigh)
    }
}

public extension Float {
    public static func random(inclusiveLow: Float, inclusiveHigh: Float) -> Float {
        return Float.random(in: inclusiveLow...inclusiveHigh)
    }
}

public extension CGFloat {
    public static func random(inclusiveLow: CGFloat, inclusiveHigh: CGFloat) -> CGFloat {
        return CGFloat.random(in: inclusiveLow...inclusiveHigh)
    }
}
