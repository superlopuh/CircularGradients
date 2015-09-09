import Cocoa

public struct ColorMatrix {
    public let width:  Int
    public let height: Int
    
    public var matrix: [[NSColor]]
    
    public init(width: Int, height: Int, matrix: [[NSColor]]) {
        //TODO: check for width and height
        
        self.width  = width
        self.height = height
        
        self.matrix = matrix
    }
    
    public init(width: Int, height: Int, colorFunc: (x: Double, y: Double) -> NSColor) {
        self.width  = width
        self.height = height
        
        let floatWidth  = Double(width - 1)
        let floatHeight = Double(height - 1)
        
        let matrix  = (0..<height).map() {(row: Int) -> [NSColor] in
            return (0..<width).map() {(column: Int) -> NSColor in
                let x   = Double(column)   / floatWidth
                let y   = Double(row)      / floatHeight
                return colorFunc(x: x, y: y)
            }
        }
        
        self.matrix = matrix
    }
}
