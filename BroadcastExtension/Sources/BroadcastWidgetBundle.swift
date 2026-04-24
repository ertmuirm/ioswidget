import WidgetKit
import SwiftUI

@main
struct BroadcastWidgetBundle: WidgetBundle {
    var body: some Widget {
        HomeScreenWidget()
        LockScreenWidget()
    }
}