//
//  User.swift
//  FirstCourseFinalTask
//
//  Created by Олеся on 16.06.2020.
//  Copyright © 2020 E-Legion. All rights reserved.
//

import Foundation
import FirstCourseFinalTaskChecker

struct User: UserProtocol {
    
    let id: Identifier
    let username: String
    let fullName: String
    let avatarURL: URL?
    let currentUserFollowsThisUser: Bool
    let currentUserIsFollowedByThisUser: Bool
    let followsCount: Int
    let followedByCount: Int
}

