//  Created by Axel Ancona Esselmann on 12/27/20.
//  Copyright © 2020 Axel Ancona Esselmann. All rights reserved.
//

import SwiftQuadTree

class HotelCSVTreeBuilder {
    
    func buildTree(dataFileName: String, worldBounds: BoundingBox) -> QuadTreeNode<HotelInfo> {
        let nodes = getFileContent(fileName: dataFileName)
            .split(separator: "\n")
            .compactMap { HotelCSVTreeBuilder.dataFromLine(line: String($0)) }
        
        return QuadTreeNode(boundary: worldBounds, capacity: 4, nodes: nodes)
    }
    
    private static func dataFromLine(line: String) -> QuadTreeNodeData<HotelInfo>? {
        guard !line.isEmpty else {
            return nil
        }
        let components = line.components(separatedBy: ",")
        
        let latitude = Double(components[1].trimmingCharacters(in: .whitespacesAndNewlines))!
        let longitude = Double(components[0].trimmingCharacters(in: .whitespacesAndNewlines))!
        
        let hotelName = components[2].trimmingCharacters(in: .whitespacesAndNewlines)
        let hotelPhoneNumber = components.last!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let hotelInfo = HotelInfo(hotelName: hotelName, hotelPhoneNumber: hotelPhoneNumber)
        
        return QuadTreeNodeData(x: latitude, y: longitude, data: hotelInfo)
    }
    
    private func getFileContent(fileName: String) -> String {
        let path = Bundle.main.path(forResource: fileName, ofType: "csv")!
        do {
            return try String(
                contentsOfFile: path,
                encoding: String.Encoding.utf8
            )
        } catch {
            return ""
        }
    }
}
