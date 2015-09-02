import Cocoa

public extension ColorVector {
    init?(color: NSColor) {
        guard let rgbColor = color.colorUsingColorSpace(NSColorSpace.deviceRGBColorSpace()) else {return nil}
        
        red     = rgbColor.redComponent
        green   = rgbColor.greenComponent
        blue    = rgbColor.blueComponent
        
        alpha   = rgbColor.alphaComponent
    }
}

public extension NSColor {
    convenience init(colorVector: ColorVector) {
        self.init(red: colorVector.red, green: colorVector.green, blue: colorVector.blue, alpha: colorVector.alpha)
    }
}