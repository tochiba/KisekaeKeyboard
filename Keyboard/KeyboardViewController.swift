//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by 千葉俊輝 on 2017/03/31.
//  Copyright © 2017年 Toshiki Chiba. All rights reserved.
//
import UIKit

final class KeyboardViewController: UIInputViewController {
    @IBOutlet weak var candidateCollectionView: CandidateCollectionView!
    @IBOutlet weak var swipeCollectionView: SwipeCollectionView!
    
    fileprivate let presenter = KeyboardPresenter()
    fileprivate lazy var service = KeyboardService()
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform custom UI setup here
        service.inputEngine.insertCharacter("あい")
        let height = candidateCollectionView.height + swipeCollectionView.height
        swipeCollectionView.isHidden = true
        setupKeyboardHeight(height: height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    }
    
    private func setupKeyboardHeight(height: CGFloat) {
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: height)
        view.addConstraint(heightConstraint)
    }
}

extension KeyboardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
extension KeyboardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView is CandidateCollectionView {
            return service.candidateCollectionViewNumberOfItemsInSection()
        } else if collectionView is SwipeCollectionView {
            return presenter.SwipeCollectionViewNumberOfItemsInSection()
        } else {
            return 0
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView is CandidateCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CandidateCell", for: indexPath) as? CandidateCell {
                cell.textLabel.text = service.candidateCellText(at: indexPath)
                return cell
            }
        } else if collectionView is SwipeCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeyboardCell", for: indexPath) as? KeyboardCell {                
                return cell
            }
        }
        return UICollectionViewCell()
    }
}
extension KeyboardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView is CandidateCollectionView {
            return service.candidateCellSize(at: indexPath)
        } else if collectionView is SwipeCollectionView {
            return collectionView.contentSize
        }
        return .zero
    }
}
