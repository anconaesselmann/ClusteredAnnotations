//  Created by Axel Ancona Esselmann on 12/27/20.
//  Copyright © 2020 Axel Ancona Esselmann. All rights reserved.
//

import UIKit
import Foundation
import MapKitCluster
import SwiftQuadTree
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    let TBAnnotatioViewReuseID = "TBAnnotatioViewReuseID"

    var tree: CoordinateQuadTree<HotelInfo>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self

        let root = HotelCSVTreeBuilder().buildTree(
            dataFileName: "USA-HotelMotel",
            worldBounds: BoundingBox.mapBoundingBox
        )
        tree = CoordinateQuadTree(root: root, mapView: mapView)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        views.forEach { $0.bounce() }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let zoomScale = mapView.zoomScale
        OperationQueue().addOperation() { [weak self] in
            guard let clusters = self?.tree?.clusters(withinMapRect: mapView.visibleMapRect, zoomScale: zoomScale) else {
                return
            }
            mapView.update(annotations: clusters.annotations)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = mapView
            .dequeueReusableAnnotationView(withIdentifier: TBAnnotatioViewReuseID) as? TBClusterAnnotationView
            ?? TBClusterAnnotationView(annotation: annotation, reuseIdentifier: TBAnnotatioViewReuseID)
        
        view.canShowCallout = true
        
        if let annotation = annotation as? TBClusterAnnotation {
            view.setCount(count: annotation.count)
        }
        
        return view
    }
}

extension Array where Element == Cluster<HotelInfo> {
    var annotations: [TBClusterAnnotation] {
        compactMap { cluster in
            guard !cluster.elements.isEmpty else { return nil }
            if cluster.count == 1 {
                return TBClusterAnnotation(
                    coordinate: cluster.coordinate,
                    count: cluster.count,
                    title: cluster.elements.first?.hotelName,
                    subtitle: cluster.elements.first?.hotelPhoneNumber
                )
            } else {
                return TBClusterAnnotation(coordinate: cluster.coordinate, count: cluster.count)
            }
        }
    }
}
