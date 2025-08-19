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

public struct MovieRemoteImage: View {
    public  let imageURLString: String?
    public let size: Int
    
    public init(imageURLString: String?, size: Int) {
        self.imageURLString = imageURLString
        self.size = size
    }
    
    public var body: some View {
        if let unwrappedImageURLString = imageURLString, let url = URL(string: NetworkURLAPIHelper.image(size: "\(size)", imagePath: unwrappedImageURLString).apiFullURL) {
            KFImage(url)
                .resizable()
        } else {
            Image("imageP").resizable()
        }
    }
}

