
public struct ColorVector {
    var red:    Double
    var green:  Double
    var blue:   Double
    
    var alpha:  Double
    
    init(red: Double = 1.0, green: Double = 1.0, blue: Double = 1.0, alpha: Double = 1.0) {
        self.red    = red
        self.green  = green
        self.blue   = blue
        
        self.alpha  = alpha
    }
}

public func +(lhs: ColorVector, rhs: ColorVector) -> ColorVector {
    return ColorVector(red: lhs.red + rhs.red, green: lhs.green + rhs.green, blue: lhs.blue + rhs.blue, alpha: lhs.alpha + rhs.alpha)
}

public func *(lhs: Double, rhs: ColorVector) -> ColorVector {
    return ColorVector(red: lhs * rhs.red, green: lhs * rhs.green, blue: lhs * rhs.blue, alpha: lhs * rhs.alpha)
}

public func *(lhs: ColorVector, rhs: Double) -> ColorVector {
    return ColorVector(red: lhs.red * rhs, green: lhs.green * rhs, blue: lhs.blue * rhs, alpha: lhs.red * rhs)
}