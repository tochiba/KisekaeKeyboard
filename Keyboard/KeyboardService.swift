//
//  KeyboardService.swift
//  KisekaeKeyboard
//
//  Created by Toshiki Chiba on 2017/04/01.
//  Copyright © 2017年 Toshiki Chiba. All rights reserved.
//

import Foundation
import UIKit

final class KeyboardService: NSObject {
    private(set) lazy var inputManager: InputManager = {
        let i = InputManager()
        i.delegate = self
        return i
    }()
    
    private(set) lazy var inputEngine: KanaInputEngine = {
        let k = KanaInputEngine()
        k.delegate = self
        return k
    }()
    
    fileprivate var candidateList = [InputCandidate]()
    
    func candidateCollectionViewNumberOfItemsInSection() -> Int {
        return candidateList.count
    }
    
    func candidateCellText(at indexPath: IndexPath) -> String {
        if candidateList.count > indexPath.row {
            return candidateList[indexPath.row].candidate
        }
        return ""
    }
    
    func candidateCellSize(at indexPath: IndexPath) -> CGSize {
        let text = candidateCellText(at: indexPath)
        if text.isEmpty {
            return .zero
        }
        let size = (text as NSString).size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17)])
        return CGSize(width: size.width + 16.0, height: 40.0)
    }
}

extension KeyboardService: InputManagerDelegate {
    func inputManager(_ inputManager: InputManager!, didFailWithError error: Error!) {}
    func inputManager(_ inputManager: InputManager!, didCompleteWithCandidates candidates: [Any]!) {
        if let candidates = candidates as? [InputCandidate] {
            candidateList = candidates
//            candidates.forEach {
//                guard let input = $0.input, let candidate = $0.candidate else { return }
//                print("input: \(input), candidate: \(candidate)")
//            }
        }
    }
}

extension KeyboardService: KeyboardInputEngineDelegate {
    func keyboardInputEngine(_ engine: KanaInputEngine!, processedText text: String!, displayText: String!) {
        inputManager.requestCandidates(forInput: text)
    }
}
