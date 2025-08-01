//
//  Item.swift
//  SleepScore
//
//  Created by Ayaan Haq on 2/22/25.
//

import SwiftUI

struct Item: Identifiable {
    var id: String = UUID().uuidString
    var image: String
    var title: String
    
    var scale: CGFloat = 1
    var anchor: UnitPoint = .center
    var offset: CGFloat = 0
    var rotation: CGFloat = 0
    var zindex: CGFloat = 0
    var extraOffset: CGFloat = -350
    
}
    let items: [Item] = [
        .init(
            image: "bed.double.circle.fill",
            title: "Enjoy better sleep",
            scale: 1
        ),
        .init(
            image: "clock.circle.fill",
            title: "Stay on top of your sleep schedule",
            scale: 0.4,
            anchor: .bottomLeading,
            offset: -50,
            rotation: 160,
            extraOffset: -120
        ),
        .init(
            image: "sunrise.circle.fill",
            title: "Wake up refreshed every morning",
            scale: 0.35,
            anchor: .bottomLeading,
            offset: -50,
            rotation: 250,
            extraOffset: -100
        )
    ]
