//
//  OrderAttributes.swift
//  LiveActivity
//
//  Created by Doris Wen on 2023/12/27.
//

import SwiftUI
import ActivityKit

struct OrderAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        // MARK: Live Activities will update its view when content state updated
        var status: Status = .recieved
    }
    var orderNum: Int
    var orderItem: String
}

// MARK: Order Status
enum Status: String, CaseIterable, Codable, Equatable {
    case recieved = "shippingbox.fill"
    case progress = "person.bust"
    case ready = "takeoutbag.and.cup.and.straw.fill"
}
