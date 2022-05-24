import UIKit

struct DailyTableViewCellViewModel {
    let dayLabelString: String?
    let highTempLabelString: String?
    let lowTempLabelString: String?
    let humidityLabelString: String?
    let iconImage: UIImage?
    let urlString: String?
    
}

// MARK: - Class
class DailyTableViewCell: UITableViewCell {
    
    // MARK: - Lets/vars
    private var weatherModel: WeatherModel?
    static let identifier = "DailyTableViewCell"
    
    // MARK: - IBOutlets
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var maxTempLabel: UILabel!
    @IBOutlet private weak var minTempLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    // MARK: - awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "DailyTableViewCell",
                     bundle: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
    }
    
    // MARK: - Flow func
    func configure(model: WeatherModel) {
        self.weatherModel = model
    }
    
    func configureTableViewCellViewModelFor(_ index: Int) -> DailyTableViewCellViewModel {
        var dayLabelString: String?
        var highTempLabelString: String?
        var lowTempLabelString: String?
        var humidityLabelString: String?
        var iconImage: UIImage?
        var urlString: String?
        
        if let weatherModel =  weatherModel {
            let dailyModel = weatherModel.daily[index + 1]
            dayLabelString = Date(timeIntervalSince1970: Double(dailyModel.dt)).getDayOfWeek()
            highTempLabelString = String(format: "%.f", dailyModel.temp.max)
            lowTempLabelString = String(format: "%.f", dailyModel.temp.min)
            urlString = "https://openweathermap.org/img/wn/\(dailyModel.weather[0].icon)@2x.png"
            iconImageView.downloaded(from: urlString ?? "")
            if dailyModel.humidity >= 30 {
                humidityLabelString = String(dailyModel.humidity) + " %"
            } else {
                humidityLabelString = ""
            }
        }
        return DailyTableViewCellViewModel(dayLabelString: dayLabelString,
                                           highTempLabelString: highTempLabelString,
                                           lowTempLabelString: lowTempLabelString,
                                           humidityLabelString: humidityLabelString,
                                           iconImage: iconImage,
                                           urlString: urlString)
    }
    
    func setupCell(_ viewModel: DailyTableViewCellViewModel) {
        dayLabel.text = viewModel.dayLabelString
        maxTempLabel.text = viewModel.highTempLabelString
        minTempLabel.text = viewModel.lowTempLabelString
        humidityLabel.text = viewModel.humidityLabelString
        iconImageView.image = viewModel.iconImage
    }
    
    
}
