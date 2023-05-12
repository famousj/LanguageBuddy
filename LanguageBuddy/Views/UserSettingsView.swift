import SwiftUI

struct UserSettingsView: View {
    @Binding var userSettings: UserSettings
    
    var body: some View {
        Form {
            TextField("Language", text: $userSettings.language)
            Picker("Select your Model", selection: $userSettings.model) {
                ForEach(Model.allCases) { model in
                    Text(model.name).tag(model)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

struct UserSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsView(userSettings: .constant(UserSettings.empty))
    }
}
