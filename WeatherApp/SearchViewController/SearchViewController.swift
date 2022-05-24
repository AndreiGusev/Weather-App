import UIKit

//MARK: - Class
class SearchViewController: UIViewController {
    
    // MARK: - Lets/vars
    var viewModel = SearchViewModel()
    var searchViewController: SearchViewController?
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchNavigationBar: UINavigationBar!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchViewController = self
        searchController.searchResultsUpdater = self
        self.searchNavigationBar.topItem?.searchController = searchController
        bind()
    }
    
    private func bind() {
        viewModel.reloadTableView = {
            DispatchQueue.main.async { self.searchTableView.reloadData() }
        }
        viewModel.getLocation()
    }
    
}

// MARK: - Extension 
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        viewModel.searchLocation(text: text)
    }
}

// MARK: - Extension
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.searchResults
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        if viewModel.isLocationListEmpty() {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentLocationTableViewCell", for: indexPath) as? CurrentLocationTableViewCell else { return UITableViewCell() }
            cell.configure()
            return cell
            
        } else {
            
            guard let searchCell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
            let cellViewModel = viewModel.getCellViewModel(at: indexPath)
            searchCell.configure(listLocations: cellViewModel)
            return searchCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
        dismiss(animated: true)
    }
    
}
