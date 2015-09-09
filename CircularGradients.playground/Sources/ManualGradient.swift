import Foundation

public class ManualGradient: VectorGradient {
    public let startColorVector:   ColorVector
    public let endColorVector:     ColorVector
    
    public let transitionFunc:     CGFloat -> CGFloat
    
    public init(startColorVector: ColorVector, endColorVector: ColorVector, transitionFunc: CGFloat -> CGFloat) {
        self.startColorVector   = startColorVector
        self.endColorVector     = endColorVector
        
        self.transitionFunc     = transitionFunc
    }
    
    public func colorVectorForPoint(point: CGFloat) -> ColorVector {
        let proportion = transitionFunc(point)
        return (1.0 - proportion) * startColorVector + proportion * endColorVector
    }
}
