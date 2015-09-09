
public class ManualGradient: VectorGradient {
    public let startColorVector:   ColorVector
    public let endColorVector:     ColorVector
    
    public let transitionFunc:     Double -> Double
    
    public init(startColorVector: ColorVector, endColorVector: ColorVector, transitionFunc: Double -> Double) {
        self.startColorVector   = startColorVector
        self.endColorVector     = endColorVector
        
        self.transitionFunc     = transitionFunc
    }
    
    public func colorVectorForPoint(point: Double) -> ColorVector {
        let proportion = transitionFunc(point)
        return (1.0 - proportion) * startColorVector + proportion * endColorVector
    }
}
