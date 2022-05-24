import UIKit

//MARK: - Class
class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var locationName: UILabel!
    
    func configure(listLocations: SearchTableViewCellModel) {
        locationName.text = listLocations.location
    }
    
}
