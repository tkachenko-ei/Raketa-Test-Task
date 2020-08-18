//
//  ListViewModelState.swift
//  Raketa Test Task
//
//  Created by Yevhenii Tkachenko on 17.08.2020.
//  Copyright © 2020 Yevhenii Tkachenko. All rights reserved.
//

enum ListViewModelState {
    case loading
    case finishedLoading
    case error(Error)
}
