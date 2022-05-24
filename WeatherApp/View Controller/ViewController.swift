import UIKit

// MARK: - Class
class ViewController: UIViewController {
    
    // MARK: - var/let
    let networkService = DataFetcherService()
    var refresh = UIRefreshControl()
    private let viewModel = ViewControllerModel()
    
    // MARK: - IBOutlets
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var weatherStatusLabel: UILabel!
    @IBOutlet weak var weatherStatusImageView: UIImageView!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var maxTempTextLabel: UILabel!
    @IBOutlet weak var minTempTextLabel: UILabel!
    @IBOutlet weak var hidingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var FeelsLikeTempLabel: UILabel!
    @IBOutlet weak var getLocationButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationModel.shared.getLocation()
        self.bind()
        self.viewModel.locationManagerSetup()
        self.viewModel.getWeather()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollView.refreshControl = self.refresh
        self.refresh.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.contentInsetAdjustmentBehavior = .never
        self.setGradientBackground()
        self.setupTableView()
        self.tableView.reloadData()
        self.showUI()
    }
    
    // MARK: - IBActions
    @IBAction func testCrashButtonPressed(_ sender: UIButton) {
        self.viewModel.testCrashButton()
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else { return }
        controller.viewModel.delegate = self.viewModel
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func getLocationButtonPressed(_ sender: UIButton) {
        self.viewModel.gpsButtonPressed()
    }
    
    // MARK: - Flow func
    @objc func pullToRefresh(_ sender: Any) {
        updateWeather()
    }
    
    func updateWeather () {
        self.viewModel.getWeather()
        self.scrollView.refreshControl?.endRefreshing()
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 145/255.0, green: 234/255.0, blue: 228/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 127.0/255.0, green: 127/255.0, blue: 213/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        let gradientLayerHideView = CAGradientLayer()
        gradientLayerHideView.colors = [colorTop, colorBottom]
        gradientLayerHideView.locations = [0.0, 1.0]
        gradientLayerHideView.frame = self.hidingView.bounds
        
        self.hidingView.layer.insertSublayer(gradientLayerHideView, at:0)
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DailyTableViewCell.nib(),
                           forCellReuseIdentifier: DailyTableViewCell.identifier)
        tableView.register(HourlyTableViewCell.nib(),
                           forCellReuseIdentifier: HourlyTableViewCell.identifier)
        tableView.register(InformationTableViewCell.nib(),
                           forCellReuseIdentifier: InformationTableViewCell.identifier)
        tableView.register(DescriptionTableViewCell.nib(),
                           forCellReuseIdentifier: DescriptionTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
    }
    
    func showUI() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.weatherStatusImageView.image = UIImage(systemName: self.viewModel.conditionName)
            self.locationNameLabel.isHidden = false
            self.currentTempLabel.isHidden = false
            self.weatherStatusImageView.isHidden = false
            self.weatherStatusLabel.isHidden = false
            self.FeelsLikeTempLabel.isHidden = false
            self.feelsLikeLabel.isHidden = false
            self.maxTempLabel.isHidden = false
            self.minTempLabel.isHidden = false
            self.maxTempTextLabel.isHidden = false
            self.minTempTextLabel.isHidden = false
            self.activityIndicator.isHidden = true
            self.hidingView.isHidden = true
            self.getLocationButton.isHidden = true
            self.searchButton.isHidden = false
        }
    }
    
    private func bind() {
        self.viewModel.locationNameLabel.bind { [weak self] text in
            self?.locationNameLabel.text = text
        }
        self.viewModel.currentTempLabel.bind { [weak self] text in
            self?.currentTempLabel.text = text
        }
        self.viewModel.FeelsLikeTempLabel.bind { [weak self] text in
            self?.FeelsLikeTempLabel.text = text
        }
        self.viewModel.weatherStatusLabel.bind { [weak self] text in
            self?.weatherStatusLabel.text = text
        }
        self.viewModel.minTempLabel.bind { [weak self] text in
            self?.minTempLabel.text = text
        }
        self.viewModel.maxTempLabel.bind { [weak self] text in
            self?.maxTempLabel.text = text
        }
        self.viewModel.reloadTableView = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}

// MARK: - Extension
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return WeatherTableViewSection.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = WeatherTableViewSection(sectionIndex: section) else { return 0 }
        
        switch section {
        case .hourly:
            return 1
        case .daily:
            return 7
        case .information:
            return 1
        case .description:
            return descriptionArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = WeatherTableViewSection(sectionIndex: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .hourly:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as? HourlyTableViewCell else {
                return UITableViewCell()
            }
            if let weatherModel = viewModel.weatherModel {
                cell.configure(model: weatherModel)
            }
            return cell
            
        case .daily:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.identifier, for: indexPath) as? DailyTableViewCell else {
                return UITableViewCell()
            }
            if let weatherModel = viewModel.weatherModel {
                cell.configure(model: weatherModel)
            }
            let viewModel = cell.configureTableViewCellViewModelFor(indexPath.row)
            cell.setupCell(viewModel)
            return cell
            
        case .information:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.identifier, for: indexPath) as? InformationTableViewCell else {
                return UITableViewCell()
            }
            if let weatherModel = viewModel.weatherModel {
                cell.configure(model: weatherModel)
            }
            let viewModel = cell.configureTableViewCellViewModelFor(indexPath.row)
            cell.setupCell(viewModel)
            return cell
            
        case .description:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionTableViewCell.identifier, for: indexPath) as? DescriptionTableViewCell else {
                return UITableViewCell()
            }
            if let weatherModel = viewModel.weatherModel {
                cell.configure(model: weatherModel)
            }
            let viewModel = cell.configureTableViewCellViewModelFor(indexPath.row)
            cell.setupCell(viewModel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = WeatherTableViewSection(sectionIndex: indexPath.section) else { return CGFloat() }
        switch section {
        case .hourly:
            return section.cellHeight
        case .daily:
            return section.cellHeight
        case .information:
            return section.cellHeight
        case .description:
            return section.cellHeight
        }
    }
    
}



