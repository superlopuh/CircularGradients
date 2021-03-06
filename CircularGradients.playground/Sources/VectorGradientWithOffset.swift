
public class VectorGradientWithOffset: VectorGradient {
    public var wrapAround     = true
    public var offset: Double = 0
    public let storedGradient: VectorGradient
    
    public init(storedGradient: VectorGradient) {
        self.storedGradient = storedGradient
    }
    
    public func colorVectorForPoint(point: Double) -> ColorVector {
        var newOffset = point + offset
        if wrapAround {
            newOffset = (newOffset % 1.0 + 1.0) % 1.0
        }
        return storedGradient.colorVectorForPoint(newOffset)
    }
}
