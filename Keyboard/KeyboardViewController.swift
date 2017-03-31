//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by 千葉俊輝 on 2017/03/31.
//  Copyright © 2017年 Toshiki Chiba. All rights reserved.
//
import UIKit

final class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    
    private lazy var inputManager: InputManager = {
        let i = InputManager()
        i.delegate = self
        return i
    }()
    
    private lazy var inputEngine: KanaInputEngine = {
        let k = KanaInputEngine()
        k.delegate = self
        return k
    }()
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .system)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
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
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

}

extension KeyboardViewController: InputManagerDelegate {
    func inputManager(_ inputManager: InputManager!, didFailWithError error: Error!) {
        
    }
    func inputManager(_ inputManager: InputManager!, didCompleteWithCandidates candidates: [Any]!) {
        
    }
}

extension KeyboardViewController: KeyboardInputEngineDelegate {
    func keyboardInputEngine(_ engine: KanaInputEngine!, processedText text: String!, displayText: String!) {
        
    }
}

