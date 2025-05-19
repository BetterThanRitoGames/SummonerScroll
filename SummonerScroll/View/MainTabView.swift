
import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var session: UserSession

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Accueil", systemImage: "house")
                }
            
            SearchView()
                .tabItem {
                    Label("Rechercher", systemImage: "magnifyingglass")
                }
            
            AccountView()
                .tabItem {
                    AsyncImage(url: URL(string: "https://ddragon.leagueoflegends.com/cdn/15.10.1/img/profileicon/\(session.iconId ?? 0).png")) { phase in
                        let size = CGSize(width: 30, height: 30)
                        
                        switch phase {
                        case .empty:
                            Image(systemName: "person.circle.fill")
                            Text("Profil")
                            
                        case .success(let image):
                            Image(size: size) { context in
                                context.clip(to: Path(ellipseIn: .init(origin: .zero, size: size)))
                                context.draw(image, in: .init(origin: .zero, size: size))
                            }
                            Text("Profil")
                            
                        case .failure(_):
                            Image(systemName: "xmark.circle")
                            Text("Profil")
                            
                        @unknown default:
                            Image(systemName: "questionmark.circle")
                            Text("Profil")
                        }
                    }
                }
        }
    }
}


#Preview {
    MainTabView()
        .environmentObject(UserSession())
}
