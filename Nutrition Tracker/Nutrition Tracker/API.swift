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
