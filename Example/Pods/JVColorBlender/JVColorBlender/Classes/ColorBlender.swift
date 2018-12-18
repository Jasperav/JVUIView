import UIKit
import JVRandomNumberGenerator

public class ColorBlender {
    
    static func blend(from: UIColor, to: UIColor, percent: CGFloat? = nil, alpha: CGFloat = 1.0) -> UIColor {
        var fR : CGFloat = 0.0
        var fG : CGFloat = 0.0
        var fB : CGFloat = 0.0
        var tR : CGFloat = 0.0
        var tG : CGFloat = 0.0
        var tB : CGFloat = 0.0
        
        from.getRed(&fR, green: &fG, blue: &fB, alpha: nil)
        to.getRed(&tR, green: &tG, blue: &tB, alpha: nil)
        
        let dR = tR - fR
        let dG = tG - fG
        let dB = tB - fB
        
        let _percent = percent ?? CGFloat.random(inclusiveLow: 0, inclusiveHigh: 100) / 100
        
        let rR = fR + dR * _percent
        let rG = fG + dG * _percent
        let rB = fB + dB * _percent
        
        return UIColor(red: rR, green: rG, blue: rB, alpha: alpha)
    }
    
}
