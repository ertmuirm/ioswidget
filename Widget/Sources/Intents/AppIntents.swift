import AppIntents

struct MyAppIntents: AppIntentsProvider {
    static var appIntents: [AppIntent] {
        WidgetActionIntent()
    }
}

// MARK: - Widget Configuration Intent

struct OpenWidgetEditorIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Widget Editor"
    static var description = IntentDescription("Opens the widget editor")
    
    init() {}
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}

// MARK: - Create New Widget Intent

struct CreateNewWidgetIntent: AppIntent {
    static var title: LocalizedStringResource = "Create New Widget"
    static var description = IntentDescription("Creates a new widget configuration")
    
    init() {}
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}