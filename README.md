# GEMINI LENS

A AI lens, where the user can click a photo and ask anything about it. Built with Flutter and the Gemini API.

# Project Demo



https://github.com/user-attachments/assets/34a40967-cdde-4648-98ea-692783045c1f






## Getting Started

To get started you will have to create an API key from https://ai.google.dev/gemini-api/docs.

After creating the api key in the root folder create a file with the name .env => add "GEMINI_API_KEY" and paste your API key that you created.


## Project Structure

The app follows a clean architecture approach using Provider for state management.
There are the following layers

1. Data Layer => Used to get the data from the api or from local data source (no local data source in this project)
   
2. Domain Layer => Which connects the data layer to the presentation layer. Here the repository will call the data layer to get the data and it will convert the data into an entity that represents how the data is stored in the client. The usecase handles one task.
   
3. Presentation Layer => This layer contains the screens in which the UI is sperated from the business logic. The business logic is handled by the Provider which calls a specific use case and once it gets the data notifies the UI wiht state changes.
