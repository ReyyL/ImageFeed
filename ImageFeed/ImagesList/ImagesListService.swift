//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Andrey Lazarev on 06.05.2024.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult
    
    struct UrlsResult: Decodable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }
}

struct isPhotoLiked: Decodable {
    let photo: likedPhotoResult
}

struct likedPhotoResult: Decodable {
    let likedByUser: Bool
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let fullImageURL: String
    let largeImageURL: String
    var isLiked: Bool
    
    init(photoResult: PhotoResult) {
        
        let dateFormatter = ISO8601DateFormatter()
        
        self.id = photoResult.id
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        self.createdAt = photoResult.createdAt != nil ? dateFormatter.date(from: photoResult.createdAt ?? "") : nil
        self.welcomeDescription = photoResult.description
        self.fullImageURL = photoResult.urls.full
        self.largeImageURL = photoResult.urls.raw
        self.isLiked = photoResult.likedByUser
    }
    
    init(id: String, size: CGSize, createdAt: Date?, welcomeDescription: String?, fullImageURL: String, largeImageURL: String,  isLiked: Bool ) {
        
        self.id = id
        self.size = size
        self.createdAt = createdAt
        self.welcomeDescription = welcomeDescription
        self.fullImageURL = fullImageURL
        self.largeImageURL = largeImageURL
        self.isLiked = isLiked
    }
}

enum ImagesListServiceError: Error {
    case invalidRequest
}

final class ImagesListService {
    
    static let shared = ImagesListService()
    
    private init() {}
    
    private (set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private var task: URLSessionTask?
    
    private let urlSession = URLSession.shared
    
    private func imagesListRequest() -> URLRequest? {
        
        if task != nil {
            return nil
        }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        let path = "/photos?page=\(nextPage)"
        guard let url = URL(string: path, relativeTo: Constants.defaultBaseURL) else {
            assertionFailure("Ошибка создании URL")
            return nil
        }
        
        let request = URLRequest(url: url)
        
        if let currentPage = lastLoadedPage {
            self.lastLoadedPage = currentPage + 1
        } else {
            self.lastLoadedPage = 1
        }
        
        return request
    }
    
    func fetchPhotosNextPage() {
        
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard var request = imagesListRequest() else { preconditionFailure("Invalid Request") }
        
        guard let token = OAuth2TokenStorage().token else { return }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) {
            [weak self] (result: Result<[PhotoResult], Error>) in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    result.map { photoResult in
                        let nextPhoto = Photo(photoResult: photoResult)
                        return nextPhoto
                        
                    }.forEach { photo in
                        self.photos.append(photo)
                    }
                    
                    NotificationCenter.default
                        .post(name: ImagesListService.didChangeNotification,
                              object: self)
                    
                }
                
                self.task = nil
                
            case .failure(let error):
                print("Ошибка получения информации страницы с фото: \(error.localizedDescription)")
            }
        }
        
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool,
                    _ completion: @escaping (Result<Bool, Error>) -> Void) {
        
        
        if task != nil {
            task?.cancel()
        }
        
        let path = "/photos/\(photoId)/like"
        guard let url = URL(string: path, relativeTo: Constants.defaultBaseURL) else {
            assertionFailure("Ошибка создании URL")
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = isLike ? "POST" : "DELETE"
        
        guard let token = OAuth2TokenStorage().token else { return }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) {
            [weak self] (result: Result<isPhotoLiked, Error>) in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let responce):
                
                let isLiked = responce.photo.likedByUser
                
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    
                    let photo = self.photos[index]
                    // Копия элемента с инвертированным значением isLiked.
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        fullImageURL: photo.fullImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked
                    )
                    // Заменяем элемент в массиве.
                    self.photos[index] = newPhoto
                }
                completion(.success(isLiked))
                self.task = nil
            case .failure(let error):
                print("Ошибка получения информации о лайке: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}
