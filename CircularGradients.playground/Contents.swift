//: Playground - noun: a place where people can play

import Cocoa

extension VectorGradient {
    func colorForPoint(point: CGFloat) -> NSColor {
        return NSColor(colorVector: colorVectorForPoint(point))
    }
}

func circularGradientColorFunc<VG: VectorGradient>(vectorGradient: VG)(x: CGFloat, y: CGFloat) -> NSColor {
    let (adjustedX, adjustedY) = (x - 0.5, y - 0.5)
    
    let radians = atan2(CGFloat(adjustedY), CGFloat(adjustedX))
    
    let fraction = 0.5 + radians / CGFloat(M_PI * 2)
    
    return vectorGradient.colorForPoint(fraction)
}

func horizontalGradientColorFunc<VG: VectorGradient>(vectorGradient: VG)(x: CGFloat, y: CGFloat) -> NSColor {
    return vectorGradient.colorForPoint(x)
}





let sideLength = 600
let rect = CGRect(x: 0, y: 0, width: sideLength, height: sideLength)

let myLinearGradient = LinearGradient(startColorVector: ColorVector(color: NSColor.redColor())!, endColorVector: ColorVector(color: NSColor.yellowColor())!)

let myLinearGradientWithOffset = VectorGradientWithOffset(storedGradient: myLinearGradient)
myLinearGradientWithOffset.offset = 0.01

//let myCachedGradient = CachedGradient(cacheSize: 1000, manualGradient: myLinearGradientWithOffset)

//let myHorizontalColorMatrix = ColorMatrix(width: 10, height: 10, colorFunc: horizontalGradientColorFunc(myLinearGradient))
//
//let b = ColorMatrixView(frame: rect, colorMatrix: myHorizontalColorMatrix)

let numberOfColumns = 100
let time0 = NSDate()
let myCircularColorMatrix   = ColorMatrix(width: numberOfColumns, height: numberOfColumns, colorFunc: circularGradientColorFunc(myLinearGradientWithOffset))

let c = ColorMatrixView(frame: rect, colorMatrix: myCircularColorMatrix) 

let time1 = NSDate()

let timeDiff = time1.timeIntervalSinceDate(time0)

//let cachedCircularColorMatrix = ColorMatrix(width: numberOfColumns, height: numberOfColumns, colorFunc: circularGradientColorFunc(myCachedGradient))

//let d = ColorMatrixView(frame: rect, colorMatrix: cachedCircularColorMatrix)

