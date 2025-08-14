//
//  Service .swift
//  ListApplication
//
//  Created by Владислав Скриганюк on 25.07.2025.
//

import Foundation

class StocksService {
    
    func fetchStocks(completion: @escaping (Result<[StocksDTO], Error>) -> Void) {
        let urlString = "http://mustdev.ru/api/stocks.json"
        
        guard let url = URL(string: urlString) else {
               let urlError = NSError(domain: "InvalidURL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL string"])
               completion(.failure(urlError))
               return
           }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                         (200...299).contains(httpResponse.statusCode) else {
                       let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                       let responseError = NSError(domain: "HTTPError", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Invalid response status code: \(statusCode)"])

                       return
                   }
            
            guard let data = data else {
                        let dataError = NSError(domain: "DataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                        completion(.failure(dataError))
                        return
                    }
            
            do {
                let response = try JSONDecoder().decode([StocksDTO].self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
    
    
    
    
    
    
    //    func fetchStocks(completion: @escaping (Result<[StocksDTO], Error>) -> Void) {
    //        let urlString = "https://mustdev.ru/api/stocks.json"
    //
    //        guard let url = URL(string: urlString) else { return }
    //
    //        URLSession.shared.dataTask(with: url) { data, _, error in
    //            if let error = error {
    //                completion(.failure(error))
    //                return
    //            }
    //            guard let data = data else { return }
    //
    //            do {
    //                let response = try JSONDecoder().decode([StocksDTO].self, from: data)
    //                completion(.success(response))
    //            } catch {
    //                completion(.failure(error))
    //            }
    //        }.resume()
    //    }
