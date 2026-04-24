import Foundation
import SwiftUI
import Combine
import WidgetKit

final class WidgetViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published var configurations: [WidgetConfiguration] = []
    @Published var selectedConfiguration: WidgetConfiguration?
    @Published var availableAppIntents: [AppIntentInfo] = []
    @Published var availableShortcuts: [ShortcutInfo] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    // MARK: - Private Properties
    
    private let userDefaults = UserDefaults(suiteName: "group.com.iosmirror")
    private let configurationsKey = "widget_configurations"
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init() {
        loadConfigurations()
        scanInstalledApps()
    }
    
    // MARK: - Configuration Management
    
    func createNewConfiguration() {
        let newConfig = WidgetConfiguration(
            name: "Widget \(configurations.count + 1)",
            homeScreenSize: .small,
            itemCapacity: 1,
            items: []
        )
        configurations.append(newConfig)
        selectedConfiguration = newConfig
        saveConfigurations()
        reloadWidgets()
    }
    
    func deleteConfiguration(_ config: WidgetConfiguration) {
        configurations.removeAll { $0.id == config.id }
        if selectedConfiguration?.id == config.id {
            selectedConfiguration = nil
        }
        saveConfigurations()
        reloadWidgets()
    }
    
    func updateConfiguration(_ config: WidgetConfiguration) {
        if let index = configurations.firstIndex(where: { $0.id == config.id }) {
            configurations[index] = config
            saveConfigurations()
            reloadWidgets()
        }
    }
    
    func selectConfiguration(_ config: WidgetConfiguration) {
        selectedConfiguration = config
    }
    
    // MARK: - Item Management
    
    func addItem(to config: inout WidgetConfiguration) {
        guard config.items.count < config.itemCapacity else { return }
        
        let newItem = WidgetItem()
        config.items.append(newItem)
        updateConfiguration(config)
    }
    
    func updateItem(_ item: WidgetItem, in config: inout WidgetConfiguration) {
        if let index = config.items.firstIndex(where: { $0.id == item.id }) {
            config.items[index] = item
            updateConfiguration(config)
        }
    }
    
    func deleteItem(_ item: WidgetItem, from config: inout WidgetConfiguration) {
        config.items.removeAll { $0.id == item.id }
        updateConfiguration(config)
    }
    
    // MARK: - Persistence
    
    private func saveConfigurations() {
        do {
            let data = try JSONEncoder().encode(configurations)
            userDefaults?.set(data, forKey: configurationsKey)
        } catch {
            showError(message: "Failed to save configurations: \(error.localizedDescription)")
        }
    }
    
    private func loadConfigurations() {
        guard let data = userDefaults?.data(forKey: configurationsKey) else { return }
        
        do {
            configurations = try JSONDecoder().decode([WidgetConfiguration].self, from: data)
        } catch {
            showError(message: "Failed to load configurations: \(error.localizedDescription)")
        }
    }
    
    // MARK: - App Scanning
    
    private func scanInstalledApps() {
        isLoading = true
        availableAppIntents = [
            AppIntentInfo(name: "Take Photo", identifier: "com.apple.uikit.camera", appName: "Camera", appBundleId: "com.apple.camera"),
            AppIntentInfo(name: "Open Settings", identifier: "com.apple.settings", appName: "Settings", appBundleId: "com.apple.Preferences"),
            AppIntentInfo(name: "Toggle Flashlight", identifier: "com.apple.flashlight", appName: "Flashlight", appBundleId: "com.apple.flashlight"),
            AppIntentInfo(name: "Start Timer", identifier: "com.apple.timer", appName: "Timer", appBundleId: "com.apple.mobiletimer"),
            AppIntentInfo(name: "Start Stopwatch", identifier: "com.apple.stopwatch", appName: "Stopwatch", appBundleId: "com.apple.stopwatch"),
            AppIntentInfo(name: "Open Calculator", identifier: "com.apple.calculator", appName: "Calculator", appBundleId: "com.apple.calculator"),
            AppIntentInfo(name: "Open Maps", identifier: "com.apple.Maps", appName: "Maps", appBundleId: "com.apple.Maps"),
            AppIntentInfo(name: "Call Emergency", identifier: "com.apple. emergency", appName: "Emergency", appBundleId: "com.apple.emergency")
        ]
        
        availableShortcuts = [
            ShortcutInfo(name: "Morning Routine", identifier: "MorningRoutine"),
            ShortcutInfo(name: "Workout", identifier: "Workout"),
            ShortcutInfo(name: "Focus Mode", identifier: "FocusMode"),
            ShortcutInfo(name: "Do Not Disturb", identifier: "DoNotDisturb")
        ]
        
        isLoading = false
    }
    
    // MARK: - Widget Refresh
    
    func reloadWidgets() {
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    // MARK: - Error Handling
    
    private func showError(message: String) {
        errorMessage = message
        showError = true
    }
    
    // MARK: - Backup/Restore
    
    func exportConfigurations() -> Data? {
        try? JSONEncoder().encode(configurations)
    }
    
    func importConfigurations(from data: Data) -> Bool {
        do {
            let imported = try JSONDecoder().decode([WidgetConfiguration].self, from: data)
            configurations = imported
            saveConfigurations()
            reloadWidgets()
            return true
        } catch {
            showError(message: "Failed to import configuration: \(error.localizedDescription)")
            return false
        }
    }
}