//
//  KeyboardPresenter.swift
//  KisekaeKeyboard
//
//  Created by Toshiki Chiba on 2017/04/01.
//  Copyright © 2017年 Toshiki Chiba. All rights reserved.
//

import Foundation

final class KeyboardPresenter {
    fileprivate(set) lazy var service = KeyboardService()
    var isCandidateOpen = false
    
    func keyboardHeight() -> Float {
        var height = CandidateCollectionView.height + SwipeCollectionView.height
        // TODO: ポートレート&&iPhone判定
        if isCandidateOpen {
            height = KeyboardViewController.screenHeight - 20.0
        }
        return height
    }
    
    func swipeCollectionViewNumberOfItemsInSection() -> Int {
        return 1
    }
    
//    func keyboardCellView(at indexPath: IndexPath) -> UIView {
//        return UIView()
//    }
    
//    func keyboardCellSize(at indexPath: IndexPath) -> CGSize {
//        return .zero
//    }
}
