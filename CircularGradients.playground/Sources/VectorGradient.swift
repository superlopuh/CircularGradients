import Foundation

public protocol VectorGradient {
    func colorVectorForPoint(point: CGFloat) -> ColorVector
}
