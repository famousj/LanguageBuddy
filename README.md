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


## Running

Go into the settings and enter whatever language you want to know.
French, Sanskrit, Klingon, English as spoken in Scotland.  Whatever.

Then ask a question.  




