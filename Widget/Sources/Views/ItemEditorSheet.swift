import SwiftUI

struct ItemEditorSheet: View {
    @EnvironmentObject var viewModel: WidgetViewModel
    @Environment(\.dismiss) var dismiss
    
    let item: WidgetItem
    @Binding var configuration: WidgetConfiguration
    
    @State private var editedItem: WidgetItem
    @State private var showingDeleteAlert = false
    
    init(item: WidgetItem, configuration: Binding<WidgetConfiguration>) {
        self.item = item
        _configuration = configuration
        _editedItem = State(initialValue: item)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        displayTypeSection
                        itemContentSection
                        colorSection
                        actionSection
                        deleteSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Edit Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveItem()
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
            .alert("Delete Item", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    deleteItem()
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to delete this item?")
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Display Type Section
    
    private var displayTypeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Display Type")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                ForEach(DisplayType.allCases, id: \.self) { type in
                    Button(action: { editedItem.displayType = type }) {
                        VStack(spacing: 8) {
                            Image(systemName: type == .icon ? "star.fill" : "textformat")
                                .font(.title2)
                            Text(type.rawValue.capitalized)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(editedItem.displayType == type ? Color.white : Color.white.opacity(0.1))
                        )
                        .foregroundColor(editedItem.displayType == type ? .black : .white)
                    }
                }
            }
        }
    }
    
    // MARK: - Item Content Section
    
    private var itemContentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(editedItem.displayType == .icon ? "Icon" : "Text")
                .font(.headline)
                .foregroundColor(.white)
            
            if editedItem.displayType == .icon {
                TextField("SF Symbol Name", text: $editedItem.sfSymbolName)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(suggestedSymbols, id: \.self) { symbol in
                            Button(action: { editedItem.sfSymbolName = symbol }) {
                                Image(systemName: symbol)
                                    .font(.title2)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        Circle()
                                            .fill(editedItem.sfSymbolName == symbol ? Color.white : Color.white.opacity(0.1))
                                    )
                                    .foregroundColor(editedItem.sfSymbolName == symbol ? .black : .white)
                            }
                        }
                    }
                }
            } else {
                TextField("Custom Text", text: $editedItem.customText)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
            
            HStack {
                Text("Font Size: \(editedItem.fontSize)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                
                Slider(value: Binding(
                    get: { Double(editedItem.fontSize) },
                    set: { editedItem.fontSize = Int($0) }
                ), in: 8...30, step: 1)
                .tint(.white)
            }
        }
    }
    
    // MARK: - Color Section
    
    private var colorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Colors")
                .font(.headline)
                .foregroundColor(.white)
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Foreground")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                    
                    ColorPicker("", selection: Binding(
                        get: { editedItem.foregroundColor.color },
                        set: { editedItem.foregroundColor = CodableColor(color: $0) }
                    ))
                    .labelsHidden()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Background")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                    
                    ColorPicker("", selection: Binding(
                        get: { editedItem.backgroundColor.color },
                        set: { editedItem.backgroundColor = CodableColor(color: $0) }
                    ))
                    .labelsHidden()
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(10)
            
            HStack {
                Text("Background Transparency")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                
                Spacer()
                
                Text("\(Int(editedItem.backgroundTransparency * 100))%")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            
            Slider(value: $editedItem.backgroundTransparency, in: 0...1, step: 0.05)
                .tint(.white)
        }
    }
    
    // MARK: - Action Section
    
    private var actionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Action")
                .font(.headline)
                .foregroundColor(.white)
            
            Menu {
                ForEach(ActionType.allCases, id: \.self) { type in
                    Button(action: { editedItem.actionType = type }) {
                        HStack {
                            Text(type.rawValue)
                            if editedItem.actionType == type {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(editedItem.actionType.rawValue)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
            }
            
            TextField(
                editedItem.actionType == .appIntent ? "Intent Identifier" : 
                    editedItem.actionType == .shortcut ? "Shortcut Name" : "URL Scheme",
                text: $editedItem.actionPayload
            )
            .textFieldStyle(.plain)
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(10)
            .foregroundColor(.white)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            
            if editedItem.actionType == .appIntent {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.availableAppIntents, id: \.identifier) { intent in
                            Button(action: { editedItem.actionPayload = intent.identifier }) {
                                Text(intent.name)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(editedItem.actionPayload == intent.identifier ? Color.white : Color.white.opacity(0.1))
                                    )
                                    .foregroundColor(editedItem.actionPayload == intent.identifier ? .black : .white)
                            }
                        }
                    }
                }
            } else if editedItem.actionType == .shortcut {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.availableShortcuts, id: \.identifier) { shortcut in
                            Button(action: { editedItem.actionPayload = shortcut.identifier }) {
                                Text(shortcut.name)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(editedItem.actionPayload == shortcut.identifier ? Color.white : Color.white.opacity(0.1))
                                    )
                                    .foregroundColor(editedItem.actionPayload == shortcut.identifier ? .black : .white)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Delete Section
    
    private var deleteSection: some View {
        Button(action: { showingDeleteAlert = true }) {
            HStack {
                Image(systemName: "trash")
                Text("Delete Item")
            }
            .font(.headline)
            .foregroundColor(.red)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red.opacity(0.1))
            .cornerRadius(10)
        }
        .padding(.top, 16)
    }
    
    // MARK: - Suggested Symbols
    
    private var suggestedSymbols: [String] {
        [
            "star.fill", "heart.fill", "bolt.fill", "flame.fill",
            "sun.max.fill", "moon.fill", "cloud.fill", "drop.fill",
            "gear", "house.fill", "car.fill", "bicycle",
            "play.fill", "pause.fill", "forward.fill", "backward.fill",
            "mic.fill", "speaker.wave.3.fill", "wifi", "antenna.radiowaves.left.and.right",
            "camera.fill", "photo", "doc.fill", "folder.fill",
            "trash.fill", "pencil", "plus", "minus",
            "xmark", "checkmark", "arrow.right", "arrow.left"
        ]
    }
    
    // MARK: - Actions
    
    private func saveItem() {
        viewModel.updateItem(editedItem, in: &configuration)
    }
    
    private func deleteItem() {
        viewModel.deleteItem(editedItem, from: &configuration)
    }
}