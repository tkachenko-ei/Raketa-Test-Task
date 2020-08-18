//
//  PostCell.swift
//  Raketa Test Task
//
//  Created by Yevhenii Tkachenko on 17.08.2020.
//  Copyright © 2020 Yevhenii Tkachenko. All rights reserved.
//

import UIKit
import Combine

final class PostCell: UITableViewCell {
    
    static let identifier = "PostCell"
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var commentsLabel: UILabel!
    @IBOutlet private weak var createdLabel: UILabel!
    @IBOutlet private weak var previewImageView: UIImageView!
    
    var previewView: UIView {
        return previewImageView
    }
    
    private var viewModel: PostCellViewModel! {
        didSet {
            setupViewModel()
        }
    }
    
    // MARK: - Configure
    
    func configure(viewModel: PostCellViewModel) -> Self {
        self.viewModel = viewModel
        return self
    }
    
    // MARK: - Setups
    
    private func setupViewModel() {
        titleLabel.text = viewModel.title
        authorLabel.text = viewModel.author
        commentsLabel.text = viewModel.commentsCount
        createdLabel.text = viewModel.createdDate
        previewImageView.image = nil
        ImageService.shared.downloadImage(url: viewModel.preview) { [weak self] (image) in
            DispatchQueue.main.async {
                self?.previewImageView.image = image
            }
        }
    }
}
