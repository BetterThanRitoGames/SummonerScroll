
import SwiftUI

@main
struct SummonerScrollApp: App {
    @StateObject private var session = UserSession()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(session)
        }
    }
}
