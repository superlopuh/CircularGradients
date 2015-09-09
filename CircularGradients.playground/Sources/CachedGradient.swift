import Foundation

public struct CachedGradient: VectorGradient {
    // A higher cache size means sharper edges, and does not impact linear gradient
    public let cacheSize:  Int
    public let cache:      [ColorVector]
    
    init(cacheSize: Int, manualGradient: ManualGradient) {
        self.cacheSize      = cacheSize
        
        // We want the cache to be filled with values for 0.0 to 1.0
        let divisor         = CGFloat(cacheSize - 1)
        
        // Note ..<
        self.cache          = (0..<cacheSize).map({CGFloat($0) / divisor}).map({manualGradient.colorVectorForPoint($0)})
    }
    
    public func colorVectorForPoint(point: CGFloat) -> ColorVector {
        let pointAtCacheScale   = point * CGFloat(cacheSize - 1)
        
        let floored             = floor(pointAtCacheScale)
        
        let remainder           = pointAtCacheScale - floored
        
        let flooredInt          = Int(floored)
        
        return (1.0 - remainder) * cache[flooredInt] + remainder * cache[flooredInt + 1]
    }
}