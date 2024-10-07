//
//  NetworkManager.swift
//  Recipes
//
//  Created by michal zak on 06/10/2024.
//
import Foundation

class NetworkManager: ObservableObject {
    @Published var recipes: [Recipe] = []

    func fetchRecipes(completion: @escaping (Result<[Recipe], Error>) -> Void) {
            guard let url = URL(string: "https://hf-android-app.s3-eu-west-1.amazonaws.com/android-test/recipes.json") else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
                return
            }

            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }

                do {
                    let recipes = try JSONDecoder().decode([Recipe].self, from: data)
                    completion(.success(recipes))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
}
