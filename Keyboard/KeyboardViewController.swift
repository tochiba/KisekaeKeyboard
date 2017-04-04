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
    @IBOutlet weak var openCloseBtn: UIButton!
    @IBOutlet weak var inputLabel: UILabel!
    
    static let screenHeight = Float(UIScreen.main.bounds.height)
    private let heightConstraintIdentifier = "keyboardHeightConstraint"
    fileprivate let presenter = KeyboardPresenter()
    
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
        setupKeyboardHeight()
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
    
    private func createHeightConstraint() -> NSLayoutConstraint {
        let height = presenter.keyboardHeight()
        let heightConstraint = NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: CGFloat(height))
        heightConstraint.identifier = heightConstraintIdentifier
        return heightConstraint
    }
    
    private func setupKeyboardHeight() {
        guard view.constraints.contains(where: { layout in
            layout.identifier == heightConstraintIdentifier}) else {
                // 初回のキーボード高さ制約セット
                view.addConstraint(createHeightConstraint())
                view.layoutIfNeeded()
                return
        }
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.constraints.forEach({
                if $0.identifier == self.heightConstraintIdentifier {
                    $0.constant = CGFloat(self.presenter.keyboardHeight())
                }
            })
        })
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
        if presenter.isCandidateOpen {
            sender.setTitle("∨", for: .normal)
            swipeCollectionView.alpha = 0.0
            swipeCollectionView.isHidden = false
            inputLabel.alpha = 1.0
            setupCandidateCollectionViewScrollDirection()
            presenter.isCandidateOpen = !presenter.isCandidateOpen
            setupKeyboardHeight()
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.swipeCollectionView.alpha = 1.0
                self?.inputLabel.alpha = 0.0
                }, completion: { [weak self] _ in
                    self?.inputLabel.isHidden = true
            })
        } else {
            sender.setTitle("∧", for: .normal)
            swipeCollectionView.alpha = 1.0
            inputLabel.alpha = 0.0
            inputLabel.isHidden = false
            presenter.isCandidateOpen = !presenter.isCandidateOpen
            setupKeyboardHeight()
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.swipeCollectionView.alpha = 0.0
                self?.inputLabel.alpha = 1.0
                }, completion: { [weak self] _ in
                    self?.swipeCollectionView.isHidden = true
                    self?.setupCandidateCollectionViewScrollDirection()
            })
        }
    }
}

extension KeyboardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView is CandidateCollectionView {
            if presenter.isCandidateOpen {
                openCloseBtnDidTap(openCloseBtn)
            }
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
            return CGSize(width: view.frame.size.width, height: CGFloat(SwipeCollectionView.height))
        }
        return .zero
    }
}
