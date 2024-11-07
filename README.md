# Fetch Challenge

## Task Overview

Build an iOS app that allows users to browse and view details about recipes using a provided API

The app should:

- Fetch a list of meals from the 'Dessert' category
- Display the meals in a list sorted alphabetically
- Show detailed information for selected meals including name, instructions, ingredients/measurements

## Implementation

The project was structured following the **MVVM (Model-View-ViewModel)** design pattern, adhering to **SOLID** principles, and employing **Test-Driven Development (TDD)** throughout the process. Below is a breakdown of the project’s structure and the key decisions made during implementation.

This project was tackled with scalability and robostness in mind.

**Project Structure**

The Xcode project was divided into the following main areas:

- **Networking**

- **Models**

- **ViewModels**

- **Views**

### Data Modeling

Before diving into the implementation, I explored the API endpoints using Postman to understand the structure of the data. Based on the API responses, I designed the data models that the JSON responses would be parsed into.

**Key considerations:**

- Ensured the id and name fields are present in each meal.

- Designed models to handle optional data, particularly for ingredients, instructions and thumbnails.

### Networking

To ensure scalability, modularity, and ease of testing, I created a robust networking layer composed of three components:

- **Session:** This handles the low-level network requests, abstracted in a protocol to allow easy mocking during tests.

- **Network:** Defines the methods for retrieving data, including building URLs and decoding responses.

- **NetworkProvider:** Implements the Network protocol, coordinating high-level API requests and executing them via the session.Talk about **concurrency** here

**Concurrency**

The networking layer leverages Swift’s **async/await** for handling asynchronous operations, ensuring smooth and efficient data fetching without blocking the main thread.

### View Models

I developed two ViewModels, each corresponding to a view in the app:

- **MealsViewModel:** Manages the list of meals, handling the fetching, filtering, and sorting of data.

- **MealDetailViewModel:** Manages the details of a single meal, handling the fetching of detailed information and updating the view accordingly.

These ViewModels maintain a clean separation of concerns, ensuring that business logic is encapsulated and reusable.

### Views

The app consists of two main views:

- **MealsView:** Displays the list of meals. It uses NavigationLink to navigate to the meal detail view.

- **MealDetailView:** Provides detailed information about a selected meal, including a list of ingredients and preparation instructions.

Both views are designed following Apple’s Human Interface Guidelines, with a focus on simplicity, compartmentalization, and reusable components.

### Refinement and Error Handling

**Handling Null Values**

To robustly handle potential null values during the decoding process, I adopted a defensive approach. Fields like id and name, essential for identifying and displaying meals, are validated during decoding. Meals lacking these critical fields are filtered out to prevent incomplete data from affecting the user experience. For ingredients and other optional fields, I ensured that only valid, non-null data is passed through, safeguarding the integrity of the information displayed to users.

**Componentization**

I further refined the views by breaking them into smaller, reusable components. For example, the image loading logic was encapsulated in a custom AsyncImage component that handles loading states and errors gracefully.

### Testing

I wrote unit tests to cover both the networking layer and the decoding logic:

- **Networking Tests:** Mock sessions were used to simulate API responses, testing both success and failure cases.

- **Decoding Tests:** Ensured that models correctly handled different edge cases, such as missing or malformed data.

## Requirements

This project was developed using Xcode 15.4 and tested on an iPhone 15 Pro running iOS 17.5. I also have a version developed in Xcode 16.1 beta 3 and tested on iPhone 15 Pro running iOS 18.1 beta 3. That version supports Swift 6 syntax and Swift Testing framework.
