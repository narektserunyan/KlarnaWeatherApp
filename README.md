# Klarna Weather App

The project was created using the MVVM architectural design pattern, with data transfer handled using Combine. It also supports Dark mode and adheres to SOLID principles.

It displays the current location's city name, temperatures in Celsius and Kelvin, weather conditions, and the temperature it feels like. In the upper left corner, users can find a "reset to current location" button, and in the upper right corner, there are search city buttons. When entering the search city page, users can type the city name and apply it to the default city page by pressing "set as Default."

The application uses OpenWeatherMap as its source of information through public APIs.

On the master branch, it uses views with constraints (it's a Storyboard project, but I'm not using storyboards) because I thought in SwiftUI it would be much easier to demonstrate, but with nothing to review, actually. However, I plan to create a SwiftUI branch to develop it using SwiftUI for view creation.

The application's requirements are too small to warrant the use of any third-party frameworks like Alamofire for networking, ReachabilitySwift for internet connection issues, or Cocoapods for package management. So, I decided to keep it simple and adhere to the KISS principle.

During development, I aimed to maintain a clean and aesthetically pleasing codebase without overusing design patterns and techniques. The application includes Unit Testing that covers the Networking layer and ViewModels with FakeNetworkApi and FakeLocationService. All ViewModels handle the business logic.

I moved the APIKey into a plist file and added it to the gitignore for security purposes. To get started smoothly, create an "APIKey.plist" file in the project directory and store the "APIKey" key with the corresponding value.

The application could have been implemented using async/await, delegation, and completion blocks, but I found it interesting to work with Combine and prepare myself for using RXSwift in the future. Along the way, I also used Observer, Template Method, State, Prototype, Adapter, and Builder design patterns. I tried to avoid using Singleton and static methods because they usually make testing harder (though not impossible).

The application could also have been written with MVC, but as a personal preference, I always go with MVVM or VIPER. 
VIPER would be an overkill for this task, although I plan to add a Router in the next commits. I'm also planning to start updating cell data via the model and think about improving data transfer between controllers as well as establishing better bindings between views and viewmodels if possible. In the view part, I'm going to think about creating some generic components to reduce the amount of boilerplate code in view classes for initializing UI components.Perhaps a more elegant approach to error handling could also be introduced.

The task is always interesting to me to do if I can learn something in the process, so I consider it engaging. I've spent 2 days (weekends) on the task, but I plan to add some more enhancements. Feel free to let me know if you think I should stop at any point

Thanks
