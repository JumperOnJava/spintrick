//
//  SpintrickWidgetLiveActivity.swift
//  SpintrickWidget
//
//  Created by Slywa on 15.02.2025.
//

import ActivityKit
import WidgetKit
import SwiftUI


struct SpintrickWidgetLiveActivity: Widget {
    let kind: String = "SpintrickWidgetLiveActivity"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SpintrickWidgetAttributes.self) { context in
            VStack {
                Text(context.state.emoji)
                    .font(.headline)
            }
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    EmptyView()
                }
                DynamicIslandExpandedRegion(.trailing) {
                    EmptyView()
                }
                DynamicIslandExpandedRegion(.bottom) {
                    EmptyView()
                }
            }
            compactLeading: {EmptyView()}
            compactTrailing: {Text(context.state.emoji).transition(.opacity)}
            minimal: {
                Text(context.state.emoji).transition(.opacity).padding([Edge.Set.leading],1)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.yellow)
        }
    }
}

extension SpintrickWidgetAttributes {
    fileprivate static var preview: SpintrickWidgetAttributes {
        SpintrickWidgetAttributes(name: "World")
    }
}

extension SpintrickWidgetAttributes.ContentState {
    fileprivate static var smiley: SpintrickWidgetAttributes.ContentState {
        SpintrickWidgetAttributes.ContentState(emoji: "😎")
    }
    
    fileprivate static var starEyes: SpintrickWidgetAttributes.ContentState {
        SpintrickWidgetAttributes.ContentState(emoji: "🤩")
    }
}

#Preview("Notification", as: .content, using: SpintrickWidgetAttributes.preview) {
    SpintrickWidgetLiveActivity()
} contentStates: {
    SpintrickWidgetAttributes.ContentState.smiley
    SpintrickWidgetAttributes.ContentState.starEyes
}
