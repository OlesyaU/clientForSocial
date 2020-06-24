
//  PostStorage.swift
//  FirstCourseFinalTask
//
//  Created by Олеся on 15.06.2020.
//  Copyright © 2020 E-Legion. All rights reserved.


import Foundation
import FirstCourseFinalTaskChecker

final class PostsStorage: PostsStorageProtocol {
    
    var count: Int { posts.count }
    private var posts: [PostInitialData]
    private var likes: [(GenericIdentifier<UserProtocol>, GenericIdentifier<PostProtocol>)]
    private let currentUserID: GenericIdentifier<UserProtocol>
    
    required init(posts: [PostInitialData], likes: [(GenericIdentifier<UserProtocol>, GenericIdentifier<PostProtocol>)], currentUserID: GenericIdentifier<UserProtocol>) {
        self.posts = posts
        self.likes = likes
        self.currentUserID = currentUserID
    }
    
    
    func post(with postID: GenericIdentifier<PostProtocol>) -> PostProtocol? {
        guard let postData: PostInitialData = posts.first(where: { $0.id == postID }) else { return nil }
        
        return Post(id: postData.id,
                    author: postData.author,
                    description: postData.description,
                    imageURL: postData.imageURL,
                    createdTime: postData.createdTime,
                    currentUserLikesThisPost: isCurrentUserLikesThisPost(postID),
                    likedByCount: numberOfLikes(postID))
    }
    
    func findPosts(by authorID: GenericIdentifier<UserProtocol>) -> [PostProtocol] {
        return posts
            .filter { $0.author == authorID }
            .compactMap { post(with: $0.id) }
    }
    
    func findPosts(by searchString: String) -> [PostProtocol] {
        return posts
            .filter { $0.description.contains(searchString) }
            .compactMap { post(with: $0.id) }
    }
    
    func likePost(with postID: GenericIdentifier<PostProtocol>) -> Bool {
        guard isCurrentPostExist(postID) else { return false }
        likes.append((currentUserID, postID))
        return true
    }
    
    func unlikePost(with postID: GenericIdentifier<PostProtocol>) -> Bool {
        guard isCurrentPostExist(postID) else { return false }
        likes.removeAll(where: { $0.0 == currentUserID && $0.1 == postID })
        return true
    }
    
    func usersLikedPost(with postID: GenericIdentifier<PostProtocol>) -> [GenericIdentifier<UserProtocol>]? {
        guard isCurrentPostExist(postID) else { return nil }
        return likes
            .filter { $0.1 == postID }
            .map { $0.0 }
    }
}

private extension PostsStorage {
    
    func isCurrentUserLikesThisPost(_ postID: Post.Identifier) -> Bool {
        return likes.first(where: { $0.0 == currentUserID && $0.1 == postID }) != nil
    }
    
    func numberOfLikes(_ postID: Post.Identifier) -> Int {
        return likes
            .filter { $0.1 == postID }
            .count
    }
    
    func isCurrentPostExist(_ postID: GenericIdentifier<PostProtocol>) -> Bool {
        return posts.first(where: { $0.id == postID }) != nil
    }
}



