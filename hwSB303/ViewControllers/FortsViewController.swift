//
//  MainTableView.swift
//  hwSB303
//
//  Created by serg on 16.07.2023.
//

import UIKit

final class FortsViewController: UITableViewController {
    private var fortsData: AllFortsSecResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAll()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fortsData = self.fortsData else { return 0 }
        return min(fortsData.marketdata.data.count, fortsData.securities.data.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fortsCell", for: indexPath)
        guard let cell = cell as? FortsCellView else { return UITableViewCell() }
        guard let securities = fortsData?.securities, let marketdata = fortsData?.marketdata else { return UITableViewCell() }
        
        cell.configure(with: securities.data[indexPath.row], marketdata: marketdata.data[indexPath.row])
        return cell
    }
    
    func setNaviTitleCount(count: Int) {
        if count == 0 {
            self.navigationItem.title = "All FORTS futures (-)"
        } else {
            self.navigationItem.title = "All FORTS futures (\(count))"
        }
    }
    
}

// MARK: - Networking
extension FortsViewController {
    func fetchAll() {
        NetworkManager.shared.fetchFortsAllSecAF { [weak self] result in
            switch result {
            case .success(let data):
                self?.fortsData = data
                let min_count = min(data.marketdata.data.count, data.securities.data.count)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.setNaviTitleCount(count: min_count)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
