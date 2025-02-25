//
//  SpintrickWidgetAttributes.swift
//  spintrick
//
//  Created by Slywa on 15.02.2025.
//


//
//  File.swift
//  spintrick
//
//  Created by Slywa on 15.02.2025.
//

import Foundation
import ActivityKit

struct SpintrickWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}



