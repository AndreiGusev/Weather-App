import UIKit

struct DescriptionTableViewCellViewModel {
    let descriptionTextLabelString: String?
    let descriptionValueLabelString: String?
}

// MARK: - Class
class DescriptionTableViewCell: UITableViewCell {
    
    // MARK: - Lets/vars
    private var weatherModel: WeatherModel?
    static var identifier = "DescriptionTableViewCell"
    
    // MARK: - IBOutlets
    @IBOutlet private weak var descriptionTextLabel: UILabel!
    @IBOutlet private weak var descriptionValueLabel: UILabel!
    
    // MARK: - awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "DescriptionTableViewCell", bundle: nil)
    }
    
    // MARK: - Flow func
    func configure(model: WeatherModel) {
        self.weatherModel = model
    }
    
    func configureTableViewCellViewModelFor(_ index: Int) -> DescriptionTableViewCellViewModel {
        var descriptionTextLabelString: String?
        var descriptionValueLabelString: String?

        if let weatherModel = weatherModel {
            switch index {
            case 0:
                descriptionTextLabelString = descriptionArray[index]
                descriptionValueLabelString = Date(timeIntervalSince1970: Double(weatherModel.current.sunrise)).getTimeFromDate()
            case 1:
                descriptionTextLabelString = descriptionArray[index]
                descriptionValueLabelString = Date(timeIntervalSince1970: Double(weatherModel.current.sunset)).getTimeFromDate()
            case 2:
                descriptionTextLabelString = descriptionArray[index]
                descriptionValueLabelString = String(weatherModel.current.humidity) + " %"
            case 3:
                descriptionTextLabelString = descriptionArray[index]
                descriptionValueLabelString = String(format: "%.1f", weatherModel.current.windSpeed) + " m/s"
            case 4:
                descriptionTextLabelString = descriptionArray[index]
                descriptionValueLabelString = String(format: "%.f", weatherModel.current.feelsLike) + "°"
            case 5:
                descriptionTextLabelString = descriptionArray[index]
                descriptionValueLabelString = String(format: "%.1f", Double(weatherModel.current.pressure) / 133.332 * 100) + " mm Hg"
            case 6:
                descriptionTextLabelString = descriptionArray[index]
                descriptionValueLabelString = String(format: "%.1f", weatherModel.current.visibility / 1000) + " km"
            case 7:
                descriptionTextLabelString = descriptionArray[index]
                descriptionValueLabelString = String(format: "%.f", weatherModel.current.uvi)
            default:
                print("")
            }

        }
        return DescriptionTableViewCellViewModel(descriptionTextLabelString: descriptionTextLabelString,
                                                 descriptionValueLabelString: descriptionValueLabelString)
    }
    
    func setupCell(_ viewModel: DescriptionTableViewCellViewModel) {
        descriptionTextLabel.text = viewModel.descriptionTextLabelString
        descriptionValueLabel.text = viewModel.descriptionValueLabelString
    }
    
}
