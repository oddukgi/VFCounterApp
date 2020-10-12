//
//  WeatherIconView.swift
//  VFCounter
//
//  Created by Sunmi on 2020/08/20.
//  Copyright © 2020 creativeSun. All rights reserved.
//

import UIKit

class WeatherIconView: UIImageView {

    let cache = NetworkManager.shared.cache
    let placeholderImage = Images.placeHolder

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        clipsToBounds   = true
        image           = placeholderImage
        contentMode     = .scaleAspectFit
    }

    func downloadWeatherIcon(from url: String) {

        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
