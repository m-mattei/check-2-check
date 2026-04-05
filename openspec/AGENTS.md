# Project Instructions

## 📚 Documentation Center
Critical project knowledge is now centralized in the **[Documentation Center](file:///Users/michaelmattei/projects/check2check-stack/check-2-check/docs/src/content/docs/index.md)**.
All agents MUST consult the docs before proposing architectural changes.

## 🛠 Rigid Agent Rules
1. **ALWAYS use OpenSpec**: Track all changes in `openspec/`.
2. **ALWAYS document changes and organize properly**: Synthesize spec data into the `docs/` folder.
3. **ALWAYS consider refactoring docs at scale**: Prevent documentation rot by consolidating features.
4. **ALWAYS add a feature flag**: No feature without a toggle in Dev Mode.
5. **ALWAYS update spec files after changes**: Ensure master specs match implementation after archival.


#
##
### Author: 
#### Michael Mattei
### 
##
#


# Overview

Check-2-Check is a Flutter application that allows users to create and manage their budget. It is a cross-platform application that is available on iOS, Android, and Web. It is a free and open-source application that is designed for users living check to check. It is a simple and easy to use application that is designed to help users save money and stay on top of their finances. The part that stands out is the ability to map their planning around future paychecks. 



# Tech Stack

## Framework
### Language
- Dart
### UI
- Flutter

## Backend
### Language
- Java
### Database
- DynamoDB
### Cloud
- AWS


### Overall Look and Feel
- Clean and modern
- Easy to navigate
- Visually appealing
- Professional
- Calendar based
- Apple pencil focused modes
    - This mode is for users who prefer to write their budget down on paper. 
    - This look can look more like a notebook or planner. AI should be used to parse the handwriting and convert it into a digital format.
- Multiple UI themes/looks, such as a notebook/planner look, a digital look, 
calendar look, mobile app look, etc.

## Design
### Color Palette
- Customizable
### UI
- Material Design
### Animations
- Smooth and subtle

# Project Structure

```
check-2-check/
├── lib/
│   ├── main.dart
│   ├── models/
│   ├── services/
│   ├── screens/
│   ├── widgets/
│   └── utils/
├── android/
├── ios/
├── web/
└── pubspec.yaml
```
