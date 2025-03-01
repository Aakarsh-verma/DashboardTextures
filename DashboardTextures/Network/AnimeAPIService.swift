//
//  AnimeAPIService.swift
//  DashboardTextures
//
//  Created by Aakarsh Verma on 28/02/25.
//

import Foundation
import Alamofire
import RxSwift

let API_SERVICE = "https://api.jikan.moe/v4/seasons/2011/spring?sfw&limit=5"

protocol NetworkServiceProtocol {
    func fetchData<T: Codable>() -> Observable<T>
}

enum NetworkError: Error {
    case typeCheckFailed
}

class AnimeAPIService: NSObject, NetworkServiceProtocol {
    
    func fetchData<T: Codable>() -> Observable<T> {
        return Observable.create { observer in
            AF.request(API_SERVICE, method: .get)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let animeResponse):
                        guard let finalResponse = animeResponse as? AnimeResponseModel else {
                            observer.onError(NetworkError.typeCheckFailed)
                            return
                        }
                        observer.onNext(animeResponse)
                        observer.onCompleted()
                        
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            
            return Disposables.create()
        }
    }
}
