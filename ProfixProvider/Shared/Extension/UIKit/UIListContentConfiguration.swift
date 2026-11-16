//
//  UIListContentConfiguration.swift
// NewBase
//
//  Created by MGAbouarab on 16/01/2024.
//

import UIKit

extension UIListContentConfiguration {
    
    static func defaultSubtitleCell(image: UIImage?, title: String?, subtitle: String? = nil) -> UIListContentConfiguration {
        
        let itemSize: CGSize = .init(width: 40, height: 40)
        var configuration = UIListContentConfiguration.subtitleCell()
        
        //MARK: - Image -
        configuration.image = image
        configuration.imageProperties.maximumSize = itemSize
        configuration.imageProperties.reservedLayoutSize = itemSize
        configuration.imageProperties.tintColor = .main
        
        //MARK: - Text -
        configuration.text = title
       // configuration.textProperties.font = .appMedium(size: 15)
        
        //MARK: - SecondaryText -
        configuration.secondaryText = subtitle
      //  configuration.secondaryTextProperties.font = .appRegular(size: 12)
        
        return configuration
    }
    
}
