//  Created by Axel Ancona Esselmann on 12/27/20.
//  Copyright © 2020 Axel Ancona Esselmann. All rights reserved.
//

import MapKit

class TBClusterAnnotationView: MKAnnotationView {
    
    let TBScaleFactorAlpha: Float = 0.3
    let TBScaleFactorBeta: Float = 0.4
    
    private var count: Int?
    private var countLabel: UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clear
        setupLabel()
        setCount(count: 1)
    }
    
    func TBScaledValueForValue(value: Float, multiplier: Float) -> Float {
        // Multiplier * (1/e^(-Alpha * X^(Beta)))
        return multiplier * (1.0 / (1.0 + expf(-1 * TBScaleFactorAlpha * powf(value, TBScaleFactorBeta))))
    }
    
    func TBCenterRect(rect: CGRect, center: CGPoint) -> CGRect {
        let r = CGRect(x: center.x - rect.size.width/2.0, y: center.y - rect.size.height/2.0, width: rect.size.width, height: rect.size.height)
        return r
    }
    
    func TBRectCenter(rect: CGRect) -> CGPoint {
        return CGPoint(x: rect.midX, y: rect.midY);
    }
    
    func setupLabel() {
        countLabel = UILabel(frame: self.frame)
        countLabel?.backgroundColor = UIColor.clear
        countLabel?.textColor = UIColor.white
        countLabel?.textAlignment = NSTextAlignment.center
        countLabel?.shadowColor = UIColor(white: 0, alpha: 0.75)
        countLabel?.shadowOffset = CGSize(width: 0, height: -1)
        countLabel?.adjustsFontSizeToFitWidth = true
        countLabel?.numberOfLines = 1
        countLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        countLabel?.baselineAdjustment = UIBaselineAdjustment.alignCenters
        
        addSubview(countLabel!)
    }
    
    func setCount(count: Int) {
        self.count = count
        let size = CGFloat(roundf(TBScaledValueForValue(value: Float(count), multiplier: 44.0)))
        
        let newBounds = CGRect(x: 0, y: 0, width: size, height: size)
        frame = TBCenterRect(rect: newBounds, center: self.center)
        
        let newLabelBounds:CGRect = CGRect(x: 0, y: 0, width: newBounds.size.width, height: newBounds.size.height)
        countLabel?.frame = TBCenterRect(rect: newLabelBounds, center: TBRectCenter(rect: newBounds))
        countLabel?.text = String(count)
        
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        
        context.setAllowsAntialiasing(true)
        
        let outerCircleStrokeColor = UIColor(white: 0, alpha: 0.25)
        let innerCircleStrokeColor = UIColor.white
        var innerCircleFillColor = UIColor(red: (255.0 / 255.0), green: (95.0 / 255.0), blue: (42.0 / 255.0), alpha: 1.0)
        if(count == 1) {
            innerCircleFillColor = UIColor(red: (95.0 / 255.0), green: (150.0 / 255.0), blue: (42.0 / 255.0), alpha: 1.0)
        }
        
        let circleFrame = rect.insetBy(dx: 4, dy: 4)
        
        outerCircleStrokeColor.setStroke()
        context.setLineWidth(5.0)
        context.strokeEllipse(in: circleFrame)
        
        innerCircleStrokeColor.setStroke()
        context.setLineWidth(4.0)
        context.strokeEllipse(in: circleFrame)
        
        innerCircleFillColor.setFill()
        context.fillEllipse(in: circleFrame)
    }
}
