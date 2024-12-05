//
//  RemoteImage.swift
//  VKTestApp
//
//  Created by Илья Востров on 05.12.2024.
//

import SwiftUI

struct RemoteImage: View {
    @StateObject private var imageLoader = ImageLoader()
    let url: String

    var body: some View {
        if let image = imageLoader.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else {
            ProgressView()
                .onAppear {
                    imageLoader.load(from: url)
                }
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private static var cache = NSCache<NSString, UIImage>()

    func load(from urlString: String) {
        if let cachedImage = Self.cache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self, let data = data, let loadedImage = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                Self.cache.setObject(loadedImage, forKey: urlString as NSString)
                self.image = loadedImage
            }
        }.resume()
    }
}
