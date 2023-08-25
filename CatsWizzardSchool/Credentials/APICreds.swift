import Foundation

public struct APICreds {
    let host: String
	let endpoint: String
	let key: String

    var url: URL? {
        URL(string: "https://\(host)\(endpoint)")
    }
}
