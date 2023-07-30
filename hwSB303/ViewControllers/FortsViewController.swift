//
//  MainTableView.swift
//  hwSB303
//
//  Created by serg on 16.07.2023.
//

import UIKit

final class FortsViewController: UITableViewController {
    private var fortsSecurity: AllFortsSecResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAll()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let securities = self.fortsSecurity?.securities else { return 0 }
        return securities.data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fortsCell", for: indexPath)
        guard let cell = cell as? FortsCellView else { return UITableViewCell() }
        guard let securities = fortsSecurity?.securities, let marketdata = fortsSecurity?.marketdata else { return UITableViewCell() }
        
        cell.configure(with: securities.data[indexPath.row], marketdata: marketdata.data[indexPath.row])
        return cell
    }
    
}

// MARK: - Networking
extension FortsViewController {
    func fetchAll() {
        NetworkManager.shared.fetchFortsAllSecurities { [weak self] result in
            switch result {
            case .success(let data):
                self?.fortsSecurity = data
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
