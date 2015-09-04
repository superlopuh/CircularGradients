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
    
    public init(width: Int, height: Int, colorFunc: (x: CGFloat, y: CGFloat) -> NSColor) {
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
