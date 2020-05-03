//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public struct CreateProfileInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(age: Int, weight: Int, height: Int, gender: Swift.Optional<Bool?> = nil, goalWeight: Swift.Optional<Int?> = nil, activityLevel: Swift.Optional<Int?> = nil, diet: Swift.Optional<String?> = nil, fat: Swift.Optional<Int?> = nil, carbs: Swift.Optional<Int?> = nil, protein: Swift.Optional<Int?> = nil, fiber: Swift.Optional<Int?> = nil, calories: Swift.Optional<Int?> = nil) {
    graphQLMap = ["age": age, "weight": weight, "height": height, "gender": gender, "goal_weight": goalWeight, "activity_level": activityLevel, "diet": diet, "fat": fat, "carbs": carbs, "protein": protein, "fiber": fiber, "calories": calories]
  }

  public var age: Int {
    get {
      return graphQLMap["age"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "age")
    }
  }

  public var weight: Int {
    get {
      return graphQLMap["weight"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "weight")
    }
  }

  public var height: Int {
    get {
      return graphQLMap["height"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "height")
    }
  }

  public var gender: Swift.Optional<Bool?> {
    get {
      return graphQLMap["gender"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gender")
    }
  }

  public var goalWeight: Swift.Optional<Int?> {
    get {
      return graphQLMap["goal_weight"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "goal_weight")
    }
  }

  public var activityLevel: Swift.Optional<Int?> {
    get {
      return graphQLMap["activity_level"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "activity_level")
    }
  }

  public var diet: Swift.Optional<String?> {
    get {
      return graphQLMap["diet"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "diet")
    }
  }

  public var fat: Swift.Optional<Int?> {
    get {
      return graphQLMap["fat"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fat")
    }
  }

  public var carbs: Swift.Optional<Int?> {
    get {
      return graphQLMap["carbs"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "carbs")
    }
  }

  public var protein: Swift.Optional<Int?> {
    get {
      return graphQLMap["protein"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "protein")
    }
  }

  public var fiber: Swift.Optional<Int?> {
    get {
      return graphQLMap["fiber"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fiber")
    }
  }

  public var calories: Swift.Optional<Int?> {
    get {
      return graphQLMap["calories"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "calories")
    }
  }
}

public struct CreateDailyRecordInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(date: String, calories: Int, fat: Int, carbs: Int, fiber: Int, protein: Int, foodString: String, quantity: Int, mealType: String) {
    graphQLMap = ["date": date, "calories": calories, "fat": fat, "carbs": carbs, "fiber": fiber, "protein": protein, "food_string": foodString, "quantity": quantity, "meal_type": mealType]
  }

  public var date: String {
    get {
      return graphQLMap["date"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "date")
    }
  }

  public var calories: Int {
    get {
      return graphQLMap["calories"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "calories")
    }
  }

  public var fat: Int {
    get {
      return graphQLMap["fat"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fat")
    }
  }

  public var carbs: Int {
    get {
      return graphQLMap["carbs"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "carbs")
    }
  }

  public var fiber: Int {
    get {
      return graphQLMap["fiber"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fiber")
    }
  }

  public var protein: Int {
    get {
      return graphQLMap["protein"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "protein")
    }
  }

  public var foodString: String {
    get {
      return graphQLMap["food_string"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "food_string")
    }
  }

  public var quantity: Int {
    get {
      return graphQLMap["quantity"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "quantity")
    }
  }

  public var mealType: String {
    get {
      return graphQLMap["meal_type"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "meal_type")
    }
  }
}

public struct LoginUserInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(email: String, password: String) {
    graphQLMap = ["email": email, "password": password]
  }

  public var email: String {
    get {
      return graphQLMap["email"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "email")
    }
  }

  public var password: String {
    get {
      return graphQLMap["password"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "password")
    }
  }
}

public struct CreateUserInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(name: String, email: String, password: String) {
    graphQLMap = ["name": name, "email": email, "password": password]
  }

  public var name: String {
    get {
      return graphQLMap["name"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var email: String {
    get {
      return graphQLMap["email"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "email")
    }
  }

  public var password: String {
    get {
      return graphQLMap["password"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "password")
    }
  }
}

public final class CreateProfileMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation CreateProfile($data: CreateProfileInput!) {
      createProfile(data: $data) {
        __typename
        id
        age
        weight
        height
        gender
        goal_weight
        activity_level
        diet
        fat
        carbs
        protein
        fiber
        calories
        updatedAt
        createdAt
      }
    }
    """

  public let operationName = "CreateProfile"

  public var data: CreateProfileInput

  public init(data: CreateProfileInput) {
    self.data = data
  }

  public var variables: GraphQLMap? {
    return ["data": data]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createProfile", arguments: ["data": GraphQLVariable("data")], type: .nonNull(.object(CreateProfile.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createProfile: CreateProfile) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createProfile": createProfile.resultMap])
    }

    public var createProfile: CreateProfile {
      get {
        return CreateProfile(unsafeResultMap: resultMap["createProfile"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "createProfile")
      }
    }

    public struct CreateProfile: GraphQLSelectionSet {
      public static let possibleTypes = ["Profile"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("age", type: .nonNull(.scalar(Int.self))),
        GraphQLField("weight", type: .nonNull(.scalar(Int.self))),
        GraphQLField("height", type: .nonNull(.scalar(Int.self))),
        GraphQLField("gender", type: .scalar(Bool.self)),
        GraphQLField("goal_weight", type: .scalar(Int.self)),
        GraphQLField("activity_level", type: .scalar(Int.self)),
        GraphQLField("diet", type: .scalar(String.self)),
        GraphQLField("fat", type: .scalar(Int.self)),
        GraphQLField("carbs", type: .scalar(Int.self)),
        GraphQLField("protein", type: .scalar(Int.self)),
        GraphQLField("fiber", type: .scalar(Int.self)),
        GraphQLField("calories", type: .scalar(Int.self)),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, age: Int, weight: Int, height: Int, gender: Bool? = nil, goalWeight: Int? = nil, activityLevel: Int? = nil, diet: String? = nil, fat: Int? = nil, carbs: Int? = nil, protein: Int? = nil, fiber: Int? = nil, calories: Int? = nil, updatedAt: String, createdAt: String) {
        self.init(unsafeResultMap: ["__typename": "Profile", "id": id, "age": age, "weight": weight, "height": height, "gender": gender, "goal_weight": goalWeight, "activity_level": activityLevel, "diet": diet, "fat": fat, "carbs": carbs, "protein": protein, "fiber": fiber, "calories": calories, "updatedAt": updatedAt, "createdAt": createdAt])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var age: Int {
        get {
          return resultMap["age"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "age")
        }
      }

      public var weight: Int {
        get {
          return resultMap["weight"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "weight")
        }
      }

      public var height: Int {
        get {
          return resultMap["height"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "height")
        }
      }

      public var gender: Bool? {
        get {
          return resultMap["gender"] as? Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "gender")
        }
      }

      public var goalWeight: Int? {
        get {
          return resultMap["goal_weight"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "goal_weight")
        }
      }

      public var activityLevel: Int? {
        get {
          return resultMap["activity_level"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "activity_level")
        }
      }

      public var diet: String? {
        get {
          return resultMap["diet"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "diet")
        }
      }

      public var fat: Int? {
        get {
          return resultMap["fat"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "fat")
        }
      }

      public var carbs: Int? {
        get {
          return resultMap["carbs"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "carbs")
        }
      }

      public var protein: Int? {
        get {
          return resultMap["protein"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "protein")
        }
      }

      public var fiber: Int? {
        get {
          return resultMap["fiber"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "fiber")
        }
      }

      public var calories: Int? {
        get {
          return resultMap["calories"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "calories")
        }
      }

      public var updatedAt: String {
        get {
          return resultMap["updatedAt"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var createdAt: String {
        get {
          return resultMap["createdAt"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "createdAt")
        }
      }
    }
  }
}

public final class MeQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query Me {
      me {
        __typename
        id
        name
        email
        profile {
          __typename
          id
          age
          weight
          height
          gender
          goal_weight
          activity_level
          diet
          fat
          carbs
          protein
          calories
        }
        favorites {
          __typename
          id
          food_id
          custom
        }
        dailyRecords {
          __typename
          id
          date
          calories
          fat
          carbs
          fiber
          protein
          food_string
          meal_type
        }
        weightLogs {
          __typename
          id
          date
          current_weight
        }
      }
    }
    """

  public let operationName = "Me"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("me", type: .nonNull(.object(Me.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(me: Me) {
      self.init(unsafeResultMap: ["__typename": "Query", "me": me.resultMap])
    }

    public var me: Me {
      get {
        return Me(unsafeResultMap: resultMap["me"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "me")
      }
    }

    public struct Me: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("email", type: .scalar(String.self)),
        GraphQLField("profile", type: .object(Profile.selections)),
        GraphQLField("favorites", type: .list(.nonNull(.object(Favorite.selections)))),
        GraphQLField("dailyRecords", type: .list(.nonNull(.object(DailyRecord.selections)))),
        GraphQLField("weightLogs", type: .list(.nonNull(.object(WeightLog.selections)))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String, email: String? = nil, profile: Profile? = nil, favorites: [Favorite]? = nil, dailyRecords: [DailyRecord]? = nil, weightLogs: [WeightLog]? = nil) {
        self.init(unsafeResultMap: ["__typename": "User", "id": id, "name": name, "email": email, "profile": profile.flatMap { (value: Profile) -> ResultMap in value.resultMap }, "favorites": favorites.flatMap { (value: [Favorite]) -> [ResultMap] in value.map { (value: Favorite) -> ResultMap in value.resultMap } }, "dailyRecords": dailyRecords.flatMap { (value: [DailyRecord]) -> [ResultMap] in value.map { (value: DailyRecord) -> ResultMap in value.resultMap } }, "weightLogs": weightLogs.flatMap { (value: [WeightLog]) -> [ResultMap] in value.map { (value: WeightLog) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var email: String? {
        get {
          return resultMap["email"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "email")
        }
      }

      public var profile: Profile? {
        get {
          return (resultMap["profile"] as? ResultMap).flatMap { Profile(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "profile")
        }
      }

      public var favorites: [Favorite]? {
        get {
          return (resultMap["favorites"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Favorite] in value.map { (value: ResultMap) -> Favorite in Favorite(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Favorite]) -> [ResultMap] in value.map { (value: Favorite) -> ResultMap in value.resultMap } }, forKey: "favorites")
        }
      }

      public var dailyRecords: [DailyRecord]? {
        get {
          return (resultMap["dailyRecords"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [DailyRecord] in value.map { (value: ResultMap) -> DailyRecord in DailyRecord(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [DailyRecord]) -> [ResultMap] in value.map { (value: DailyRecord) -> ResultMap in value.resultMap } }, forKey: "dailyRecords")
        }
      }

      public var weightLogs: [WeightLog]? {
        get {
          return (resultMap["weightLogs"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [WeightLog] in value.map { (value: ResultMap) -> WeightLog in WeightLog(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [WeightLog]) -> [ResultMap] in value.map { (value: WeightLog) -> ResultMap in value.resultMap } }, forKey: "weightLogs")
        }
      }

      public struct Profile: GraphQLSelectionSet {
        public static let possibleTypes = ["Profile"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("age", type: .nonNull(.scalar(Int.self))),
          GraphQLField("weight", type: .nonNull(.scalar(Int.self))),
          GraphQLField("height", type: .nonNull(.scalar(Int.self))),
          GraphQLField("gender", type: .scalar(Bool.self)),
          GraphQLField("goal_weight", type: .scalar(Int.self)),
          GraphQLField("activity_level", type: .scalar(Int.self)),
          GraphQLField("diet", type: .scalar(String.self)),
          GraphQLField("fat", type: .scalar(Int.self)),
          GraphQLField("carbs", type: .scalar(Int.self)),
          GraphQLField("protein", type: .scalar(Int.self)),
          GraphQLField("calories", type: .scalar(Int.self)),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, age: Int, weight: Int, height: Int, gender: Bool? = nil, goalWeight: Int? = nil, activityLevel: Int? = nil, diet: String? = nil, fat: Int? = nil, carbs: Int? = nil, protein: Int? = nil, calories: Int? = nil) {
          self.init(unsafeResultMap: ["__typename": "Profile", "id": id, "age": age, "weight": weight, "height": height, "gender": gender, "goal_weight": goalWeight, "activity_level": activityLevel, "diet": diet, "fat": fat, "carbs": carbs, "protein": protein, "calories": calories])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var age: Int {
          get {
            return resultMap["age"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "age")
          }
        }

        public var weight: Int {
          get {
            return resultMap["weight"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "weight")
          }
        }

        public var height: Int {
          get {
            return resultMap["height"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "height")
          }
        }

        public var gender: Bool? {
          get {
            return resultMap["gender"] as? Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "gender")
          }
        }

        public var goalWeight: Int? {
          get {
            return resultMap["goal_weight"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "goal_weight")
          }
        }

        public var activityLevel: Int? {
          get {
            return resultMap["activity_level"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "activity_level")
          }
        }

        public var diet: String? {
          get {
            return resultMap["diet"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "diet")
          }
        }

        public var fat: Int? {
          get {
            return resultMap["fat"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "fat")
          }
        }

        public var carbs: Int? {
          get {
            return resultMap["carbs"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "carbs")
          }
        }

        public var protein: Int? {
          get {
            return resultMap["protein"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "protein")
          }
        }

        public var calories: Int? {
          get {
            return resultMap["calories"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "calories")
          }
        }
      }

      public struct Favorite: GraphQLSelectionSet {
        public static let possibleTypes = ["FavoriteFood"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("food_id", type: .nonNull(.scalar(String.self))),
          GraphQLField("custom", type: .nonNull(.scalar(Bool.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, foodId: String, custom: Bool) {
          self.init(unsafeResultMap: ["__typename": "FavoriteFood", "id": id, "food_id": foodId, "custom": custom])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var foodId: String {
          get {
            return resultMap["food_id"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "food_id")
          }
        }

        public var custom: Bool {
          get {
            return resultMap["custom"]! as! Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "custom")
          }
        }
      }

      public struct DailyRecord: GraphQLSelectionSet {
        public static let possibleTypes = ["DailyRecord"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("date", type: .nonNull(.scalar(String.self))),
          GraphQLField("calories", type: .nonNull(.scalar(Int.self))),
          GraphQLField("fat", type: .nonNull(.scalar(Int.self))),
          GraphQLField("carbs", type: .nonNull(.scalar(Int.self))),
          GraphQLField("fiber", type: .nonNull(.scalar(Int.self))),
          GraphQLField("protein", type: .nonNull(.scalar(Int.self))),
          GraphQLField("food_string", type: .nonNull(.scalar(String.self))),
          GraphQLField("meal_type", type: .nonNull(.scalar(String.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, date: String, calories: Int, fat: Int, carbs: Int, fiber: Int, protein: Int, foodString: String, mealType: String) {
          self.init(unsafeResultMap: ["__typename": "DailyRecord", "id": id, "date": date, "calories": calories, "fat": fat, "carbs": carbs, "fiber": fiber, "protein": protein, "food_string": foodString, "meal_type": mealType])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var date: String {
          get {
            return resultMap["date"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "date")
          }
        }

        public var calories: Int {
          get {
            return resultMap["calories"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "calories")
          }
        }

        public var fat: Int {
          get {
            return resultMap["fat"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "fat")
          }
        }

        public var carbs: Int {
          get {
            return resultMap["carbs"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "carbs")
          }
        }

        public var fiber: Int {
          get {
            return resultMap["fiber"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "fiber")
          }
        }

        public var protein: Int {
          get {
            return resultMap["protein"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "protein")
          }
        }

        public var foodString: String {
          get {
            return resultMap["food_string"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "food_string")
          }
        }

        public var mealType: String {
          get {
            return resultMap["meal_type"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "meal_type")
          }
        }
      }

      public struct WeightLog: GraphQLSelectionSet {
        public static let possibleTypes = ["WeightLog"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("date", type: .nonNull(.scalar(String.self))),
          GraphQLField("current_weight", type: .nonNull(.scalar(Int.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, date: String, currentWeight: Int) {
          self.init(unsafeResultMap: ["__typename": "WeightLog", "id": id, "date": date, "current_weight": currentWeight])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var date: String {
          get {
            return resultMap["date"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "date")
          }
        }

        public var currentWeight: Int {
          get {
            return resultMap["current_weight"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "current_weight")
          }
        }
      }
    }
  }
}

public final class CreateDailyRecordMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation CreateDailyRecord($data: CreateDailyRecordInput!) {
      createDailyRecord(data: $data) {
        __typename
        id
        date
        calories
        fat
        carbs
        fiber
        protein
        food_string
        quantity
        meal_type
        updatedAt
        createdAt
      }
    }
    """

  public let operationName = "CreateDailyRecord"

  public var data: CreateDailyRecordInput

  public init(data: CreateDailyRecordInput) {
    self.data = data
  }

  public var variables: GraphQLMap? {
    return ["data": data]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createDailyRecord", arguments: ["data": GraphQLVariable("data")], type: .nonNull(.object(CreateDailyRecord.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createDailyRecord: CreateDailyRecord) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createDailyRecord": createDailyRecord.resultMap])
    }

    public var createDailyRecord: CreateDailyRecord {
      get {
        return CreateDailyRecord(unsafeResultMap: resultMap["createDailyRecord"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "createDailyRecord")
      }
    }

    public struct CreateDailyRecord: GraphQLSelectionSet {
      public static let possibleTypes = ["DailyRecord"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("date", type: .nonNull(.scalar(String.self))),
        GraphQLField("calories", type: .nonNull(.scalar(Int.self))),
        GraphQLField("fat", type: .nonNull(.scalar(Int.self))),
        GraphQLField("carbs", type: .nonNull(.scalar(Int.self))),
        GraphQLField("fiber", type: .nonNull(.scalar(Int.self))),
        GraphQLField("protein", type: .nonNull(.scalar(Int.self))),
        GraphQLField("food_string", type: .nonNull(.scalar(String.self))),
        GraphQLField("quantity", type: .nonNull(.scalar(Int.self))),
        GraphQLField("meal_type", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, date: String, calories: Int, fat: Int, carbs: Int, fiber: Int, protein: Int, foodString: String, quantity: Int, mealType: String, updatedAt: String, createdAt: String) {
        self.init(unsafeResultMap: ["__typename": "DailyRecord", "id": id, "date": date, "calories": calories, "fat": fat, "carbs": carbs, "fiber": fiber, "protein": protein, "food_string": foodString, "quantity": quantity, "meal_type": mealType, "updatedAt": updatedAt, "createdAt": createdAt])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var date: String {
        get {
          return resultMap["date"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "date")
        }
      }

      public var calories: Int {
        get {
          return resultMap["calories"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "calories")
        }
      }

      public var fat: Int {
        get {
          return resultMap["fat"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "fat")
        }
      }

      public var carbs: Int {
        get {
          return resultMap["carbs"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "carbs")
        }
      }

      public var fiber: Int {
        get {
          return resultMap["fiber"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "fiber")
        }
      }

      public var protein: Int {
        get {
          return resultMap["protein"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "protein")
        }
      }

      public var foodString: String {
        get {
          return resultMap["food_string"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "food_string")
        }
      }

      public var quantity: Int {
        get {
          return resultMap["quantity"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "quantity")
        }
      }

      public var mealType: String {
        get {
          return resultMap["meal_type"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "meal_type")
        }
      }

      public var updatedAt: String {
        get {
          return resultMap["updatedAt"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var createdAt: String {
        get {
          return resultMap["createdAt"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "createdAt")
        }
      }
    }
  }
}

public final class LoginMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation Login($data: LoginUserInput!) {
      login(data: $data) {
        __typename
        token
        user {
          __typename
          id
          name
          email
          updatedAt
          createdAt
        }
      }
    }
    """

  public let operationName = "Login"

  public var data: LoginUserInput

  public init(data: LoginUserInput) {
    self.data = data
  }

  public var variables: GraphQLMap? {
    return ["data": data]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("login", arguments: ["data": GraphQLVariable("data")], type: .nonNull(.object(Login.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(login: Login) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "login": login.resultMap])
    }

    public var login: Login {
      get {
        return Login(unsafeResultMap: resultMap["login"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "login")
      }
    }

    public struct Login: GraphQLSelectionSet {
      public static let possibleTypes = ["AuthPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("token", type: .nonNull(.scalar(String.self))),
        GraphQLField("user", type: .nonNull(.object(User.selections))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(token: String, user: User) {
        self.init(unsafeResultMap: ["__typename": "AuthPayload", "token": token, "user": user.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var token: String {
        get {
          return resultMap["token"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "token")
        }
      }

      public var user: User {
        get {
          return User(unsafeResultMap: resultMap["user"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "user")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("email", type: .scalar(String.self)),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String, email: String? = nil, updatedAt: String, createdAt: String) {
          self.init(unsafeResultMap: ["__typename": "User", "id": id, "name": name, "email": email, "updatedAt": updatedAt, "createdAt": createdAt])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var email: String? {
          get {
            return resultMap["email"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "email")
          }
        }

        public var updatedAt: String {
          get {
            return resultMap["updatedAt"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var createdAt: String {
          get {
            return resultMap["createdAt"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "createdAt")
          }
        }
      }
    }
  }
}

public final class CreateUserMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation CreateUser($data: CreateUserInput!) {
      createUser(data: $data) {
        __typename
        token
        user {
          __typename
          id
          name
          email
          updatedAt
          createdAt
        }
      }
    }
    """

  public let operationName = "CreateUser"

  public var data: CreateUserInput

  public init(data: CreateUserInput) {
    self.data = data
  }

  public var variables: GraphQLMap? {
    return ["data": data]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createUser", arguments: ["data": GraphQLVariable("data")], type: .nonNull(.object(CreateUser.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createUser: CreateUser) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createUser": createUser.resultMap])
    }

    public var createUser: CreateUser {
      get {
        return CreateUser(unsafeResultMap: resultMap["createUser"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "createUser")
      }
    }

    public struct CreateUser: GraphQLSelectionSet {
      public static let possibleTypes = ["AuthPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("token", type: .nonNull(.scalar(String.self))),
        GraphQLField("user", type: .nonNull(.object(User.selections))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(token: String, user: User) {
        self.init(unsafeResultMap: ["__typename": "AuthPayload", "token": token, "user": user.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var token: String {
        get {
          return resultMap["token"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "token")
        }
      }

      public var user: User {
        get {
          return User(unsafeResultMap: resultMap["user"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "user")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("email", type: .scalar(String.self)),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String, email: String? = nil, updatedAt: String, createdAt: String) {
          self.init(unsafeResultMap: ["__typename": "User", "id": id, "name": name, "email": email, "updatedAt": updatedAt, "createdAt": createdAt])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var email: String? {
          get {
            return resultMap["email"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "email")
          }
        }

        public var updatedAt: String {
          get {
            return resultMap["updatedAt"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var createdAt: String {
          get {
            return resultMap["createdAt"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "createdAt")
          }
        }
      }
    }
  }
}
