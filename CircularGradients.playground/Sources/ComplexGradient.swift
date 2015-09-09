import Foundation

//class ComplexGradient: ManualGradient {
//    var gradients: [(manualGradient: ManualGradient, length: CGFloat)] = []
//    var lastColorVector: ColorVector
//
//    init(firstColorVector: ColorVector) {
//        self.lastColorVector = firstColorVector
//    }
//
//    convenience init?(firstColor: NSColor = NSColor.clearColor()) {
//        if let firstColorVector = ColorVector(color: firstColor) {
//            self.init(firstColorVector: firstColorVector)
//        } else {
//            return nil
//        }
//    }
//
////    // Adds linear gradient
////    func addGradientToColor(endColor: NSColor, withLength length: CGFloat) {
////        guard let endColorVector = ColorVector(color: endColor) else {
////            let bla = 4 // add throw
////        }
////
////        var nextGradients       = gradients
////        let newLinearGradient   = LinearGradient(colorVectors: (lastColorVector, endColorVector))
////        nextGradients.append(manualGradient: newLinearGradient, length: length)
////
////        self.lastColorVector    = endColorVector
////        self.gradients          = nextGradients
////    }
//
//    func colorVectorForPoint(point: CGFloat) -> ColorVector {
//        return lastColorVector
//    }
//}
