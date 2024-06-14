<div align="center">
    <img src="https://github.com/Damagucci-Juice/BeMyFriend/assets/50472122/76734aeb-68f7-4c8c-aaf5-8761275d5b9b" width="20%">
    <img src="https://github.com/Damagucci-Juice/BeMyFriend/assets/50472122/1d3c4e71-f370-462f-a8e6-a34c13f6b0d1" width="60%">
</a>
</div>

# BeMyFamily
An application that uses the Ministry of Health and Welfare's stray animal tracking API to notify users of stray animal outbreaks

## Screenshots

| Initial page | Unlimited scrolling | Detail page |
|---|---|---|
|<img src="https://github.com/Damagucci-Juice/BeMyFriend/assets/50472122/c38ac7e2-8b29-4262-9d2b-b1714db7038f" width="100%">|<img src="https://github.com/Damagucci-Juice/BeMyFriend/assets/50472122/54a6f99e-c04a-4d5d-937f-e51736f57742" width="100%">|<img src="https://github.com/Damagucci-Juice/BeMyFriend/assets/50472122/df0e3357-9802-4455-9476-b4a27ce6ba6a" width="100%">|

| Favorite page | Fetching by Multi kind | Filtering Detail infomations |
|---|---|---|
|<img src="https://github.com/Damagucci-Juice/BeMyFriend/assets/50472122/8c96db24-f971-4011-a781-2e76ccc0904d" width="100%">|<img src="https://github.com/Damagucci-Juice/BeMyFriend/assets/50472122/188cb5c3-0f32-44a5-86d5-5201e3456dfe" width="100%">|<img src="https://github.com/Damagucci-Juice/BeMyFriend/assets/50472122/e4ce4d4a-47fb-4fc6-ba81-d78c408df4af" width="100%">|



## Features
- Filter Animal by State, county, shelter, livestock and breed
- Favorte Animal
- Unlimited scrolling

## API
<img width="978" alt="image" src="https://github.com/Damagucci-Juice/BeMyFriend/assets/50472122/dfc75e72-109f-417b-99ef-25ad3303de4a">

[Stray Animal Information Lookup Service](https://www.data.go.kr/data/15098931/openapi.do)

## Architecture
`Layered architecture`, `MVVM(Model-View-ViewModel)` is used in this project.
<img width="867" alt="image" src="https://github.com/Damagucci-Juice/BeMyFriend/assets/50472122/c34af3bc-cb79-43c9-8747-8785f3bed8cb">

## Folder Structure
```
BEMYFAMILY/
├── APP/
│   ├── Shared/
│   │   ├── Resource/
│   │   │   ├── Info.plist
│   │   │   ├── PrivacyInfo.xcprivacy
│   │   │   └── Launch Screen
│   │   └── Source/
│   │       ├── Scene/
│   │       │   ├── BeMyFamilyApp
│   │       │   └── ContentView
│   │       ├── Core/
│   │       │   ├── UIConstants
│   │       │   └── DIContainer
│   │       ├── Model/
│   │       │   ├── Animal/
│   │       │   │   └── AnimalSub/
│   │       │   │       ├── Kind
│   │       │   │       ├── Upkind
│   │       │   │       ├── Neutralization
│   │       │   │       ├── SexCd
│   │       │   │       └── ProcessState
│   │       │   ├── Sido
│   │       │   ├── Sigungu
│   │       │   ├── Shelter
│   │       │   ├── Kind
│   │       │   └── Upkind
│   │       └── Extension/
│   │           ├── Data+extension
│   │           └── Font+extension
│   └── Features/
│       ├── Share/
│       │   └── Source/
│       │       ├── Utils/
│       │       │   └── Sharable
│       │       └── Scene/
│       │           └── CardNewsView
│       ├── Filter/
│       │   └── Source/
│       │       ├── Reducer/
│       │       │   └── FilterReducer
│       │       ├── Model/
│       │       │   └── AnimalFilter
│       │       └── Scene/
│       │           └── AninmalFilterForm
│       ├── Feed/
│       │   └── Source/
│       │       ├── Reducer/
│       │       │   ├── FeedListReducer
│       │       │   └── ProvinceReducer
│       │       └── Scene/
│       │           ├── FeedView
│       │           └── Sub/
│       │               ├── FeedItemView
│       │               ├── AnimalDetailView
│       │               ├── LikeButton
│       │               └── ShareButton
│       ├── Home/
│       │   └── Source/
│       │       ├── Core/
│       │       │   └── FriendMenu
│       │       └── Scene/
│       │           └── TabControlView
│       └── Network/
│           └── Source/
│               ├── Mocks/
│               │   ├── Animal.json
│               │   ├── Sido.json
│               │   ├── Sigungu.json
│               │   ├── EmptyAnimal.json
│               │   ├── Kind.json
│               │   ├── Shelter.json
│               │   ├── EmptyShelter.json
│               │   └── ModelData
│               ├── Response/
│               │   ├── PaginatedAPIResponse
│               │   ├── PaginatedResponse
│               │   ├── APIResponse
│               │   └── Response
│               ├── Services/
│               │   ├── Test/
│               │   │   └── TestFamilyService
│               │   ├── FamilyService
│               │   ├── FamilyEndpoint
│               │   └── FamilyEndpoint+extension
│               └── Core/
│                   ├── Actions
│                   ├── CacheEntryObject
│                   ├── NSCache+Subscript
│                   └── Constants
└── TEST
```
