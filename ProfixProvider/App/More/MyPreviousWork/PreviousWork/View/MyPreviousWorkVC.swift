//
//  MyPreviousWorkVC.swift
//  ProfixProvider
//
//  Created by Haneen on 05/02/2026.
//

import UIKit
import Combine

class MyPreviousWorkVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var collectionView: CollectionViewContentSized!
    
    //MARK: - Properties -
    
    var viewModel : MyPreviousWorkVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : MyPreviousWorkVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "MyPreviousWorkVC", bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initialConfiguration()
        NotificationCenter.default.addObserver(  self, selector: #selector(refreshData),name: .isWorChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .isWorChanged, object: nil)
    }
    
    //MARK: - Initial Setup -
    
    func initialConfiguration(){
        self.title = "my_previous_works".localized
        view.isHidden = true
        bindToViewModel()
        configureCollectionView()
        viewModel.getWorksRequest()
    }
    
    func bindToViewModel(){
        loading(viewModel.isLoadingPublisher)
        viewModel.previousWorkPublisher
            .sinkOnMain{ [weak self] _ in
                guard let self = self else { return }
                view.isHidden = false
                self.collectionView.reloadData()
                updateEmptyState()
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
    
    //MARK: - Action -
    
    @IBAction func didTapAddNewWork(_ sender: UIButton) {
        goToAddNewWork()
    }
    
    @objc private func refreshData() {
        viewModel.getWorksRequest()
    }
}

//MARK: - CollectionView Configurations -

extension MyPreviousWorkVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: PreviousWorkCell.self)
    }
    
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        return viewModel.previousWork.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: PreviousWorkCell.self,for: indexPath)
        let item = viewModel.previousWork[indexPath.row]
        cell.setupCell(model: item)
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32
        return CGSize(width: width, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = viewModel.previousWork[indexPath.row]
        let vc = WorkDetailsVC(viewModel: WorkDetailsVM(workId: item.id ?? 0))
        push(vc)
    }
}

//MARK: - EmptyState  -

extension MyPreviousWorkVC {
    func updateEmptyState() {
        if viewModel.previousWork.isEmpty {
            collectionView.setEmptyState(
                image: UIImage(resource: .appPlaceholder),
                message: "no_previous_work".localized
            )
        } else {
            collectionView.removeEmptyState()
        }
    }
}

//MARK: - Routes -

extension MyPreviousWorkVC {
    func goToAddNewWork(){
        let vc = AddNewWorkVC(viewModel: AddNewWorkVM(mode: .newItem, workId: nil))
        push(vc)
    }
}

