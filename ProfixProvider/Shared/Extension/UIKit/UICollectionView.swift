//
//  UICollectionView.swift
// NewBase
//
//  Created by MGAbouarab on 26/12/2023.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: className)
    }
    func register<T: UICollectionViewCell>(cellTypes: [T.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }

    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as! T
    }
    
    func register<T: UICollectionReusableView>(headerType: T.Type, bundle: Bundle? = nil) {
        let className = headerType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forSupplementaryViewOfKind: Self.elementKindSectionHeader, withReuseIdentifier: className)
    }
    func register<T: UICollectionReusableView>(footerType: T.Type, bundle: Bundle? = nil) {
        let className = footerType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forSupplementaryViewOfKind: Self.elementKindSectionFooter, withReuseIdentifier: className)
    }
    
    func dequeueHeaderView<T: UICollectionReusableView>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: Self.elementKindSectionHeader, withReuseIdentifier: type.className, for: indexPath) as! T
    }
    
    func dequeueFooterView<T: UICollectionReusableView>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: Self.elementKindSectionFooter, withReuseIdentifier: type.className, for: indexPath) as! T
    }
}


class CollectionViewContentSized: UICollectionView {
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}


extension UICollectionView {
 
    func setEmptyState(image: UIImage?, message: String) {
        let emptyView = UIView(frame: self.bounds)
        emptyView.backgroundColor = .clear
        emptyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .hint
        messageLabel.font = .systemFont(ofSize: 18)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(messageLabel)
        
        emptyView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            
            messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: stackView.leadingAnchor),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: stackView.trailingAnchor),
            
            stackView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: emptyView.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: emptyView.trailingAnchor, constant: -32)
        ])
        
        self.backgroundView = emptyView
    }
    
    func removeEmptyState() {
        self.backgroundView = nil
    }
}
