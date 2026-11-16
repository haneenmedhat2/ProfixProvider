import UIKit
import Combine

final class MyAppointmentsVC: BaseViewController {
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    private let viewModel: MyAppointmentsVMProtocol
    private let refreshControl = UIRefreshControl()
    private var isBusy = false

    init(viewModel: MyAppointmentsVMProtocol) {
        self.viewModel = viewModel
        super.init(nibName: "MyAppointmentsVC", bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "my_appointments".localized
        dateLabel.font = .myMediumFont(ofSize: 20)
        dateLabel.text = nil
        dateLabel.semanticContentAttribute = .forceLeftToRight
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 82
        tableView.register(DayPeriodCell.self, forCellReuseIdentifier: "DayPeriodCell")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }

    private func bindViewModel() {
        loading(viewModel.isLoadingPublisher)
        error(viewModel.errorPublisher)
        viewModel.dayPublisher.sinkOnMain { [weak self] day in
            self?.dateLabel.text = day?.date
            self?.render()
        }.store(in: &cancellables)
        viewModel.isLoadingPublisher.sinkOnMain { [weak self] loading in
            guard let self else { return }
            self.isBusy = loading
            if !loading { self.refreshControl.endRefreshing() }
            self.render()
        }.store(in: &cancellables)
    }

    private func render() {
        tableView.reloadData()
        guard !isBusy, viewModel.day?.periods.isEmpty != false else {
            tableView.backgroundView = nil
            return
        }
        let message = UILabel()
        message.numberOfLines = 0
        message.textAlignment = .center
        message.font = .myRegularFont(ofSize: 16)
        message.text = (viewModel.day == nil ? "appointments_load_failed" : "no_appointment_periods").localized
        let retry = UIButton(type: .system)
        retry.setTitle("appointments_refresh".localized, for: .normal)
        retry.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        let stack = UIStackView(arrangedSubviews: [message, retry])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        let background = UIView()
        background.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -24)
        ])
        tableView.backgroundView = background
    }

    @objc private func refresh() { viewModel.getDayPeriods() }
}

extension MyAppointmentsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.day?.periods.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayPeriodCell", for: indexPath) as! DayPeriodCell
        guard let period = viewModel.day?.periods[indexPath.row] else { return cell }
        cell.configure(period: period, enabled: !isBusy)
        cell.onToggle = { [weak self] closed in
            self?.viewModel.toggle(period: period, closed: closed)
        }
        return cell
    }
}
