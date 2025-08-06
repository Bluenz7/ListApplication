//
//  Service .swift
//  ListApplication
//
//  Created by Владислав Скриганюк on 25.07.2025.
//

import Foundation

class StocksService {
    
    func fetchStocks(completion: @escaping (Result<[StocksDTO], Error>) -> Void) {
        let urlString = "https://mustdev.ru/api/stocks.json"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode([StocksDTO].self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
