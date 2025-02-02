import UIKit

// MARK: - Class
 class HourlyTableViewCell: UITableViewCell, UICollectionViewDelegateFlowLayout {
     
     // MARK: - Lets/vars
    var weatherModel: WeatherModel?
    static var identifier = "HourlyTableViewCell"
    
     // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
     
     // MARK: - awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "HourlyTableViewCell",
                     bundle: nil)
    }
    
    // MARK: - Flow func
    func configure(model: WeatherModel) {
        self.weatherModel = model
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func setupCollectionView() {
        collectionView.register(HourlyCollectionViewCell.nib(), forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func configureCollectionCellViewModelFor(_ index: Int) -> HourlyCollectionViewCellViewModel  {
        var tempLabelString: String?
        var timeLabelString: String?
        var humidityLabelString: String?
        var iconImage: UIImage?
        var urlStringForImage: String?
        
        if let weatherModel = weatherModel {
            let hourlyModel = weatherModel.hourly[index]
            let hourForDate = Date(timeIntervalSince1970: Double(hourlyModel.dt)).getHourFromDate()
            let nextHourForDate = Date(timeIntervalSince1970: Double(weatherModel.hourly[index + 1].dt)).getTimeFromDate()
            let timeForDate = Date(timeIntervalSince1970: Double(hourlyModel.dt)).getTimeFromDate()
            let sunset = Date(timeIntervalSince1970: Double(weatherModel.current.sunset)).getTimeFromDate()
            let sunrise = Date(timeIntervalSince1970: Double(weatherModel.current.sunrise)).getTimeFromDate()
            urlStringForImage = "https://openweathermap.org/img/wn/\(hourlyModel.weather[0].icon)@2x.png"
            
            if index == 0 {
                timeLabelString = "Now"
                iconImage = nil
                tempLabelString = String(format: "%.f", weatherModel.hourly[index].temp) + "°"
            } else {
                if sunset >= timeForDate && sunset < nextHourForDate {
                    tempLabelString = "Sunset"
                    iconImage = #imageLiteral(resourceName: "sunset")
                    timeLabelString = sunset
                } else if sunrise >= timeForDate && sunrise < nextHourForDate {
                    tempLabelString = "Sunrise"
                    iconImage = #imageLiteral(resourceName: "sunrise")
                    timeLabelString = sunrise
                } else {
                    iconImage = nil
                    tempLabelString = String(format: "%.f", weatherModel.hourly[index].temp) + "°"
                    timeLabelString = hourForDate
                }
            }
            if hourlyModel.humidity >= 30 {
                humidityLabelString = String(hourlyModel.humidity) + " %"
            } else {
                humidityLabelString = ""
            }
        }
        return HourlyCollectionViewCellViewModel(tempLabelString: tempLabelString,
                                                 timeLabelString: timeLabelString,
                                                 humidityLabelString: humidityLabelString,
                                                 iconImage: iconImage,
                                                 urlString: urlStringForImage)
    }
    
    
}


extension HourlyTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as! HourlyCollectionViewCell
        
        let viewModel = configureCollectionCellViewModelFor(indexPath.row)
        cell.setupCell(viewModel)
        return cell
    }
    
}
