//
//  DownloadsViewController.swift
//  Netflix
//
//  Created by Seba Gonzalez on 18/01/2024.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    private var titles = [TitleItem]()
    
    private let downloadsTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        title = "Downloads"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(downloadsTable)
        
        downloadsTable.delegate = self
        downloadsTable.dataSource = self
        
        fetchLocalStorageForDownloads()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("title:downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownloads()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadsTable.frame = view.bounds
    }
    
    private func fetchLocalStorageForDownloads() {
        DataPersistenceManager.shared.fetchTitlesFromDatabase { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                self?.downloadsTable.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        let title = titles[indexPath.item]
        cell.configure(with: TitleViewModel(titleName: (title.original_title ?? title.original_name) ?? "Unknown title name", posterURL: title.poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteTitle(with: titles[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    self?.titles.remove(at: indexPath.item)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            break;
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.item]
        
        guard let titleName = title.original_title ?? title.original_name else { return }
        
        ApiClient.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let youtubeVideo):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeVideo: youtubeVideo, titleOverview: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
