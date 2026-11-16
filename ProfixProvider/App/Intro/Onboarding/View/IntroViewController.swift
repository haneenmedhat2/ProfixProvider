//
//  IntroViewController.swift
//  ProfixProvider
//
//  Created by Haneen on 21/02/2026.
//


import UIKit
import Combine
import Kingfisher

class IntroViewController: BaseViewController {
    
    // MARK: - Properties -
    
    var viewModel : IntroVMProtocol
    var introList: [IntroModel] = []
    var currentIndex: Int = 0
    
    // MARK: - UI Components -
    
    private lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.register(IntroImageCell.self, forCellWithReuseIdentifier: IntroImageCell.reuseID)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.contentInsetAdjustmentBehavior = .never
        return cv
    }()
    
    private lazy var bottomSheet: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 24
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        v.layer.masksToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        l.textColor = .black
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var descLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        l.textColor = .border
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var pageIndicator: PageIndicatorView = {
        let v = PageIndicatorView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.onPageSelected = { [weak self] index in
            self?.scrollToPage(index, animated: true)
        }
        return v
    }()
    
    private lazy var nextButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("next".localized, for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        b.backgroundColor = .main
        b.layer.cornerRadius = 12
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        return b
    }()
    
    private lazy var closeButton: UIButton = {
        let b = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .regular)
        let img = UIImage(systemName: "xmark.circle.fill", withConfiguration: config)
        b.setImage(img, for: .normal)
        b.tintColor = .white
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return b
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(style: .large)
        v.color = .white
        v.hidesWhenStopped = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // MARK: - Initializer  -
    
    init(viewModel : IntroVMProtocol = IntroVM()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindToViewModel()
        viewModel.introRequest()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Keep item size exactly equal to collection view bounds so cells always fill correctly.
        // This fixes the gap/white-space bug that appears on first load or when scrolling via indicator.
        if let layout = imageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let newSize = imageCollectionView.bounds.size
            if layout.itemSize != newSize {
                layout.itemSize = newSize
                layout.invalidateLayout()
                // Re-snap to current page silently after layout pass
                let offsetX = CGFloat(currentIndex) * imageCollectionView.bounds.width
                imageCollectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override var prefersStatusBarHidden: Bool { false }
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(imageCollectionView)
        view.addSubview(bottomSheet)
        view.addSubview(closeButton)
        view.addSubview(loadingIndicator)
        
        bottomSheet.addSubview(titleLabel)
        bottomSheet.addSubview(descLabel)
        bottomSheet.addSubview(pageIndicator)
        bottomSheet.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            // Image collection — top 60% of screen
            imageCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            // Bottom sheet — fills the rest + overlaps image by 24pt (the corner radius)
            bottomSheet.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: -24),
            bottomSheet.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheet.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheet.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: bottomSheet.topAnchor, constant: 36),
            titleLabel.leadingAnchor.constraint(equalTo: bottomSheet.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: bottomSheet.trailingAnchor, constant: -24),
            
            // Desc
            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descLabel.leadingAnchor.constraint(equalTo: bottomSheet.leadingAnchor, constant: 24),
            descLabel.trailingAnchor.constraint(equalTo: bottomSheet.trailingAnchor, constant: -24),
            
            // Page indicator
            pageIndicator.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 24),
            pageIndicator.centerXAnchor.constraint(equalTo: bottomSheet.centerXAnchor),
            pageIndicator.heightAnchor.constraint(equalToConstant: 10),
            
            // Next button
            nextButton.leadingAnchor.constraint(equalTo: bottomSheet.leadingAnchor, constant: 24),
            nextButton.trailingAnchor.constraint(equalTo: bottomSheet.trailingAnchor, constant: -24),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: 48),
            
            // Close button — top-right (fixed: was incorrectly using leadingAnchor)
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            closeButton.widthAnchor.constraint(equalToConstant: 36),
            closeButton.heightAnchor.constraint(equalToConstant: 36),
            
            // Loading
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Binding -
    private func bindToViewModel() {
        loading(viewModel.isLoadingPublisher)
        
        viewModel.introPublisher
            .compactMap { $0 }
            .sinkOnMain { [weak self] _ in
                guard let self else { return }
                self.introList = self.viewModel.introList
                self.currentIndex = 0
                self.imageCollectionView.reloadData()
                self.pageIndicator.configure(count: self.introList.count, selectedIndex: 0)
                self.updateContent(at: 0)
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
    
    // MARK: - Helpers -
    private func updateContent(at index: Int) {
        guard introList.indices.contains(index) else { return }
        let item = introList[index]
        titleLabel.text = item.title
        descLabel.text = item.desc
        pageIndicator.setSelected(index: index)
    }
    
    private func scrollToPage(_ index: Int, animated: Bool) {
        guard introList.indices.contains(index) else { return }
        currentIndex = index
        viewModel.currentIndex = index
        updateContent(at: index)
        imageCollectionView.scrollToItem(
            at: IndexPath(item: index, section: 0),
            at: .centeredHorizontally,
            animated: animated
        )
    }
    
    // MARK: - Actions -
    
    @objc private func nextTapped() {
        let nextIndex = currentIndex + 1
        if nextIndex < introList.count {
            scrollToPage(nextIndex, animated: true)
        } else {
            goToLogin()
        }
    }
    
    @objc private func closeTapped() {
        goToLogin()
    }
    
    private func goToLogin() {
        UserDefaults.isFirstTime = false
        Session.isLogin = false
        let vc = LoginVC(viewModel: LoginVM())
        let nav = BaseNav(rootViewController: vc)
        AppHelper.changeWindowRoot(vc: nav)
    }
}

// MARK: - UICollectionViewDataSource -

extension IntroViewController: UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        introList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: IntroImageCell.reuseID, for: indexPath) as! IntroImageCell
        cell.configure(with: introList[indexPath.item].image)
        return cell
    }

    // Sync page indicator & text when user swipes image
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView === imageCollectionView else { return }
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        currentIndex = page
        viewModel.currentIndex = page
        updateContent(at: page)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard scrollView === imageCollectionView else { return }
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        updateContent(at: page)
    }
}

// MARK: - IntroImageCell -

final class IntroImageCell: UICollectionViewCell {
    static let reuseID = "IntroImageCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }

    func configure(with urlString: String?) {
        imageView.kf.cancelDownloadTask()
        guard let urlString, let url = URL(string: urlString) else {
            imageView.image = nil
            return
        }
        if let bundledImage = IntroImageAssets.image(for: url) {
            imageView.kf.indicatorType = .none
            imageView.image = bundledImage
            return
        }
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, options: [.backgroundDecode])
    }
}

// MARK: - PageIndicatorView -

final class PageIndicatorView: UIView {
    
    var onPageSelected: ((Int) -> Void)?
    
    private var count: Int = 0
    private var selectedIndex: Int = 0
    private var dotViews: [UIView] = []
    
    private let activeDotColor: UIColor = .main
    private let inactiveDotColor: UIColor = .mainWithAlpha
    private let activeDotW: CGFloat = 20
    private let inactiveDotW: CGFloat = 8
    private let dotH: CGFloat = 8
    private let spacing: CGFloat = 6
    
    private lazy var stack: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.spacing = spacing
        s.alignment = .center
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(count: Int, selectedIndex: Int) {
        self.count = count
        self.selectedIndex = selectedIndex
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        dotViews.removeAll()
        
        for _ in 0..<count {
            let dot = UIView()
            dot.layer.cornerRadius = dotH / 2
            dot.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(dot)
            dotViews.append(dot)
        }
        refreshDots(animated: false)
    }
    
    func setSelected(index: Int) {
        selectedIndex = index
        refreshDots(animated: true)
    }
    
    private func refreshDots(animated: Bool) {
        let block = {
            for (i, dot) in self.dotViews.enumerated() {
                let isActive = i == self.selectedIndex
                let w = isActive ? self.activeDotW : self.inactiveDotW
                dot.backgroundColor = isActive ? self.activeDotColor : self.inactiveDotColor
                dot.constraints.filter { $0.firstAttribute == .width }.forEach { $0.isActive = false }
                dot.widthAnchor.constraint(equalToConstant: w).isActive = true
                dot.heightAnchor.constraint(equalToConstant: self.dotH).isActive = true
                dot.layer.cornerRadius = self.dotH / 2
            }
            self.stack.layoutIfNeeded()
        }
        animated ? UIView.animate(withDuration: 0.25, animations: block) : block()
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: stack)
        for (index, dot) in dotViews.enumerated() {
            let frame = dot.frame
            let expandedFrame = frame.insetBy(dx: -8, dy: -12)
            if expandedFrame.contains(location) {
                onPageSelected?(index)
                break
            }
        }
    }
}
