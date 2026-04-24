import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: WidgetViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                if viewModel.configurations.isEmpty {
                    emptyStateView
                } else {
                    configurationsListView
                }
            }
            .navigationTitle("Widget")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { viewModel.createNewConfiguration() }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .secondaryAction) {
                    Menu {
                        Button(action: exportConfiguration) {
                            Label("Export", systemImage: "square.and.arrow.up")
                        }
                        Button(action: importConfiguration) {
                            Label("Import", systemImage: "square.and.arrow.down")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.white)
                    }
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "An error occurred")
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.5))
            
            Text("No Widgets")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text("Create your first widget to get started")
                .font(.body)
                .foregroundColor(.white.opacity(0.7))
            
            Button(action: { viewModel.createNewConfiguration() }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Create Widget")
                }
                .font(.headline)
                .foregroundColor(.black)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.white)
                .cornerRadius(10)
            }
            .padding(.top, 20)
        }
    }
    
    // MARK: - Configurations List
    
    private var configurationsListView: some View {
        List {
            ForEach(viewModel.configurations) { config in
                NavigationLink(destination: WidgetEditorView(configuration: config)) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(config.name)
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text("\(config.homeScreenSize.rawValue) • \(config.items.count) items")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        Spacer()
                        
                        Circle()
                            .fill(Color.white)
                            .frame(width: 10, height: 10)
                            .opacity(config.items.isEmpty ? 0.3 : 1.0)
                    }
                    .padding(.vertical, 4)
                }
                .listRowBackground(Color(white: 0.1))
            }
            .onDelete { indexSet in
                for index in indexSet {
                    viewModel.deleteConfiguration(viewModel.configurations[index])
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    // MARK: - Export/Import
    
    private func exportConfiguration() {
        guard let data = viewModel.exportConfigurations() else { return }
        
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("widget_backup.json")
        try? data.write(to: tempURL)
        
        print("Export data saved to: \(tempURL.path)")
    }
    
    private func importConfiguration() {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("widget_backup.json")
        
        if let data = try? Data(contentsOf: tempURL) {
            _ = viewModel.importConfigurations(from: data)
        }
    }
}