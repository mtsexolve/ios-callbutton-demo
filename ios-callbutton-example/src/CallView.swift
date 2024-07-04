import SwiftUI
import ExolveVoiceSDK

struct CallView: View {
    @Binding private(set) var login: String
    @Binding private(set) var password: String
    @Binding private(set) var number: String

    @ObservedObject private var client = CallClientWrapper.instance

    var body: some View {
        VStack {
            Spacer()
            let calling = client.isCallEstablished
            Button(action: calling ? onTerminate : onCall) {
                ZStack {
                    Circle()
                        .fill(calling ? Color.red : Color.green)
                    Image(systemName: calling ? Images.CallDone : Images.Call)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.white)
                        .padding(.all, 40)
                }
                .frame(width: 250, height: 250, alignment: .center)
            }
            Spacer()
        }
    }

    private func onCall() {
        /* To keep things simple we are passing credentials before every call and removing them when call ends.
            This allows us not to bother with checking if credentials were changed on the settings page.
            In your app consider activating only once.
         */
        client.register(login, password)
        client.callToNumber(number: number)
    }

    private func onTerminate() {
        client.terminateCall()
    }
}
