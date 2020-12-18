//
//  PaintingView.swift
//  FingerPainter
//
//  Created by Matthew Dias on 12/17/20.
//

import UIKit

let scale = UIScreen.main.scale
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let widthInPixels = Int(screenWidth * scale)
let heightInPixels = Int(screenHeight * scale)

class PaintingView: UIView {
    var brushColor: UIColor = .black

    private let drawingLayer = CALayer()
    private let context: CGContext = {
        let context = CGContext(data: nil,
                                width: widthInPixels,
                                height: heightInPixels,
                                bitsPerComponent: 8,
                                bytesPerRow: widthInPixels * 8 * 4,
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!

        context.translateBy(x: 0, y: CGFloat(heightInPixels))
        context.scaleBy(x: scale, y: -scale)
        context.setFillColor(UIColor.white.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))

        return context
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    private func commonInit() {
        self.layer.insertSublayer(drawingLayer, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        drawingLayer.frame = bounds
    }

    // MARK: - Touches
    var lastPoints: [CGPoint] = Array(repeating: CGPoint.zero, count: 4)

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard let lastPoint = touches.first?.location(in: self) else { return }

//        lastPoints.append(lastPoint)
//        lastPoints = Array(lastPoints.dropFirst())
        lastPoints = Array(repeating: lastPoint, count: 4)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        guard let newPoint = touches.first?.location(in: self) else { return }

        lastPoints.append(newPoint)
        lastPoints = Array(lastPoints.dropFirst())

        drawSegment()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        drawSegment()
        lastPoints = Array(repeating: CGPoint.zero, count: 4)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)

        drawSegment()
        lastPoints = Array(repeating: CGPoint.zero, count: 4)
    }

    // MARK: Helpers
    func drawSegment() {
        context.setStrokeColor(brushColor.cgColor)
        context.setLineWidth(10)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        let path = CGPath.smoothedPathSegment(points: lastPoints)
        context.addPath(path)
        context.strokePath()

        updateContents()
    }

    func updateContents() {
        let image = context.makeImage()
        CATransaction.performWithoutAnimation {
            drawingLayer.contents = image
        }
    }

    // MARK: Functionality
    func clearPainting() {
        context.setFillColor(UIColor.white.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))

        updateContents()
    }

    /// This is from us testing our specialized drawing context and layer
//    override func didMoveToWindow() {
//        super.didMoveToWindow()
//
//        context.setFillColor(red: 45/255, green: 164/255, blue: 200/255, alpha: 1)
//        context.fillEllipse(in: CGRect(x: 100, y: 100, width: 120, height: 50))
//        drawingLayer.contents = context.makeImage()
//    }

    /// This is from us discussing drawing with contexts
//    override func draw(_ rect: CGRect) {
//        guard let context = UIGraphicsGetCurrentContext() else { return }
//
//        context.setFillColor(red: 1, green: 0, blue: 0, alpha: 1)
//        context.fill(CGRect(x: 32, y: 32, width: 75, height: 75))
//
//        let path = UIBezierPath(roundedRect: CGRect(x: 64, y: 64, width: 64, height: 64), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 10, height: 10))
//        context.setFillColor(red: 0, green: 1, blue: 0, alpha: 1)
//        context.addPath(path.cgPath)
//        context.fillPath()
//    }
}

/// neat little util that removes the crossfade of drawing
extension CATransaction {
    static func performWithoutAnimation(_ block: () -> Void) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        block()
        CATransaction.commit()
    }

}
