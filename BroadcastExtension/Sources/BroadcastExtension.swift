import WidgetKit
import SwiftUI

@main
struct BroadcastWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        HomeScreenWidget()
        LockScreenWidget()
    }
}
