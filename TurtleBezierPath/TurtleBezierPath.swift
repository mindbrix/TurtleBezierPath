//
//  TurtleBezierPath.swift
//
//  Created by Ben Hambrecht on 10.02.17.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2013 Nigel Timothy Barber
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//
//
//
//
//  based on:
//
//  TurtleBezierPath.h, .m
//
//  Created by Nigel Barber on 09/12/2013.
//  Copyright (c) 2013 Nigel Barber. All rights reserved.
//



import UIKit

class TurtleBezierPath: UIBezierPath {
    
    var bearing: CGFloat
    var penUp: Bool
    
    required override init() {
        bearing = 0
        penUp = false
        super.init()
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(bearing, forKey: "bearing")
        aCoder.encode(penUp, forKey: "penUp")
    }
    
    required init?(coder aDecoder: NSCoder) {
        bearing = CGFloat(aDecoder.decodeFloat(forKey: "bearing"))
        penUp = aDecoder.decodeBool(forKey: "penUp")
        super.init(coder: aDecoder)
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        return type(of:self).init()
    }
    
    
    
    func radians(_ degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat(M_PI) / 180.0
    }
    
    func toCartesian(_ radius: CGFloat, bearing: CGFloat, origin: CGPoint) -> CGPoint {
        
        let bearingInRadians = radians(bearing)
        let vector = CGPoint(x: radius * sin(bearingInRadians), y: -radius * cos(bearingInRadians))
        return CGPoint(x: origin.x + vector.x, y: origin.y + vector.y)
        
    }
    
    
    
    
    func arc(_ radius: CGFloat, turn angle: CGFloat, clockwise: Bool) {
        let radiusTurn: CGFloat = (clockwise) ? 90.0 : -90.0
        let cgAngleBias: CGFloat = (clockwise) ? 180.0 : 0.0
        let newAngle: CGFloat = (clockwise) ? angle : -angle
        
        let center = toCartesian(radius, bearing: bearing + radiusTurn, origin: currentPoint)
        let cgStartAngle = cgAngleBias + bearing
        let cgEndAngle = cgAngleBias + bearing + newAngle
        
        bearing += newAngle
        let endPoint = toCartesian(radiusTurn, bearing: bearing - radiusTurn, origin: center)
        
        if (penUp) {
            move(to: endPoint)
        } else {
            addArc(withCenter: center, radius: radius, startAngle: radians(cgStartAngle), endAngle: radians(cgEndAngle), clockwise: clockwise)
        }
    }
    
    
    
    func boundsWithStroke() -> CGRect {
        return bounds.insetBy(dx: -lineWidth * 0.5, dy: -lineWidth * 0.5).integral
    }
    
    
    func boundsForView() -> CGRect {
        
        let bounds = boundsWithStroke()
        let maxWidth = max(bounds.minX, bounds.maxX)
        let maxHeight = max(bounds.minY, bounds.maxY)
        return CGRect(x: 0.0, y: 0.0, width: 2.0 * maxWidth, height: 2.0 * maxHeight)
        
    }
    
    
    override func isEqual(_ object: Any?) -> Bool {
        if let aPath = object as? TurtleBezierPath {
            return (NSKeyedArchiver.archivedData(withRootObject: self) ==  NSKeyedArchiver.archivedData(withRootObject: aPath))
        } else {
            return false
        }
    }
    
    func home() {
        move(to: CGPoint.zero)
        bearing = 0.0
    }
    
    func forward(_ distance: CGFloat) {
        let endPoint = toCartesian(distance, bearing: bearing, origin: currentPoint)
        if (penUp) {
            move(to: endPoint)
        } else {
            addLine(to: endPoint)
        }
    }
    
    func turn(_ angle: CGFloat) {
        bearing += angle
    }
    
    func leftArc(_ radius: CGFloat, turn angle: CGFloat) {
        arc(radius, turn: angle, clockwise: false)
    }
    
    func rightArc(_ radius: CGFloat, turn angle: CGFloat) {
        arc(radius, turn: angle, clockwise: true)
    }
    
    func down() {
        penUp = false
    }
    
    func up() {
        penUp = true
    }
    
    func centerInBounds(_ bounds: CGRect) {
        apply(CGAffineTransform(translationX: bounds.size.width * 0.5, y: bounds.size.height * 0.5))
    }
    
    
    
    
    
}
