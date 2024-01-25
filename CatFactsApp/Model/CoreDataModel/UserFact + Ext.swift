//
//  UserFact + Ext.swift
//  CatFactsApp
//
//  Created by Edgar Kuskov on 22.12.23.
//

import Foundation
import UIKit

extension UserFact {
    
    func saveImage(_ image: UIImage?) {
        if let image = image {
            self.image = image.pngData()
            self.imageOrientation = Int16(image.imageOrientation.rawValue)
        } else {
            self.image = Resources.Images.imageErr?.pngData()
        }
    }
    
    func getImage() -> UIImage? {
        guard let imageData = self.image,
              let notOrientedImage = UIImage(data: imageData),
              let cgImage = notOrientedImage.cgImage,
              let orientation = UIImage.Orientation(rawValue: Int(self.imageOrientation))
        else {
            return Resources.Images.imageErr }
        
        let scale = notOrientedImage.scale
        let image = UIImage(cgImage: cgImage, scale: scale, orientation: orientation)

        return image
    }
}
