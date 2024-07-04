import SwiftUI

struct RootView: View {
    @State var tabIndex = 0
    @State private var login: String
    @State private var password: String
    @State private var number: String

    var body: some View {
        TabView(selection: $tabIndex) {
            CallView(login: $login, password: $password, number: $number)
                .tabItem {
                    Image(systemName: Images.CallCircle)
                        .resizable()
                    Text(Strings.Call)
                }
                .tag(0)
                .onAppear() {
                    storeCredentials()
                }
            AccountView(login: $login, password: $password, number: $number)
                .tabItem {
                    Image(systemName: Images.AccountCircle)
                        .resizable()
                    Text(Strings.Account)
                }
                .tag(1)
        }
    }

    private struct UserKey {
        static let Login = "login"
        static let Password = "password"
        static let Number = "number"
    }

    init() {
        let prefs = UserDefaults.standard
        login = prefs.string(forKey: UserKey.Login) ?? ""
        password = prefs.string(forKey: UserKey.Password) ?? ""
        number = prefs.string(forKey: UserKey.Number) ?? ""
    }

    private func storeCredentials() {
        let prefs = UserDefaults.standard
        prefs.set(login, forKey: UserKey.Login);
        prefs.set(password, forKey: UserKey.Password);
        prefs.set(number, forKey: UserKey.Number);
    }
}
