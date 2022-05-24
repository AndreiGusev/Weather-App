import UIKit

//MARK: - Class
class CurrentLocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var currentLocationImageViewCell: UIImageView!
    @IBOutlet weak var currentLocationLabelCell: UILabel!
    
    func configure() {
        self.currentLocationLabelCell.text = "Current position"
    }
    
}
