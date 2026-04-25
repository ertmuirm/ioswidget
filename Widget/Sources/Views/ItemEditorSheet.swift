import SwiftUI

struct ItemEditorSheet: View {
    let item: WidgetItem
    @Binding var configuration: WidgetConfiguration
    @EnvironmentObject var viewModel: WidgetViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Edit Item")
                    .foregroundColor(.white)
                    .font(.headline)
                
                Spacer()
            }
        }
        .navigationTitle("Edit Item")
        .navigationBarTitleDisplayMode(.inline)
    }
}
