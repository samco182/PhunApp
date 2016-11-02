# Phunware-iOS-Homework

Interview Homework Project (iOS)
---------------------------------

## Features

- [x] The application performs the necessary network calls to consume the provided JSON feed.
- [x] The application displays the feed in a master/detail fashion.
- [x] The application posseses a scrollable view to view all events, when tapped leads to a detail view.
- [x] The schedule times are represented in the user's timezone
- [x] While viewing an event, a user can share the event, an record it in the Remainders app
- [x] The application runs on iPhone and iPad on all orientations
- [x] The application persists the data fetched from the JSON feed, so it can function without network connection.
- BONUS
- [x] The application implements Core Spotlight Integration
- [x] The application implements Deep Linking

## Classes

- `PHADataFetcher`: this class is in charge of fetching the data from the provided JSON feed and converts the obtained dictionaries into `PHAEvent` objects, which are stored into a `PHAEventList` instance.
- `PHAEvent`: this class is in charge of mapping the keys of a dictionary obtained from the JSON feed into properties of an object type `PHAEvent`. This class inherits from the `MTLModel` class and has a contract with the `<MTLJSONSerializing>` delegate.
- `PHAEventList`: this class is in charge of storing in a `NSArray` all the `PHAEvent` objects converted from the dictionaries of the JSON feed. This class inherits from the `MTLModel` class and has a contract with the `<MTLJSONSerializing>` delegate.
- `PHAEventStoring`: this class is in charge of the persistance of the data stored in the `PHAEvent` objects. This class inherits from the `RLMObject` class.
- `PHASpotlightHelper`: this class is in charge of implementing the methods from `<MobileCoreServices/MobileCoreServices.h>` to allow Core Spotlight Integration.

## Pods Libraries Used
- AFNetworking
- Mantle
- Realm
- SDWebImage

#### Pods libraries included

