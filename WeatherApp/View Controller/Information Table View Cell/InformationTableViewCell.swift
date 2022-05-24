import UIKit

struct InformationTableViewCellViewModel {
    let informationLabelString: String?
}

// MARK: - Class
class InformationTableViewCell: UITableViewCell {
    
    // MARK: - Lets/vars      
    private var weatherModel: WeatherModel?
    static let identifier = "InformationTableViewCell"
    
    // MARK: - IBOutlets
    @IBOutlet private weak var informationLabel: UILabel!
    
    // MARK: - awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "InformationTableViewCell",
                     bundle: nil)
    }
    
    // MARK: - Flow func
    func configure(model: WeatherModel) {
        self.weatherModel = model
    }
    
    func configureTableViewCellViewModelFor(_ index: Int) -> InformationTableViewCellViewModel {
        var informationLabelString: String?
        if let weatherMode = weatherModel {
            informationLabelString = "Now \(weatherMode.current.weather[0].descriptionWeather). Tonight's will be up to \(String(format: "%.f", weatherMode.daily[0].temp.night))°. "
        }
        return InformationTableViewCellViewModel(informationLabelString: informationLabelString)
    }
    
    func setupCell(_ viewModel: InformationTableViewCellViewModel) {
        informationLabel.text = viewModel.informationLabelString
    }
    
}
