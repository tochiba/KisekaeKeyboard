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
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
        let height = candidateCollectionView.height + swipeCollectionView.height
        setupKeyboardHeight(height: height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform custom UI setup here
        presenter.service.inputEngine.insertCharacter("かさ")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        swipeCollectionView.reloadData()
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
    
    private func setupCandidateCollectionViewScrollDirection() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.sectionInset = .zero
        flowLayout.scrollDirection = swipeCollectionView.isHidden ? .vertical : .horizontal
        candidateCollectionView.collectionViewLayout = flowLayout
    }
    
    // MARK: - IBAction
    @IBAction func openCloseBtnDidTap(_ sender: UIButton) {
        // tag = 1 -> close, tag = 2 -> open
        if sender.tag == 1 {
            sender.tag = 2
            sender.setTitle("∧", for: .normal)
            swipeCollectionView.alpha = 1.0
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.swipeCollectionView.alpha = 0.0
            }, completion: { [weak self] _ in
                self?.swipeCollectionView.isHidden = true
                self?.setupCandidateCollectionViewScrollDirection()
            })
        } else {
            sender.tag = 1
            sender.setTitle("∨", for: .normal)
            swipeCollectionView.alpha = 0.0
            swipeCollectionView.isHidden = false
            setupCandidateCollectionViewScrollDirection()
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.swipeCollectionView.alpha = 1.0
                }, completion: nil)
        }
    }
}

extension KeyboardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView is CandidateCollectionView {
            let text = presenter.service.candidateCellText(at: indexPath)
            textDocumentProxy.insertText(text)
        } else if collectionView is SwipeCollectionView {
            advanceToNextInputMode()
        }
    }
}
extension KeyboardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView is CandidateCollectionView {
            return presenter.service.candidateCollectionViewNumberOfItemsInSection()
        } else if collectionView is SwipeCollectionView {
            return presenter.swipeCollectionViewNumberOfItemsInSection()
        } else {
            return 0
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView is CandidateCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CandidateCell", for: indexPath) as? CandidateCell {
                cell.textLabel.text = presenter.service.candidateCellText(at: indexPath)
                return cell
            }
        } else if collectionView is SwipeCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeyboardCell", for: indexPath) as? KeyboardCell {
                cell.backgroundColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
                return cell
            }
        }
        return UICollectionViewCell()
    }
}
extension KeyboardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView is CandidateCollectionView {
            return presenter.service.candidateCellSize(at: indexPath)
        } else if collectionView is SwipeCollectionView {
            return CGSize(width: view.frame.size.width, height: swipeCollectionView.height)
        }
        return .zero
    }
}
