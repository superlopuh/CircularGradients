//: Playground - noun: a place where people can play

import Cocoa



protocol ManualGradient {
    func colorVectorForPoint(point: CGFloat) -> ColorVector
}

extension ManualGradient {
    func colorForPoint(point: CGFloat) -> NSColor {
        return NSColor(colorVector: colorVectorForPoint(point))
    }
}

struct LinearGradient: ManualGradient {
    var colorVectors: (ColorVector, ColorVector)
    
    func colorVectorForPoint(point: CGFloat) -> ColorVector {
        if point < 0.0 {
            return colorVectors.0
        } else if point > 1.0 {
            return colorVectors.1
        } else {
            return (1 - point) * colorVectors.0 + point * colorVectors.1
        }
    }
}

struct CachedGradient: ManualGradient {
    // A higher cache size means sharper edges, and does not impact linear gradient
    let cacheSize:  Int
    var cache:      [ColorVector]
    
    init(cacheSize: Int, manualGradient: ManualGradient) {
        self.cacheSize      = cacheSize
        
        // We want the cache to be filled with values for 0.0 to 1.0
        let divisor         = CGFloat(cacheSize - 1)
        
        // Note ..<
        self.cache          = (0..<cacheSize).map({CGFloat($0) / divisor}).map({manualGradient.colorVectorForPoint($0)})
    }
    
    func colorVectorForPoint(point: CGFloat) -> ColorVector {
        let pointAtCacheScale   = point * CGFloat(cacheSize - 1)
        
        let floored             = floor(pointAtCacheScale)
        
        let remainder           = pointAtCacheScale - floored
        
        let flooredInt = Int(floored)
        
        return (1.0 - remainder) * cache[flooredInt] + remainder * cache[flooredInt + 1]
    }
}



func circularGradientColorFunc<MG: ManualGradient>(manualGradient: MG)(x: CGFloat, y: CGFloat) -> NSColor {
    let (adjustedX, adjustedY) = (x - 0.5, y - 0.5)
    x
    let radians = atan2(CGFloat(adjustedY), CGFloat(adjustedX))
    
    let fraction = 0.5 + radians / CGFloat(M_PI * 2)
    
    return manualGradient.colorForPoint(fraction)
}

func horizontalGradientColorFunc<MG: ManualGradient>(manualGradient: MG)(x: CGFloat, y: CGFloat) -> NSColor {
    return manualGradient.colorForPoint(x)
}



class ManualGradientWithOffset: ManualGradient {
    var wrapAround     = true
    var offset: CGFloat = 0
    var storedGradient: ManualGradient
    
    init(storedGradient: ManualGradient) {
        self.storedGradient = storedGradient
    }
    
    func colorVectorForPoint(point: CGFloat) -> ColorVector {
        var newOffset = point + offset
        if wrapAround {
            newOffset = (newOffset % 1.0 + 1.0) % 1.0
        }
        return storedGradient.colorVectorForPoint(newOffset)
    }
}

let sideLength = 600
let rect = CGRect(x: 0, y: 0, width: sideLength, height: sideLength)

let myLinearGradient = LinearGradient(colorVectors: (ColorVector(color: NSColor.redColor())!, ColorVector(color: NSColor.yellowColor())!))

let myLinearGradientWithOffset = ManualGradientWithOffset(storedGradient: myLinearGradient)
myLinearGradientWithOffset.offset = 0.01

//let myCachedGradient = CachedGradient(cacheSize: 1000, manualGradient: myLinearGradientWithOffset)

//let myHorizontalColorMatrix = ColorMatrix(width: 10, height: 10, colorFunc: horizontalGradientColorFunc(myLinearGradient))
//
//let b = ColorMatrixView(frame: rect, colorMatrix: myHorizontalColorMatrix)

let numberOfColumns = 30

let myCircularColorMatrix   = ColorMatrix(width: numberOfColumns, height: numberOfColumns, colorFunc: circularGradientColorFunc(myLinearGradientWithOffset))

let c = ColorMatrixView(frame: rect, colorMatrix: myCircularColorMatrix)


//let cachedCircularColorMatrix = ColorMatrix(width: numberOfColumns, height: numberOfColumns, colorFunc: circularGradientColorFunc(myCachedGradient))

//let d = ColorMatrixView(frame: rect, colorMatrix: cachedCircularColorMatrix)

