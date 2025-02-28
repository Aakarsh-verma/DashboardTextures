//
//  Service.swift
//  DashboardTextures
//
//  Created by Aakarsh Verma on 28/02/25.
//

import Foundation
import Alamofire
import RxSwift

let API_SERVICE = "https://api.jikan.moe/v4/seasons/2011/spring?sfw&limit=5"

protocol NetworkServiceProtocol {
    func fetchData() -> Observable<[Datum]>
}

class AnimeAPIService: NSObject, NetworkServiceProtocol {
    func fetchData() -> Observable<[Datum]> {
        return Observable.create { observer in
            AF.request(API_SERVICE, method: .get)
                .validate()
                .responseDecodable(of: AnimeResponse.self) { response in
                    switch response.result {
                    case .success(let animeResponse):
                        observer.onNext(animeResponse.data ?? [])
                        observer.onCompleted()
                        
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            
            return Disposables.create()
        }
    }
}
