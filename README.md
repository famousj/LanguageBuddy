# Language Buddy

Turbo-charge your language learning with the power of GPT.

## Installation

Currently this app must be built in XCode and installed on your iOS
device.  

First, clone this repo and open it in XCode.

You will need a token from OpenAI.  Go here for that:

<https://platform.openai.com/account/api-keys>

You may have to log in or sign up first. 

Select "Create a new secret key" and name it "Language Buddy" or
whatever.

Copy the key.  

Then go to the file `LanguageBuddy/Models/OpenAIClient.swift`.  At the top there's a field for `clientCredential`.  Replace  `"OPENAI_API_KEY"` with the key you just created from OpenAI.

Now you can build the app and run it on your device.

## TODO

- The app is currently hard-coded to "European Portuguese", because
  that's what I'm learning.  I'm adding the ability to freehand any
  language you want.  Brazilian Portuguese, Finnish, Klingon, English as
  spoken in Scotland, whatever.

  In the meantime, you can change this value in the file `LanguageBuddy/View Models/AppViewModel.swift`.

- Many other features coming soon.


