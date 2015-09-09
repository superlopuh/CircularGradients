import Cocoa

public extension ColorVector {
    init?(color: NSColor) {
        guard let rgbColor = color.colorUsingColorSpace(NSColorSpace.deviceRGBColorSpace()) else {return nil}
        
        red     = Double(rgbColor.redComponent)
        green   = Double(rgbColor.greenComponent)
        blue    = Double(rgbColor.blueComponent)
        
        alpha   = Double(rgbColor.alphaComponent)
    }
}

public extension NSColor {
    convenience init(colorVector: ColorVector) {
        self.init(red: CGFloat(colorVector.red), green: CGFloat(colorVector.green), blue: CGFloat(colorVector.blue), alpha: CGFloat(colorVector.alpha))
    }
}
