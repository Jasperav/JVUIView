import UIKit

public extension UIView {
    
    public func createTopConstraintToBottom(toBottomOfView: UIView, constant: CGFloat? = nil, multiplier: CGFloat? = nil) {
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: toBottomOfView, attribute: .bottom, multiplier: multiplier ?? 1, constant: constant ?? 0).isActive = true
    }
    
    public func fillToMiddleWithSameHeightAndWidth(toView: UIView, addToSuperView: Bool = true, toSafeMargins: Bool = false) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if addToSuperView{
            toView.superview!.addSubview(self)
        }
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: toView,
                               attribute: .centerX,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: self,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: toView,
                               attribute: .centerY,
                               multiplier: 1,
                               constant: 0)
            ])
        
        equal(to: toView, height: true, width: true)
    }
    
    public func fillToMiddle(toSuperview superview: UIView, addToSuperView: Bool = true, toSafeMargins: Bool = false) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if addToSuperView{
            superview.addSubview(self)
        }
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: superview,
                               attribute: .centerX,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: self,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: superview,
                               attribute: .centerY,
                               multiplier: 1,
                               constant: 0)
            ])
    }
    
    // Because the normal fill() is used so often and this method just a few times
    // We do not want extra overhead with the unnecessary callbacks
    // That is why this method is introduced, it is just a copy of the normal fill method with a callback
    public func fillWithResult(toSuperview: UIView, edges: ConstraintEdges? = nil, addToSuperView: Bool = true, toSafeMargins: Bool = false, activateConstraints: Bool = true) -> [NSLayoutConstraint] {
        let edgesToUse  = edges ?? ConstraintEdges.zero
        let safeGuide = toSuperview.safeAreaLayoutGuide
        var constraints = [NSLayoutConstraint]()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if addToSuperView{
            toSuperview.addSubview(self)
        }
        
        if let bottom = edgesToUse.bottom {
            if toSafeMargins {
                constraints.append(bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor, constant: -bottom))
            } else {
                constraints.append(bottomAnchor.constraint(equalTo: toSuperview.bottomAnchor, constant: -bottom))
            }
        }
        
        if let top = edgesToUse.top {
            if toSafeMargins {
                constraints.append(topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: top))
            } else {
                constraints.append(topAnchor.constraint(equalTo: toSuperview.topAnchor, constant: top))
            }
        }
        
        if let leading = edgesToUse.leading {
            if toSafeMargins {
                constraints.append(leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: leading))
            } else {
                constraints.append(leadingAnchor.constraint(equalTo: toSuperview.leadingAnchor, constant: leading))
            }
        }
        
        if let trailing = edgesToUse.trailing {
            if toSafeMargins {
                constraints.append(trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -trailing))
            } else {
                constraints.append(trailingAnchor.constraint(equalTo: toSuperview.trailingAnchor, constant: -trailing))
            }
        }
        
        if activateConstraints {
            NSLayoutConstraint.activate(constraints)
        }
        
        return constraints
    }
    
    /// Only fill in 1 corner
    public func fillMiddleInCorner(toSuperview: UIView, corner: UIRectCorner, addToSuperView: Bool = true) {
        assert(!corner.contains(.allCorners))
        translatesAutoresizingMaskIntoConstraints = false
        
        if addToSuperView{
            toSuperview.addSubview(self)
        }
        
        if corner.contains(.topRight) || corner.contains(.bottomRight) {
            centerXAnchor.constraint(equalTo: toSuperview.trailingAnchor).isActive = true
        }
        
        if corner.contains(.bottomRight) || corner.contains(.bottomLeft) {
            centerYAnchor.constraint(equalTo: toSuperview.bottomAnchor).isActive = true
        }
        
        if corner.contains(.bottomLeft) || corner.contains(.topLeft) {
            centerXAnchor.constraint(equalTo: toSuperview.leadingAnchor).isActive = true
        }
        
        if corner.contains(.topLeft) || corner.contains(.topRight) {
            centerYAnchor.constraint(equalTo: toSuperview.topAnchor).isActive = true
        }
        
    }
    
    public func fill(toSuperview: UIView, edges: ConstraintEdges? = nil, addToSuperView: Bool = true, toSafeMargins: Bool = false) {
        let edgesToUse  = edges ?? ConstraintEdges.zero
        let safeGuide = toSuperview.safeAreaLayoutGuide
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if addToSuperView{
            toSuperview.addSubview(self)
        }
        
        if let bottom = edgesToUse.bottom {
            if toSafeMargins {
                bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor, constant: -bottom).isActive = true
            } else {
                bottomAnchor.constraint(equalTo: toSuperview.bottomAnchor, constant: -bottom).isActive = true
            }
        }
        
        if let top = edgesToUse.top {
            if toSafeMargins {
                topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: top).isActive = true
            } else {
                topAnchor.constraint(equalTo: toSuperview.topAnchor, constant: top).isActive = true
            }
        }
        
        if let leading = edgesToUse.leading {
            if toSafeMargins {
                leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: leading).isActive = true
            } else {
                leadingAnchor.constraint(equalTo: toSuperview.leadingAnchor, constant: leading).isActive = true
            }
        }
        
        if let trailing = edgesToUse.trailing {
            if toSafeMargins {
                trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -trailing).isActive = true
            } else {
                trailingAnchor.constraint(equalTo: toSuperview.trailingAnchor, constant: -trailing).isActive = true
            }
        }
    }
    
    public func equal(to: UIView, height: Bool, width: Bool) {
        if height {
            heightAnchor.constraint(equalTo: to.heightAnchor, multiplier: 1).isActive = true
        }
        
        if width {
            widthAnchor.constraint(equalTo: to.widthAnchor, multiplier: 1).isActive = true
        }
    }
    
    public func equalWithResult(to: UIView, height: Bool, width: Bool) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        
        if height {
            constraints.append(heightAnchor.constraint(equalTo: to.heightAnchor, multiplier: 1))
        }
        
        if width {
            constraints.append(widthAnchor.constraint(equalTo: to.widthAnchor, multiplier: 1))
        }
        
        NSLayoutConstraint.activate(constraints)
        
        return constraints
    }
    
    public func setWidthAndHeightAreTheSame() {
        heightAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    public func setSameCenterY(view: UIView) {
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    public func setSameCenterX(view: UIView) {
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    public func setWidth(_ constant: CGFloat) {
        widthAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    public func setHeight(_ constant: CGFloat) {
        heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    public func setSameWidthAndHeight(toView: UIView) {
        heightAnchor.constraint(equalTo: toView.heightAnchor).isActive = true
        widthAnchor.constraint(equalTo: toView.widthAnchor).isActive = true
    }
}
