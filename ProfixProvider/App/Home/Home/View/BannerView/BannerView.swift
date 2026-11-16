//
//  OfferViewController.swift
//  Cleaf
//
//  Created by Haneen on 01/06/2025.
//

import UIKit
import Kingfisher

class BannerSliderView: UIView,
                        UICollectionViewDelegate,
                        UICollectionViewDataSource,
                        UICollectionViewDelegateFlowLayout {

    private var sliderList: [Ad] = []
    private var collectionView: UICollectionView!
    private var pageStackView: UIStackView!
    private var autoScrollTimer: Timer?
    private var currentIndex = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        setupPageIndicator()
        startAutoScrollTimer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
        setupPageIndicator()
        startAutoScrollTimer()
    }

    deinit {
        autoScrollTimer?.invalidate()
    }

    func setSliderList(_ list: [Ad]) {
        sliderList = list
        if sliderList.count == 1 {
            pageStackView.isHidden = true
        }else {
            setupPageIndicator()
        }
        collectionView.reloadData()
        currentIndex = 0
        updatePageIndicator(to: 0)
    }

    // MARK: - CollectionView Setup -

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BannerImageCell.self, forCellWithReuseIdentifier: "BannerImageCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }

    // MARK: - Page Indicator -

    private func setupPageIndicator() {
        pageStackView?.removeFromSuperview()

        pageStackView = UIStackView()
        pageStackView.axis = .horizontal
        pageStackView.spacing = 6
        pageStackView.translatesAutoresizingMaskIntoConstraints = false

        for i in 0..<sliderList.count {
            let dot = UIView()
            dot.layer.cornerRadius = 4
            dot.backgroundColor = i == 0 ? .main : .white
            dot.widthAnchor.constraint(equalToConstant: 8).isActive = true
            dot.heightAnchor.constraint(equalToConstant: 8).isActive = true
            pageStackView.addArrangedSubview(dot)
        }

        addSubview(pageStackView)

        NSLayoutConstraint.activate([
            pageStackView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -10),
            pageStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    private func updatePageIndicator(to index: Int) {
        for (i, dot) in pageStackView.arrangedSubviews.enumerated() {
            dot.backgroundColor = i == index ? .main : .white
            dot.constraints.first { $0.firstAttribute == .width }?.constant = i == index ? 20 : 8
        }
    }

    // MARK: - Auto Scroll -

    private func startAutoScrollTimer() {
        autoScrollTimer = Timer.scheduledTimer(timeInterval: 5,
                                               target: self,
                                               selector: #selector(autoScroll),
                                               userInfo: nil,
                                               repeats: true)
    }

    @objc private func autoScroll() {
        guard sliderList.count > 1 else { return }
        currentIndex = (currentIndex + 1) % sliderList.count
        collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0),
                                    at: .centeredHorizontally,
                                    animated: true)
        updatePageIndicator(to: currentIndex)
    }

    // MARK: - CollectionView -

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sliderList.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerImageCell", for: indexPath) as! BannerImageCell
        cell.configure(url: sliderList[indexPath.item].image ?? "")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        updatePageIndicator(to: currentIndex)
    }
}


class BannerImageCell: UICollectionViewCell {

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .redraw
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.textFieldBorder.cgColor
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    override func prepareForReuse() {
        imageView.image = nil
    }

    func configure(url: String) {
        imageView.kf.setImage(with: URL(string: url),options: [.transition(.fade(0.3)) , .cacheOriginalImage])
    }
}


final class BannerSliderCell: UICollectionViewCell {

    private let sliderView = BannerSliderView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        contentView.addSubview(sliderView)
        sliderView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            sliderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            sliderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            sliderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            sliderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configure(list: [Ad]) {
        sliderView.setSliderList(list)
    }
}
