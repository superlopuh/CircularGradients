import Cocoa

public class ColorMatrixView: NSView {
    let colorMatrix: ColorMatrix
    var inverse     = true
    
    public init(frame frameRect: CGRect, colorMatrix: ColorMatrix) {
        self.colorMatrix    = colorMatrix
        super.init(frame: frameRect)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been imlemented")
    }
    
    override public func drawRect(rect: CGRect) {
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