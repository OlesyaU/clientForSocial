//
//  Post.swift
//  FirstCourseFinalTask
//
//  Created by Олеся on 22.06.2020.
//  Copyright © 2020 E-Legion. All rights reserved.
//

import Foundation
import FirstCourseFinalTaskChecker

struct Post: PostProtocol {
    var id: Identifier
    var author: GenericIdentifier<UserProtocol>
    var description: String
    var imageURL: URL
    var createdTime: Date
    var currentUserLikesThisPost: Bool
    var likedByCount: Int
}









