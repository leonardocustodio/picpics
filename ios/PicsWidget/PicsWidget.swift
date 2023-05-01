//
//  PicsWidget.swift
//  PicsWidget
//
//  Created by Leonardo Custodio on 19/11/20.
//

import WidgetKit
import SwiftUI

private let widgetGroupId = "group.br.com.inovatso.picPics.Widget"

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ExampleEntry {
        ExampleEntry(date: Date(), imageEncoded: "")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ExampleEntry) -> ()) {
        let data = UserDefaults.init(suiteName:widgetGroupId)
        
        let entry = ExampleEntry(date: Date(), imageEncoded: data?.string(forKey: "imageEncoded") ?? "")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
           getSnapshot(in: context) { (entry) in
               let timeline = Timeline(entries: [entry], policy: .atEnd)
               completion(timeline)
           }
       }
}

struct ExampleEntry: TimelineEntry {
    let date: Date
    let imageEncoded: String
}

struct PicsWidgetEntryView : View {
    var entry: Provider.Entry
    let data = UserDefaults.init(suiteName:widgetGroupId)
    
    var body: some View {
        Image(uiImage: UIImage.init(data: Data(base64Encoded: entry.imageEncoded)!)!).resizable().scaledToFill()
    }
}

@main
struct PicsWidget: Widget {
    let kind: String = "PicWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PicsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Starred Photos")
        .description("We will show your starred picPics' photos in this widget.")
    }
}

struct PicsWidget_Previews: PreviewProvider {
    static var previews: some View {
        PicsWidgetEntryView(entry: ExampleEntry(date: Date(), imageEncoded: ""))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

//import WidgetKit
//import SwiftUI
//import Intents
//
//struct Provider: IntentTimelineProvider {
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
//    }
//
//    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date(), configuration: configuration)
//        completion(entry)
//    }
//
//    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [SimpleEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, configuration: configuration)
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
//    }
//}
//
//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let configuration: ConfigurationIntent
//}
//
//struct HomeWidgetEntryView : View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        Text(entry.date, style: .time)
//    }
//}
//
//@main
//struct HomeWidget: Widget {
//    let kind: String = "HomeWidget"
//
//    var body: some WidgetConfiguration {
//        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
//            HomeWidgetEntryView(entry: entry)
//        }
//        .configurationDisplayName("My Widget")
//        .description("This is an example widget.")
//    }
//}
//
//struct HomeWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
