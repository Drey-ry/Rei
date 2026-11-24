import Foundation

enum ClubServiceError: LocalizedError {
    case invalidURL
    case invalidResponse
    case emptyResponse

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The remote clubs URL is invalid."
        case .invalidResponse:
            return "The server returned an unsuccessful response."
        case .emptyResponse:
            return "The server returned no JSON data."
        }
    }
}

final class ClubService {
    static let shared = ClubService()

    private init() {}

    /// Downloads, validates, and decodes the remote club array.
    func fetchClubs(completion: @escaping (Result<[ClubDTO], Error>) -> Void) {
        guard let url = URL(string: AppConfiguration.remoteClubsURLString) else {
            completion(.failure(ClubServiceError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Club request failed: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Club request returned an unsuccessful HTTP response.")
                completion(.failure(ClubServiceError.invalidResponse))
                return
            }

            guard let data = data, !data.isEmpty else {
                completion(.failure(ClubServiceError.emptyResponse))
                return
            }

            do {
                let clubs = try JSONDecoder().decode([ClubDTO].self, from: data)
                completion(.success(clubs))
            } catch {
                print("Club JSON decoding failed: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }

    /// Keeps the project demonstrable before the student publishes their own JSON URL.
    func loadBundledSample(completion: @escaping (Result<[ClubDTO], Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: "clubs", withExtension: "json") else {
            completion(.failure(ClubServiceError.emptyResponse))
            return
        }

        do {
            let data = try Data(contentsOf: url)
            completion(.success(try JSONDecoder().decode([ClubDTO].self, from: data)))
        } catch {
            completion(.failure(error))
        }
    }
}

