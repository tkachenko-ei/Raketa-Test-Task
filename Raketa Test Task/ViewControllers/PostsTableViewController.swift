//
//  PostsTableViewController.swift
//  Raketa Test Task
//
//  Created by Yevhenii Tkachenko on 17.08.2020.
//  Copyright © 2020 Yevhenii Tkachenko. All rights reserved.
//

import UIKit
import Combine

class PostsTableViewController: UITableViewController {
    
    private var viewModel = PostsViewModel()
    private var bindings = Set<AnyCancellable>()

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupBindings()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    // MARK: - Setups
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
    }
    
    private func setupBindings() {
        let viewModelsValueHandler: ([PostCellViewModel]) -> Void = { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        viewModel.$postsViewModels
            .receive(on: RunLoop.main)
            .sink(receiveValue: viewModelsValueHandler)
            .store(in: &bindings)
        
        let stateValueHandler: (ListViewModelState) -> Void = { [weak self] state in
            switch state {
            case .loading:
                self?.refreshControl?.beginRefreshing()
            case .finishedLoading:
                self?.refreshControl?.endRefreshing()
            case .error(let error):
                self?.refreshControl?.endRefreshing()
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
        
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink(receiveValue: stateValueHandler)
            .store(in: &bindings)
    }
    
    // MARK: - Refesh action
    
    @objc private func refreshPosts() {
        viewModel.refresh()
    }

    // MARK: - UITableViewDelegate and UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.postsViewModels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return (tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as! PostCell)
            .configure(viewModel: viewModel.postsViewModels[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ImageService.shared.downloadImage(url: viewModel.postsViewModels[indexPath.row].preview) { [weak self] (image) in
            DispatchQueue.main.async {
                guard let image = image, let view = (tableView.cellForRow(at: indexPath) as? PostCell)?.previewView else { return }
                let imageInfo = ImageInfo(image: image, imageMode: .aspectFit)
                let transitionInfo = TransitionInfo(fromView: view)
                let imageViewer = ImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
                self?.present(imageViewer, animated: true, completion: nil)
            }
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + 300 >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            viewModel.nextPage()
        }
    }

}
