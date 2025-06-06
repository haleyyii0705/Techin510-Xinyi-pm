//
//  Moomo_WidgetLiveActivity.swift
//  Moomo Widget
//
//  Created by 邵林峥嵘 on 2025/6/6.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct Moomo_WidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct Moomo_WidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: Moomo_WidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension Moomo_WidgetAttributes {
    fileprivate static var preview: Moomo_WidgetAttributes {
        Moomo_WidgetAttributes(name: "World")
    }
}

extension Moomo_WidgetAttributes.ContentState {
    fileprivate static var smiley: Moomo_WidgetAttributes.ContentState {
        Moomo_WidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: Moomo_WidgetAttributes.ContentState {
         Moomo_WidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: Moomo_WidgetAttributes.preview) {
   Moomo_WidgetLiveActivity()
} contentStates: {
    Moomo_WidgetAttributes.ContentState.smiley
    Moomo_WidgetAttributes.ContentState.starEyes
}
