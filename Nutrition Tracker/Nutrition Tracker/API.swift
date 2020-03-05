//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

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
