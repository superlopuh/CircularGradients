//: Playground - noun: a place where people can play

import Cocoa

struct ColorVector {
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
    
    init?(color: NSColor) {
        guard let rgbColor = color.colorUsingColorSpace(NSColorSpace.deviceRGBColorSpace()) else {return nil}
        
        red     = rgbColor.redComponent
        green   = rgbColor.greenComponent
        blue    = rgbColor.blueComponent
        
        alpha   = rgbColor.alphaComponent
    }
}

func +(lhs: ColorVector, rhs: ColorVector) -> ColorVector {
    return ColorVector(red: lhs.red + rhs.red, green: lhs.green + rhs.green, blue: lhs.blue + rhs.blue, alpha: lhs.alpha + rhs.alpha)
}

func *(lhs: CGFloat, rhs: ColorVector) -> ColorVector {
    return ColorVector(red: lhs * rhs.red, green: lhs * rhs.green, blue: lhs * rhs.blue, alpha: lhs * rhs.alpha)
}

func *(lhs: ColorVector, rhs: CGFloat) -> ColorVector {
    return ColorVector(red: lhs.red * rhs, green: lhs.green * rhs, blue: lhs.blue * rhs, alpha: lhs.red * rhs)
}

extension NSColor {
    convenience init(colorVector: ColorVector) {
        self.init(red: colorVector.red, green: colorVector.green, blue: colorVector.blue, alpha: colorVector.alpha)
    }
}

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

struct ColorMatrix {
    let width:  Int
    let height: Int
    
    var matrix: [[NSColor]]
    
    init(width: Int, height: Int, matrix: [[NSColor]]) {
        // check for width and height
        
        self.width  = width
        self.height = height
        
        self.matrix = matrix
    }
    
    init(width: Int, height: Int, colorFunc: (x: CGFloat, y: CGFloat) -> NSColor) {
        self.width  = width
        self.height = height
        
        let floatWidth  = CGFloat(width - 1)
        let floatHeight = CGFloat(height - 1)
        
        let matrix  = (0..<height).map() {(row: Int) -> [NSColor] in
            return (0..<width).map() {(column: Int) -> NSColor in
                let x   = CGFloat(column)   / floatWidth
                let y   = CGFloat(row)      / floatHeight
                return colorFunc(x: x, y: y)
            }
        }
        
        self.matrix = matrix
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

class ColorMatrixView: NSView {
    let colorMatrix: ColorMatrix
    var inverse     = true
    
    init(frame frameRect: CGRect, colorMatrix: ColorMatrix) {
        self.colorMatrix    = colorMatrix
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been imlemented")
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let width   = Double(rect.size.width)
        let height  = Double(rect.size.height)
        
        let pixelWidth  = width / Double(colorMatrix.width)
        let pixelHeight = height / Double(colorMatrix.height)
        
        for col in 0..<colorMatrix.width {
            for row in 0..<colorMatrix.height {
                let y = inverse ? Double(colorMatrix.height - 1 - row) * pixelHeight : Double(row) * pixelHeight
                colorMatrix.matrix[row][col].setFill()
                NSBezierPath.fillRect(CGRect(x: Double(col) * pixelWidth, y: y, width: pixelWidth, height: pixelHeight))
            }
        }
    }
}

extension NSColor {
    var rgbComponents: (CGFloat, CGFloat, CGFloat) {
        return (redComponent, greenComponent, blueComponent)
    }
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

