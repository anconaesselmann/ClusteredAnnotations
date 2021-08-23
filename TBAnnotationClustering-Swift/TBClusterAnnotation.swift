//  Created by Axel Ancona Esselmann on 12/27/20.
//  Copyright © 2020 Axel Ancona Esselmann. All rights reserved.
//

import MapKit

final class TBClusterAnnotation: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    let count:Int

    var title:String?
    var subtitle:String?
    
    init(coordinate: CLLocationCoordinate2D, count: Int, title: String? = nil, subtitle: String? = nil) {
        self.coordinate = coordinate
        self.title = title ?? "\(count) hotels in this area"
        self.count = count
        self.subtitle = subtitle
        super.init()
    }

    override var hash: Int {
        "\(coordinate.latitude):\(coordinate.longitude)".hashValue
    }

    public override func isEqual(_ other: (Any)?) -> Bool {
        let lhs = self
        guard let rhs = other as? Self else {
            return false
        }
        return lhs.coordinate.latitude == rhs.coordinate.latitude && lhs.coordinate.longitude == rhs.coordinate.longitude
    }

}




