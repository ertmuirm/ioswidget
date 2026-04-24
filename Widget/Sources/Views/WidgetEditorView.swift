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
        .onChange(of: configuration) { _, newValue in
            viewModel.updateConfiguration(newValue)
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Widget Preview
    
    private var widgetPreview: some View {
        GeometryReader { geometry in
            let size = calculatePreviewSize(for: configuration.homeScreenSize, in: geometry.size)
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(configuration.backgroundColor.color.opacity(1.0 - configuration.backgroundTransparency))
                
                LazyVGrid(columns: columnsForSize(configuration.homeScreenSize), spacing: 4) {
                    ForEach(configuration.items) { item in
                        ItemPreview(item: item, size: itemSize(for: configuration.homeScreenSize))
                            .onTapGesture {
                                selectedItem = item
                            }
                    }
                }
                .padding(8)
            }
            .frame(width: size.width, height: size.height)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
        }
    }
    
    private func calculatePreviewSize(for size: HomeScreenSize, in container: CGSize) -> CGSize {
        let baseWidth: CGFloat = min(container.width - 32, 320)
        let aspectRatio: CGFloat
        
        switch size {
        case .small:
            aspectRatio = 1.0
        case .medium:
            aspectRatio = 1.0
        case .large:
            aspectRatio = 2.0
        case .extraLarge:
            aspectRatio = 1.0
        }
        
        let width = baseWidth
        let height = width * aspectRatio
        
        return CGSize(width: width, height: height)
    }
    
    private func itemSize(for size: HomeScreenSize) -> CGFloat {
        switch size {
        case .small: return 60
        case .medium: return 32
        case .large: return 28
        case .extraLarge: return 24
        }
    }
    
    private func columnsForSize(_ size: HomeScreenSize) -> [GridItem] {
        let count: Int
        switch size {
        case .small: count = 1
        case .medium: count = 3
        case .large: count = 6
        case .extraLarge: count = 6
        }
        
        return (0..<count).map { _ in
            GridItem(.flexible(), spacing: 4)
        }
    }
    
    // MARK: - Items List
    
    private var itemsList: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Items")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(configuration.items.count)/\(configuration.itemCapacity)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.horizontal)
            .padding(.top)
            
            if configuration.items.isEmpty {
                Text("No items added yet")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.5))
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(configuration.items) { item in
                            ItemCard(item: item, isSelected: selectedItem?.id == item.id)
                                .onTapGesture {
                                    selectedItem = item
                                }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            if configuration.items.count < configuration.itemCapacity {
                Button(action: { viewModel.addItem(to: &configuration) }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Item")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
    }
}

// MARK: - Item Preview

struct ItemPreview: View {
    let item: WidgetItem
    let size: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(item.backgroundColor.color.opacity(1.0 - item.backgroundTransparency))
            
            if item.displayType == .icon {
                Image(systemName: item.sfSymbolName)
                    .font(.system(size: item.fontSize))
                    .foregroundColor(item.foregroundColor.color)
            } else {
                Text(item.customText)
                    .font(.system(size: CGFloat(item.fontSize)))
                    .foregroundColor(item.foregroundColor.color)
                    .lineLimit(1)
            }
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Item Card

struct ItemCard: View {
    let item: WidgetItem
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(item.backgroundColor.color.opacity(1.0 - item.backgroundTransparency))
                    .frame(width: 60, height: 60)
                
                if item.displayType == .icon {
                    Image(systemName: item.sfSymbolName)
                        .font(.title2)
                        .foregroundColor(item.foregroundColor.color)
                } else {
                    Text(item.customText)
                        .font(.caption)
                        .foregroundColor(item.foregroundColor.color)
                        .lineLimit(2)
                }
            }
            
            Text(item.displayType == .icon ? item.sfSymbolName : item.customText)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.7))
                .lineLimit(1)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
        )
    }
}