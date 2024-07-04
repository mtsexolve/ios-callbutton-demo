# ios-callbutton-example

Example app to show how to use ExolveVoiceSDK only for outgoing calls.

### Highlights

- To initialize SDK use `+(Communicator*)communicatorForOutgoingCalls:(Configuration*)configuration`.
- CallClient's `registerUser:(NSString*)user password:(NSString*)password` should be invoked before making calls. It will only initialize the user agent without actual SIP registration.
- Provide `CallsDelegate` implementation to handle calls events.
- Implementing `RegistrationDelegate` is not required in this mode, but still can be done. Note that after activation registration state will be `RS_Offline` instead of `RS_Registered`.