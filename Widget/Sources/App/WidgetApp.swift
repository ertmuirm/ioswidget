import SwiftUI

@main
struct WidgetApp: App {
    @StateObject private var viewModel = WidgetViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .preferredColorScheme(.dark)
        }
    }
}