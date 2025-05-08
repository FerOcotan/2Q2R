import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showLogoutMenu = false
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 0) {
            // Header con logo y menú desplegable
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("¡A lo que venimos!")
                        .font(.title)
                        .bold()
                        .foregroundColor(.primary)
                    Text("Ingresa tu pedido y envíalo.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Menu {
                    Button("Cerrar sesión", role: .destructive) {
                        Task {
                            do {
                                try await AuthenticationView().logout()
                            } catch {
                                errorMessage = error.localizedDescription
                            }
                        }
                    }
                } label: {
                    Image("hamburger")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                }
            }
            .padding()

            // Contenido central según tab
            ZStack {
                switch selectedTab {
                case 0:
                    HomeView()
                case 1:
                    MapsView()
                case 2:
                    MiListaView()
                default:
                    HomeView()
                }
            }
            .frame(maxHeight: .infinity)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.bottom)
            }

            // Tab bar inferior redondeada y centrada
            HStack {
                TabBarItem(title: "Home", icon: "house", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                TabBarItem(title: "Maps", icon: "map", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
                TabBarItem(title: "Mi Lista", icon: "list.bullet", isSelected: selectedTab == 2) {
                    selectedTab = 2
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(
                Color(hex: "#A08264").opacity(0.09)
                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 10)
        }
    }
}

// MARK: - TabBarItem personalizado
struct TabBarItem: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(isSelected ? Color.brown : .gray)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
            .background(isSelected ? Color.brown.opacity(0.1) : Color.clear)
            .cornerRadius(10)
        }
    }
}

// MARK: - Vistas simuladas
struct HomeView: View {
    var body: some View {
        Text("Pantalla Home")
            .font(.title)
            .foregroundColor(.brown)
    }
}

struct MapsView: View {
    var body: some View {
        Text("Pantalla Maps")
            .font(.title)
            .foregroundColor(.brown)
    }
}

struct MiListaView: View {
    var body: some View {
        Text("Pantalla Mi Lista")
            .font(.title)
            .foregroundColor(.brown)
    }
}

// MARK: - Extensión para color HEX
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, (int >> 16) & 0xff, (int >> 8) & 0xff, int & 0xff)
        case 8:
            (a, r, g, b) = ((int >> 24) & 0xff, (int >> 16) & 0xff, (int >> 8) & 0xff, int & 0xff)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
