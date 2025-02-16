//
//  NetworkService.swift
//  RadicleApp
//
//  Created by bordumb on 16/02/2025.
//

import Foundation
import Combine

class NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
    func fetchRepositories(completion: @escaping (Result<[RepoItem], Error>) -> Void) {
            let baseURL = URL(string: "https://seed.radicle.garden/api/v1/repos")!
            let request = URLRequest(url: baseURL)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        let noDataError = NSError(domain: "", code: -1,
                                                  userInfo: [NSLocalizedDescriptionKey: "No data"])
                        completion(.failure(noDataError))
                    }
                    return
                }
                
                print("RAW JSON:", String(data: data, encoding: .utf8) ?? "nil")
                
                do {
                    let decoder = JSONDecoder()
                    let repos = try decoder.decode([RepoItem].self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(repos))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    
    
    func fetchCommit(rid: String, commit: String, completion: @escaping (Result<CommitResponse, Error>) -> Void) {
        // e.g. https://seed.radicle.garden/api/v1/repos/{rid}/commits/{commit}
        guard let url = URL(string: "https://seed.radicle.garden/api/v1/repos/\(rid)/commits/\(commit)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid commit URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    let noDataError = NSError(domain: "", code: -1,
                                              userInfo: [NSLocalizedDescriptionKey: "No data"])
                    completion(.failure(noDataError))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let commitResp = try decoder.decode(CommitResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(commitResp))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    /// Fetches all issues for the specified repository.
    /// - Parameters:
    ///   - repoID: The repository identifier.
    ///   - completion: A closure that returns a Result with an array of Issue objects or an Error.
    func fetchIssues(repoID: String, completion: @escaping (Result<[Issue], Error>) -> Void) {
        let urlString = "https://seed.radicle.garden/api/v1/repos/\(repoID)/issues"
        print("Fetching issues from: \(urlString)")

        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            // Check the HTTP status code
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP status code: \(httpResponse.statusCode)")
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noData))
                }
                return
            }

            // Print raw JSON to see what's returned
            print("RAW JSON:", String(data: data, encoding: .utf8) ?? "nil")

            do {
                let decoder = JSONDecoder()
                let issues = try decoder.decode([Issue].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(issues))
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.decodingError(error)))
                }
            }
        }.resume()
    }
    
    /// Fetches a single issue by repoID and issueID.
    /// - Parameters:
    ///   - repoID: The repository identifier.
    ///   - issueID: The unique issue identifier.
    ///   - completion: A closure that returns a Result with an Issue or an Error.
    func fetchIssue(repoID: String, issueID: String, completion: @escaping (Result<Issue, Error>) -> Void) {
        let urlString = "https://seed.radicle.garden/api/v1/repos/\(repoID)/issues/\(issueID)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noData))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let issue = try decoder.decode(Issue.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(issue))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.decodingError(error)))
                }
            }
        }.resume()
    }
}
