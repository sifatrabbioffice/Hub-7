import SwiftUI

@main
struct GameHubApp: App {
    var body: some Scene {
        WindowGroup {
            MainContentView()
        }
    }
}

// Logic for handling game states
class GameEngineManager: ObservableObject {
    @Published var isRunning = false
    @Published var activeGame: String? = nil
    
    func launchGame(_ name: String) {
        self.activeGame = name
        self.isRunning = true
        print("Initializing Engine for \(name)...")
    }
}

struct MainContentView: View {
    @StateObject var engine = GameEngineManager()
    
    var body: some View {
        if engine.isRunning {
            EmulatorRuntimeView(engine: engine)
        } else {
            LibraryView(engine: engine)
        }
    }
}

struct LibraryView: View {
    @ObservedObject var engine: GameEngineManager
    let games = ["Cyberpunk 2077", "GTA V", "Elden Ring"]
    
    var body: some View {
        NavigationView {
            List(games, id: \.self) { game in
                Button(action: { engine.launchGame(game) }) {
                    HStack {
                        Image(systemName: "pc").foregroundColor(.blue)
                        Text(game).fontWeight(.bold)
                        Spacer()
                        Image(systemName: "play.fill").font(.caption)
                    }
                }
            }
            .navigationTitle("GameHub Library")
        }
    }
}

struct EmulatorRuntimeView: View {
    @ObservedObject var engine: GameEngineManager
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                HStack {
                    Button("EXIT") { engine.isRunning = false }
                        .foregroundColor(.red).padding()
                    Spacer()
                    Text("STREAMING: \(engine.activeGame ?? "")").foregroundColor(.green)
                    Spacer()
                    Text("60 FPS").foregroundColor(.white.opacity(0.6)).padding()
                }
                Spacer()
            }
            
            // Virtual Controller Overlay
            HStack {
                // Joystick Placeholder
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    .frame(width: 120, height: 120)
                    .overlay(Circle().fill(Color.white.opacity(0.1)))
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 20) {
                    Button("Y") { print("Pressed Y") }.buttonStyle(GameButtonStyle(color: .yellow))
                    HStack(spacing: 20) {
                        Button("X") { }.buttonStyle(GameButtonStyle(color: .blue))
                        Button("B") { }.buttonStyle(GameButtonStyle(color: .red))
                    }
                    Button("A") { }.buttonStyle(GameButtonStyle(color: .green))
                }
            }
            .padding(50)
        }
    }
}

struct GameButtonStyle: ButtonStyle {
    var color: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 60, height: 60)
            .background(color.opacity(configuration.isPressed ? 0.5 : 0.2))
            .clipShape(Circle())
            .overlay(Circle().stroke(color, lineWidth: 2))
            .foregroundColor(.white)
    }
}
