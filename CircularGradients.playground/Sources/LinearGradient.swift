import Foundation

func linearTransitionFunc(point: CGFloat) -> CGFloat {
    if point < 0.0 {
        return 0.0
    } else if point > 1.0 {
        return 1.0
    } else {
        return point
    }
}

public class LinearGradient: ManualGradient {
    public init(startColorVector: ColorVector, endColorVector: ColorVector) {
        super.init(startColorVector: startColorVector, endColorVector: endColorVector, transitionFunc: linearTransitionFunc)
    }
}
