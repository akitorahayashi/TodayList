import WidgetKit
import SwiftUI

struct ShowToDosInAWorkspaceWidgetEntryView : View {
    var entry: TLProvider.Entry
    
    // @Environmentを使ってWidgetFamilyを取得
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        GeometryReader { geometry in
            // ToDoリストの表示
            TLToDoListView(entry: entry)
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top) // 上寄せ
        }
    }
}


#Preview(as: .systemSmall) {
    ShowToDosInAWorkspaceWidget()
} timeline: {
    TLWidgetEntry(date: .now, configuration: TLWidgetKitSettingsIntent(), selectedThemeIdx: 0, tlWorkspaces: TLWorkspace.decodeWorkspaces(from: kTLContentExample) ?? [])
}

