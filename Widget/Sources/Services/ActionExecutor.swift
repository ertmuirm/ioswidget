import Foundation
import UIKit
import AppIntents

final class ActionExecutor {
    static let shared = ActionExecutor()
    
    private init() {}
    
    func executeAction(for item: WidgetItem) {
        switch item.actionType {
        case .urlScheme:
            executeURLScheme(item.actionPayload)
        case .appIntent:
            executeAppIntent(item.actionPayload)
        case .shortcut:
            executeShortcut(item.actionPayload)
        }
    }
    
    // MARK: - URL Scheme
    
    private func executeURLScheme(_ urlScheme: String) {
        var urlString = urlScheme
        
        if !urlString.contains("://") && !urlString.hasPrefix("http") {
            urlString = urlString.lowercased()
            if !urlString.hasPrefix("\(urlString)://") {
                urlString = "\(urlString)://"
            }
        }
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL scheme: \(urlScheme)")
            return
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.open(url, options: [.universalLinksOnly: false]) { success in
                if !success {
                    print("Failed to open URL: \(urlString)")
                }
            }
        }
    }
    
    // MARK: - App Intent
    
    private func executeAppIntent(_ identifier: String) {
        print("Executing app intent: \(identifier)")
        
        var urlString = "intent://\(identifier)"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: - Shortcut
    
    private func executeShortcut(_ name: String) {
        print("Executing shortcut: \(name)")
    }
}

// MARK: - Widget Action Intent

import SwiftUI
import WidgetKit

struct WidgetActionIntent: AppIntent {
    static var title: LocalizedStringResource = "Widget Action"
    static var description = IntentDescription("Executes a widget action")
    
    @Parameter(title: "Item ID")
    var itemId: String
    
    init() {}
    
    init(itemId: String) {
        self.itemId = itemId
    }
    
    func perform() async throws -> some IntentResult {
        // Load the item and execute its action
        let userDefaults = UserDefaults(suiteName: "group.com.iosmirror")
        if let data = userDefaults?.data(forKey: "widget_configurations"),
           let configurations = try? JSONDecoder().decode([WidgetConfiguration].self, from: data) {
            for config in configurations {
                for item in config.items {
                    if item.id.uuidString == itemId {
                        ActionExecutor.shared.executeAction(for: item)
                        break
                    }
                }
            }
        }
        
        return .result()
    }
}