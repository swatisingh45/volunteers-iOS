//
//  UserModel.swift
//  VOLA
//
//  Created by Connie Nguyen on 6/3/17.
//  Copyright © 2017 Systers-Opensource. All rights reserved.
//

import Foundation
import RealmSwift
import FirebaseAuth

/**
    Track how the user logged in, by social network or manually
*/
enum UserType: String {
    case facebook
    case google
    case manual
}

/// Model for User data
class User: Object {

    dynamic var name: String = ""
    dynamic var email: String = ""
    dynamic var userTypeRaw: String = ""
    dynamic var imageURLString: String = ""
    // Computed values since their types are unsupported by Realm
    var userType: UserType {
        // If userTypeRaw is not specified, return .manual as default value
        return UserType(rawValue: userTypeRaw) ?? .manual
    }
    var imageURL: URL? {
        return URL(string: imageURLString)
    }

    /// Primary key for Realm object so that it can up updated in data store
    override static func primaryKey() -> String? {
        return "email"
    }

    /**
    Initializer for a customized User, such as from manual login or for mocking purposes
     
    - Parameters:
        - name: Full name of user
        - email: Email address of user
        - userType: Method that user logged in
    */
    convenience init(name: String, email: String, userType: UserType) {
        self.init()
        self.name = name
        self.email = email
        self.userTypeRaw = userType.rawValue
    }

    /**
    Initializer for User from logging in through Google
     
    - Parameters:
        - googleUser: GIDGoogleUser object to extract user details from (e.g. name, email)
    */
    convenience init(googleUser: GIDGoogleUser) {
        self.init()
        name = googleUser.profile.name
        email = googleUser.profile.email
        userTypeRaw = UserType.google.rawValue
        imageURLString = googleUser.profile.imageURL(withDimension: UserNumbers.twiceImageIcon.rawValue).absoluteString
    }

    /**
    Initializer for User from logging in through Facebook
     
    - Parameters:
        - fbResponse: Response from Facebook Graph API request for user data
    */
    convenience init(fbResponse: [String: Any]) {
        self.init()
        name = fbResponse["name"] as? String ?? ""
        email = fbResponse["email"] as? String ?? ""
        userTypeRaw = UserType.facebook.rawValue

        guard let fbID = fbResponse["id"] as? String else {
                Logger.error("Could not format Facebook user imageURL.")
                return
        }
        imageURLString = String(format: FBRequest.imageURLFormat, fbID)
    }

    /**
    Initializer for User from manual login via Firebase
     
    - Parameters:
        - firebaseUser: FIRUser object response from Firebase API
    */
    convenience init(firebaseUser: FIRUser) {
        self.init()
        name = firebaseUser.displayName ?? ""
        email = firebaseUser.email ?? ""
        userTypeRaw = UserType.manual.rawValue
        imageURLString = firebaseUser.photoURL?.absoluteString ?? ""
    }
}
