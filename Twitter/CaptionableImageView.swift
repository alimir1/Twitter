//
//  CaptionableImageView.swift
//  Twitter
//
//  Created by Ali Mir on 10/3/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import UIKit

@IBDesignable
class CaptionableImageView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet private var captionLabel: UILabel!
    @IBOutlet private var captionImageView: UIImageView!
    @IBOutlet private var captionLabelView: UIView!
    
    @IBInspectable var image: UIImage? {
        get { return captionImageView.image }
        set { captionImageView.image = newValue }
    }
    
    @IBInspectable var caption: String? {
        get { return captionLabel.text }
        set { captionLabel.text = newValue }
    }
    
    
    @IBInspectable var captionAlignment: NSTextAlignment? {
        get { return captionLabel.textAlignment }
        set {
            if newValue != nil {
                captionLabel.textAlignment = newValue!
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    func initSubViews() {
        let nib = UINib(nibName: "CaptionableImageView", bundle: Bundle(for: type(of: self)))
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        captionImageView.contentMode = .scaleAspectFill
        captionImageView.clipsToBounds = true
        addSubview(contentView)
        captionLabel.textAlignment = .left
    }
    

}
