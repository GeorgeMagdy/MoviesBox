//
//  RemoteImage.swift
//  MoviesBox
//
//  Created by George Magdy on 18/08/2025.
//

import Foundation
import SwiftUI
import Kingfisher
import Networking

struct MovieRemoteImage: View {
    let imageURLString: String?
    let size: Int
    
    var body: some View {
        if let unwrappedImageURLString = imageURLString, let url = URL(string: NetworkURLAPIHelper.image(size: "\(size)", imagePath: unwrappedImageURLString).apiFullURL) {
            KFImage(url)
                .resizable()
        } else {
            Image("imageP").resizable()
        }
    }
}

