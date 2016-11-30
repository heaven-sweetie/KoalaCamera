//
//  NotAuthorizedView.swift
//  KoalaCamera
//
//  Created by KimYong Gyun on 30/11/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import UIKit

class NotAuthorizedView: UIView {

    let settingButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Go to Setting", for: .normal)
        button.backgroundColor = .blue
        return button
    } ()

    let descriptionLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "😎\nAllow access to your camera to start taking photos"
        label.textColor = .blue
        label.lineBreakMode = .byWordWrapping
        label.backgroundColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    } ()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

    func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func activateConstraint(in view: UIView) {
        NSLayoutConstraint.activate([topAnchor.constraint(equalTo: view.topAnchor),
                                     bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     trailingAnchor.constraint(equalTo: view.trailingAnchor)])

        setupSettingButton()
        setupDescription()
    }

    func tappedSettingButton(sender: UIButton!) {
        print("Tapped Setting Button")
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
    }

    func setupSettingButton() {
        addSubview(settingButton)
        settingButton.addTarget(self, action: #selector(tappedSettingButton(sender:)), for: .touchUpInside)

        NSLayoutConstraint.activate([settingButton.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     settingButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     settingButton.widthAnchor.constraint(equalTo: widthAnchor),
                                     settingButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)])
    }
    
    func setupDescription() {
        addSubview(descriptionLabel)
        NSLayoutConstraint.activate([descriptionLabel.topAnchor.constraint(equalTo: topAnchor),
                                     descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     descriptionLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
                                     descriptionLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)])

    }
}
