//
//  NetworkManager.swift
//  Crypto_info
//
//  Created by gikwegbu on 08/08/2024.
//

import Foundation
import Combine

class NetworkManager {
	enum NetworkingError: LocalizedError {
		case badURLResponse(url: URL)
		case unknown
		
		var errorDescription: String? {
			switch self {
			case .badURLResponse(url: let url): return " [🔥🔥] Bad response from URL: \(url)."
			case .unknown: return "[⚠️⚠️] Uknown error occured"
			}
		}
	}
	
	// Since we are trying  to make a reusable network download url, at the moment, we don't know what sorta publisher it is attached to, hence we first do let temp = URLSession.shared....., then we hover over the temp to see the data type, then we make the download func return that type, i.e after importing the Combine.
	
	// But human readablity sake, the returned type is really big and confusing, but luckily, the Combine has a better way, by adding the .eraseToAnyPublish(), then we make the download function return AnyPublisher
	static func download(url: URL) -> /*Publishers.ReceiveOn<Publishers.TryMap<Publishers.SubscribeOn<URLSession.DataTaskPublisher, DispatchQueue>, Data>, DispatchQueue> */
		AnyPublisher<Data, Error>{
			return URLSession.shared.dataTaskPublisher(for: url)
				.subscribe(on: DispatchQueue.global(qos: .default))
//				.tryMap { (output) -> Data in
//					guard let res = output.response as? HTTPURLResponse,
//								res.statusCode >= 200 && res.statusCode < 300 else {
//						throw URLError(.badServerResponse)
//					}
//					return output.data
//				}
				.tryMap({try handleURLResponse(output: $0 , url: url)})
				.receive(on: DispatchQueue.main)
				.eraseToAnyPublisher()
		}
	
	static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
		guard let res = output.response as? HTTPURLResponse,
					res.statusCode >= 200 && res.statusCode < 300 else {
//			throw URLError(.badServerResponse)
			throw NetworkingError.badURLResponse(url: url)
		}
		return output.data
	}
	
	static func handleCompletion(completion: Subscribers.Completion<Error>) {
		switch completion {
		case .finished:
			break
		case .failure(let err):
			print(err.localizedDescription)
		}
	}
}


// static was used, so we don't have to initialize an instance of the NetworkManager first before we can have access to the download function.

// If we don't use the static, then we neet to pass the NetworkManager().download
