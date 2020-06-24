//
//  UsersStorage.swift
//  FirstCourseFinalTask
//
//  Created by Олеся on 15.06.2020.
//  Copyright © 2020 E-Legion. All rights reserved.
//

import Foundation
import FirstCourseFinalTaskChecker

final class UsersStorage: UsersStorageProtocol {
    
    let users: [UserInitialData]
    var followers: [(User.Identifier, User.Identifier)]
    var count: Int { users.count }
    
    private let currentUserID: User.Identifier
    private let currentUserData: UserInitialData
    
    required init?(users: [UserInitialData], followers: [(GenericIdentifier<UserProtocol>, GenericIdentifier<UserProtocol>)], currentUserID: GenericIdentifier<UserProtocol>) {
        guard let currentUserData = users.first(where: { $0.id == currentUserID }) else { return nil }
        
        self.currentUserData = currentUserData
        self.users = users
        self.followers = followers
        self.currentUserID = currentUserID
    }
    
    func currentUser() -> UserProtocol {
        return User(
            id: currentUserID,
            username: currentUserData.username,
            fullName: currentUserData.fullName,
            avatarURL: currentUserData.avatarURL,
            currentUserFollowsThisUser: isCurrentUserFollowsThisUser(currentUserID),
            currentUserIsFollowedByThisUser: isCurrentUserIsFollowedByThisUser(currentUserID),
            followsCount: numberOfFollows(currentUserID),
            followedByCount: numberOfFollowers(currentUserID)
        )
    }
    
    func user(with userID: GenericIdentifier<UserProtocol>) -> UserProtocol? {
        guard let user = users.first(where: { $0.id == userID } ) else { return nil }
        
        return User(
            id: userID,
            username: user.username,
            fullName: user.fullName,
            avatarURL: user.avatarURL,
            currentUserFollowsThisUser: isCurrentUserFollowsThisUser(userID),
            currentUserIsFollowedByThisUser: isCurrentUserIsFollowedByThisUser(userID),
            followsCount: numberOfFollows(userID),
            followedByCount: numberOfFollowers(userID))
    }
    
    func findUsers(by searchString: String) -> [UserProtocol] {
        let request = searchString.lowercased()
        
        return users
            .filter { $0.username.contains(request) ||
                $0.fullName.contains(request)
        }
        .compactMap { user(with: $0.id) }
    }
    
    func follow(_ userIDToFollow: GenericIdentifier<UserProtocol>) -> Bool {
        guard isUserExist(userIDToFollow) else { return false }
        
        followers.append((currentUserID, userIDToFollow))
        return true
    }
    
    func unfollow(_ userIDToUnfollow: GenericIdentifier<UserProtocol>) -> Bool {
        guard isUserExist(userIDToUnfollow) else { return false }
        
        followers.removeAll(where: { $0.0 == currentUserID && $0.1 == userIDToUnfollow })
        return true
    }
    
    func usersFollowingUser(with userID: GenericIdentifier<UserProtocol>) -> [UserProtocol]? {
        guard isUserExist(userID) else { return nil }
        
        return followers
            .filter { $0.1 == userID }
            .compactMap { user(with: $0.0) }
    }
    
    func usersFollowedByUser(with userID: GenericIdentifier<UserProtocol>) -> [UserProtocol]? {
        guard isUserExist(userID) else { return nil }
        
        return followers
            .filter { $0.0 == userID }
            .compactMap { user(with: $0.1) }
    }
}

extension UsersStorage {
    
    func isUserExist(_ userID: GenericIdentifier<UserProtocol>) -> Bool {
        return users.first(where: { $0.id == userID }) != nil
    }
    
    func isCurrentUserFollowsThisUser(_ userID: User.Identifier) -> Bool {
        return followers.first(where: { $0.0 == currentUserID && $0.1 == userID }) != nil
    }
    
    func isCurrentUserIsFollowedByThisUser(_ userID: User.Identifier) -> Bool {
        return followers.first(where: { $0.0 == userID && $0.1 == currentUserID }) != nil
    }
    
    func numberOfFollowers(_ userID: User.Identifier) -> Int {
        return followers
            .filter { $0.1 == userID }
            .count
    }
    
    func numberOfFollows(_ userID: User.Identifier) -> Int {
        return followers
            .filter { $0.0 == userID }
            .count
    }
}



