import UIKit

struct HourlyCollectionViewCellViewModel {
    let tempLabelString: String?
    let timeLabelString: String?
    let humidityLabelString: String?
    let iconImage: UIImage?
    let urlString: String?
}

// MARK: - Class
class HourlyCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Lets/vars
    static let identifier = "HourlyCollectionViewCell"
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    // MARK: - awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "HourlyCollectionViewCell",
                     bundle: nil)
    }
    
    // MARK: - Flow func
    func setupCell(_ viewModel: HourlyCollectionViewCellViewModel) {
        if viewModel.timeLabelString == "Now" {
            timeLabel.text = "Now"
            timeLabel.font = UIFont.boldSystemFont(ofSize: 17)
            tempLabel.text = viewModel.tempLabelString
            tempLabel.font = UIFont.boldSystemFont(ofSize: 17)
        } else {
            timeLabel.text = viewModel.timeLabelString
            tempLabel.text = viewModel.tempLabelString
        }
        
        if viewModel.iconImage != nil {
            iconImageView.image = viewModel.iconImage
        } else {
            iconImageView.downloaded(from: viewModel.urlString ?? "")
        }
        
        humidityLabel.text = viewModel.humidityLabelString
    }
    
}
