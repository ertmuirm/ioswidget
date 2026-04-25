import SwiftUI

struct WidgetEditorView: View {
    @EnvironmentObject var viewModel: WidgetViewModel
    @State private var configuration: WidgetConfiguration
    @State private var selectedItem: WidgetItem?
    @State private var isEditing = false
    
    init(configuration: WidgetConfiguration) {
        _configuration = State(initialValue: configuration)
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                widgetPreview
                    .padding()
                
                Divider()
                    .background(Color.white.opacity(0.2))
                
                itemsList
            }
        }
        .navigationTitle(configuration.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { isEditing.toggle() }) {
                    Text(isEditing ? "Done" : "Edit")
                        .foregroundColor(.white)
                }
            }
        }
        .sheet(item: $selectedItem) { item in
            ItemEditorSheet(item: item, configuration: $configuration)
                .environmentObject(viewModel)
        }
        .onChange(of: configuration) { newValue in
            viewModel.updateConfiguration(newValue)
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Widget Preview
    
    private var widgetPreview: some View {
        Group {
            if configuration.items.isEmpty {
                Text("No items")
                    .foregroundColor(.white)
            } else {
                // Preview grid
                Text("Preview")
                    .foregroundColor(.white)
            }
        }
    }
    
    // MARK: - Items List
    
    private var itemsList: some View {
        List {
            ForEach(configuration.items) { item in
                HStack {
                    if item.displayType == .icon {
                        Image(systemName: item.sfSymbolName)
                    } else {
                        Text(item.customText)
                    }
                    Spacer()
                }
                .listRowBackground(Color.black)
            }
        }
        .listStyle(.plain)
    }
}
