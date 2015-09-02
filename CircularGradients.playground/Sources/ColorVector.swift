import Cocoa

public struct ColorVector {
    var red:    CGFloat
    var green:  CGFloat
    var blue:   CGFloat
    
    var alpha:  CGFloat
    
    init(red: CGFloat = 1.0, green: CGFloat = 1.0, blue: CGFloat = 1.0, alpha: CGFloat = 1.0) {
        self.red    = red
        self.green  = green
        self.blue   = blue
        
        self.alpha  = alpha
    }
}

public func +(lhs: ColorVector, rhs: ColorVector) -> ColorVector {
    return ColorVector(red: lhs.red + rhs.red, green: lhs.green + rhs.green, blue: lhs.blue + rhs.blue, alpha: lhs.alpha + rhs.alpha)
}

public func *(lhs: CGFloat, rhs: ColorVector) -> ColorVector {
    return ColorVector(red: lhs * rhs.red, green: lhs * rhs.green, blue: lhs * rhs.blue, alpha: lhs * rhs.alpha)
}

public func *(lhs: ColorVector, rhs: CGFloat) -> ColorVector {
    return ColorVector(red: lhs.red * rhs, green: lhs.green * rhs, blue: lhs.blue * rhs, alpha: lhs.red * rhs)
}