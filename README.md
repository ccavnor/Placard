[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fccavnor%2FPlacard%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/ccavnor/Placard)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fccavnor%2FPlacard%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/ccavnor/Placard)


<img src="https://github.com/user-attachments/assets/db1c4f28-a737-45c0-907b-17b899c8e896" alt="Placard logo" style="width:150px;height:150px;">

# ``Placard``

Placard is a small and easy to use package for presenting an animated message bar using SwiftUI.

Message views can be displayed at the top, bottom, or center of the screen and can be offset from both the screen edges and the vertical placements using UIEdgeInsets.

There are interactive show, tap, and dismiss gestures - an array of animated themes to choose from (or no animation if you want).

Placard allows you to choose default message themes for things such as priority-based messages, but also offers customization via either parameters, a configuration object, or you can use your own SwiftUI view and let Placard control its animations and appearance. The Placard can be configured to display for any period of time (by default, it displays forever - or until a user taps on it). Further, all Placard messages can given an action to perform on user tap (but not if Placard dismisses itself via a timeout).

Placards automatically redraw themselves, adapting to device orientation changes:

<img src="https://github.com/user-attachments/assets/b0263f2a-16e1-4e46-9292-629a8b54e7ac" style="width:174px;height:250px;">

<img src="https://github.com/user-attachments/assets/f0f85ad1-42c0-4e27-ac43-e5e0bbc44872" style="width:174px;height:250px;">

<img src="https://github.com/user-attachments/assets/bc967078-d089-4219-bdd2-4de34435d8db" style="width:174px;height:250px;">

## Requirements
Placard is built and tested for iOS 17.2 and onward only. 

## Running Placard via the PlacardDemo project

The [PlacardDemo app](https://github.com/ccavnor/PlacardDemo) allows you to explore Placard, both the default options and by changing the configuration:

Download the zip of this repository and extract it. 
Run PlacardDemo.xcodeproj and choose either iphone or ipad as targets for the simulator (see Requirements section for required xcode builds).

The images of Placard in this documentation were all taken as screen grabs from the PlacardDemo project.

## Installation of Placard

To play with Placard via the demo interface, see the section above. But if you want to use Placard in your own projects, download Placard
either via the Swift Package Manager or manually:

### Using Swift Package Manager:

Go to File | Swift Packages | Add Package Dependency... in Xcode and search for "Placard".

### From the Swift Package Index:

Get Placard from the [Swift Package Index](https://swiftpackageindex.com/ccavnor/Placard)

## Usage
Using Placard is straight forward, but it helps to know that Placard is composed of three views that you can use:

1) [PlacardPriorityView](#ppv): a simple, built-in way to display status messages based on priorities.
2) [PlacardView](#pv): Another built-in type, but more configurable than PlacardPriorityView and without priorities.
3) [PlacardCustomView](#pcv): Placard will take your SwiftUI view and display it as a Placard!

### Configuration

Placard types take a configuration of type PlacardConfig that you can use to alter the behavior, placement, and formatting of a Placard view. A configuration is not necessary, but allows you to customize your Placards.

The protocol for a Placard configuration is PlacardConfigP:

```swift
public protocol PlacardConfigP {
    var backgroundColor: UIColor? { get }
    var primaryFont: UIFont? { get }
    var secondaryFont: UIFont? { get }
    var accentColor: UIColor? { get }
    var titleTextColor: UIColor? { get }
    var placement: PlacardPlacement? { get }
    var insets: UIEdgeInsets? { get }
    var showAnimation: TransitionAnimation? { get }
    var hideAnimation: TransitionAnimation? { get }
    var tapAnimation: TapAnimation? { get }
    var fadeAnimation: Bool? { get }
}
```
Here is a description of those properties:

| Configuration Property | Description |
| :------------------- | :---------- |
| backgroundColor      | Background color (as a UIColor) for the Placard view |
| primaryFont          | The font for the title      |
| secondaryFont        | The font for the status message      |
| accentColor          | Accent color (as a UIColor) for the Placard view (used for the status message foreground)  |
| titleTextColor       | Color (as a UIColor) used for the Placard view title and systemImage foreground colors      |
| placement            | Where to position the Placard view on the device screen      |
| insets               | UIEdgeInsets used to offset a Placard view from its PlacardPlacement      |
| showAnimation        | The animation to be used when the Placard view appears      |
| hideAnimation        | The animation to be used when the Placard view disappears      |
| tapAnimation         | The animation to be used when the Placard view is tapped by the user      |
| fadeAnimation        | When true, the show and hide animations will fade in or out, respectively      |

In the example below, all available configuration options are being set:
        
```swift                
let config = PlacardConfig(backgroundColor: .darkGray,
                            primaryFont: UIFont.systemFont(ofSize: 30.0, weight: .heavy),
                            secondaryFont: UIFont.systemFont(ofSize: 16.0, weight: .regular),
                            accentColor: .red,
                            titleTextColor: .yellow,
                            placement: .top,
                            insets: UIEdgeInsets(top: 50, left: 20, bottom: 0, right: 20),
                            showAnimation: .spin,
                            hideAnimation: .fade,
                            tapAnimation: .pulseIn,
                            fadeAnimation: true)
```

Two of these properties, Insets and Animations, require a bit more elaboration:

#### Insets

UIEdgeInsets used to offset a Placard view from its PlacardPlacement. Keep in mind that
UIEdgeInsets.left and UIEdgeInsets.right act to "push" the Placard view away from the edges
of the device screen (allowing the user to create a Placard that does not span the screen). Also,
all values should be positive offsets - a value for UIEdgeInsets.top of 50 will push a Placard view
50 points from the top of the device (regardless of its orientation).  A value for UIEdgeInsets.bottom
of 50 will push a Placard view 50 points from the bottom of the device (toward the center).

    Note that for:
    - PlacardPlacement.top - UIEdgeInsets.bottom is ignored
    - PlacardPlacement.bottom - UIEdgeInsets.top is ignored

#### Animations

##### Transition Animations
These are the types of the animated transitions that occur on show and hide of placard. The available options are:

```swift 
public enum TransitionAnimation {
    case none, fade, rollUp, rollDown, floatUp, floatDown, floatLeft, floatRight, toX, toY, toPoint, spin, spinOnX, spinOnY
}
```
###### Examples of transition animations
<img src="https://github.com/user-attachments/assets/3da9b353-bd90-49f9-a02d-d3c5184882ea" style="width:174px;height:250px;">
<img src="https://github.com/user-attachments/assets/bd9469c7-b026-42f6-b234-1b8507d3ea4d" style="width:174px;height:250px;">
<img src="https://github.com/user-attachments/assets/f027156f-cb07-4e78-95fa-caf757b07d18" style="width:174px;height:250px;">
<img src="https://github.com/user-attachments/assets/7f6daa82-2751-4c4e-ab02-ab4e91be630f" style="width:174px;height:250px;">
<img src="https://github.com/user-attachments/assets/c1f4405e-e504-41b9-8b73-770688a0ad54" style="width:174px;height:250px;">
<img src="https://github.com/user-attachments/assets/a23a2131-1236-4791-9693-519b7b09dbf7" style="width:174px;height:250px;">
<img src="https://github.com/user-attachments/assets/e32c2e19-3796-4455-8a32-3b66de155baa" style="width:174px;height:250px;">
<img src="https://github.com/user-attachments/assets/701e490c-b1f4-466d-a055-067c2c5bf4b1" style="width:174px;height:250px;">

##### Tap Animations
These are the animations that occur when a user taps on placard (follow by action completion and dismissal of the Placard).
The available options are:

```swift 
public enum TapAnimation {
    case none, pulseIn, pulseOut, zoomInWithEasing, zoomOutWithEasing
}
```
###### Examples of tap animations
Its a bit difficult to see the differences via animated gifs, but play with the PlacardDemo app to see these more clearly.

Zoom out, ease in:

<img src="https://github.com/user-attachments/assets/204a334f-3924-4695-8e41-445da8edbd26" style="width:174px;height:250px;">

Zoom in, ease out:

<img src="https://github.com/user-attachments/assets/d0a8f1f5-1640-4240-8ff0-0a952e3e8114" style="width:174px;height:250px;">

Pulse out:

<img src="https://github.com/user-attachments/assets/78095436-7c7d-4c30-b1a7-3da787233366" style="width:174px;height:250px;">

Pulse in:

<img src="https://github.com/user-attachments/assets/747c96e2-8cca-4750-8e35-7bfa72018947" style="width:174px;height:250px;">

***

Another way to use a configuration - use an enumeration. This is basically the same as using a PlacardConfig instance, but you can define a configuration type (conforming to PlacardConfigP) and pass that in instead.

```swift
    enum Custom: PlacardConfigP {
        // the type we are defining
        case terminal

        var backgroundColor: UIColor? {
            switch self { case .terminal: return .lightGray }
        }

        var accentColor: UIColor? {
            switch self {
            case .terminal: return .purple
            }
        }

        var primaryFont: UIFont? {
            switch self {
            case .terminal: return UIFont(name: "HelveticaNeue-Light", size: 24.0)
            }
        }

        var secondaryFont: UIFont? {
            switch self {
            case .terminal: return UIFont(name: "HelveticaNeue-Light", size: 16.0)
            }
        }

        var titleTextColor: UIColor? {
            switch self { case .terminal: return .green }
        }

        var placement: PlacardPlacement? {
            switch self { default: return .center }
        }

        var insets: UIEdgeInsets? {
            switch self { default: return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) }
        }

        var showAnimation: TransitionAnimation? {
            switch self { default: return .spinOnX }
        }

        var hideAnimation: TransitionAnimation? {
            switch self { default: return .spinOnY }
        }

        var tapAnimation: TapAnimation? {
            switch self { default: return .zoomOutWithEasing }
        }

        var fadeAnimation: Bool? {
            switch self { default: return true }
        }
    }
```
                        
It would be used like this:

```swift
    PlacardView(
        title: "You Dawg!",
        statusMessage: "Git that squeaky!",
        systemImageName: "pawprint",
        config: Custom.terminal
    )
```
***

<a name="ppv" />

### PlacardPriorityView 

PlacardPriorityView types are built-in Placards that are intended to be used for priority-based user status messages. 
You can alter the tile and body of the message, as well as the image via PlacardPriorityView's parameters. You can also pass in your own configuration to change a bunch more (see the configuration section above). But these are meant to be quick and easy representations of status. 

You can alter any of the following parameters, but only title and statusMessage are required. 

| Parameter          | Type             | Description |
| :----------------: | :-------------- | :---------- |
| title              | String           | Title of the Placard              |
| statusMessage      | String           | Status message of the Placard              |
| systemImageName    | String           | Name of the system image (SF Symbol) to use as an icon  |
| config             | PlacardConfig    | A configuration file (see the section above)    |
| duration           | Double           | Number of seconds for the Placard to display       |
| action             | () -> Void       | An action to execute on Placard being tapped by user       |
| priority           | PlacardPriority  | .success, .info, .warning, .error, or a .default priority  |


Here, we create a success message with our own title and status message:

```swift
PlacardPriorityView(title: "Success!", 
                    statusMessage: "Some status message", 
                    priority: .success)
```
<a name="pv" />

<img src="https://github.com/user-attachments/assets/40b79649-cb9f-4fde-9e8e-fb49976e8edc" style="width:174px;height:250px;">

### PlacardView

The PlacardView type is similar to the PlacardPriorityView type, but has no priority associated with it. It can be customized in the same ways.

Its available set of parameters is:
| Parameter          | Type             | Description |
| :----------------: | :-------------- | :---------- |
| title              | String           | Title of the Placard              |
| statusMessage      | String           | Status message of the Placard              |
| systemImageName    | String           | Name of the system image (SF Symbol) to use as an icon  |
| config             | PlacardConfig    | A configuration file (see the section above)    |
| duration           | Double           | Number of seconds for the Placard to display       |
| action             | () -> Void       | An action to execute on Placard being tapped by user       |

Here, we pass in our own systemImage to display:

```swift
    PlacardView(title: "Don't forget to smile!",
                statusMessage: "Teeth are like bats that hang from your gums.",
                systemImageName: "mouth.fill")
```

Placards take an action (of type () -> Void) to perform when tapped (ONLY if tapped - if you set a duration and the Placard expires before a user taps it, the action will not be fired).

```swift
PlacardView(title: "Don't forget to smile!",
            statusMessage: "Teeth are like bats that hang from your gums.",
            systemImageName: "face.smiling",
            action: { print("You tapped me!") })
```

<img src="https://github.com/user-attachments/assets/bff456d4-44a2-4acf-96e7-487f530da2b1" style="width:174px;height:250px;">

<a name="pcv" />

### PlacardCustomView

When you want to provide your own SwiftUI views while using Placard's functionality, you will use the PlacardCustomView.

The set of available parameters for a PlacardCustomView is:
| Parameter          | Type             | Description |
| :----------------: | :-------------- | :---------- |
| title              | String           | Title of the Placard              |
| statusMessage      | String           | Status message of the Placard              |
| content            | UIView           | Your SwiftUI view  |
| config             | PlacardConfig    | A configuration file (see the section above)    |
| duration           | Double           | Number of seconds for the Placard to display       |
| action             | () -> Void       | An action to execute on Placard being tapped by user       |

Define your own SwiftUI view to use as a Placard. Here is an example:
   
```swift   
    struct ViewWithButton: View {
        @State var action: Bool

        var body: some View {
            var color: String {
                if action { return "red" }
                return "green"
            }

            VStack {
                Text("Make me see \\(color)")
                    .background(action ? .green : .red)
                Button(action: {
                    action.toggle()
                }) {
                    HStack {
                        Image(systemName: "face.dashed")
                            .font(.title)
                            .foregroundColor(action ? .green : .red)
                        Text("change me")
                            .fontWeight(.semibold)
                            .font(.title)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.black)
                    .cornerRadius(40)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 200, alignment: .center)
            .background(Color(red: 155/255, green: 198/255, blue: 222/255))
        }
    }
```                        
Pass that view into a PlacardCustomView instance:

```swift
    PlacardCustomView(title: "some title", statusMessage: "some body", config: custom_config) {
        // SwiftUI view
        ViewWithButton(action: toggle)
    }
```

<img src="https://github.com/user-attachments/assets/5781fdde-a99c-41c4-8094-021db5cb560c" style="width:174px;height:250px;">

