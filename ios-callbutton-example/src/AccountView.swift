import SwiftUI

struct AccountView: View {
    @Binding var login: String
    @Binding var password: String
    @Binding var number: String

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.clear)
                .contentShape(Rectangle())
                .onTapGesture { resignFirstResponder() }
            VStack {
                Group {
                    AccountTextField(value: $login, hint: Strings.AccountLogin)
                    AccountTextField(value: $password, hint: Strings.AccountPassword)
                    AccountTextField(value: $number, hint: Strings.AccountNumber)
                }
                .padding(.horizontal)
                Spacer()
                HStack {
                    Image(systemName: "info.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                        .frame(height: 18)
                        .padding(.leading, 2)
                    Text(Bundle.main.bundleIdentifier! + "\n" + CallClientWrapper.instance.versionDescription)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    Spacer()
                }
            }
            .padding(.top)
        }
    }

    private func resignFirstResponder() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}
