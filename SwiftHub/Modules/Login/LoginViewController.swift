//
//  LoginViewController.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 7/12/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

enum LoginSegments: Int {
    case oAuth, personal, basic

    var title: String {
        switch self {
        case .oAuth: return R.string.localizable.loginOAuthSegmentTitle.key.localized()
        case .personal: return R.string.localizable.loginPersonalSegmentTitle.key.localized()
        case .basic: return R.string.localizable.loginBasicSegmentTitle.key.localized()
        }
    }
}

class LoginViewController: ViewController {


    // MARK: - Personal Access Token authentication

    lazy var personalLoginStackView: StackView = {
        let subviews: [UIView] = [personalLogoImageView, personalTitleLabel, personalDetailLabel, personalTokenTextField, personalLoginButton]
        let view = StackView(arrangedSubviews: subviews)
        view.spacing = inset * 2
        return view
    }()

    lazy var personalLogoImageView: ImageView = {
        let view = ImageView(image: R.image.image_no_result()?.template)
        return view
    }()

    lazy var personalTitleLabel: Label = {
        let view = Label()
        view.font = view.font.withSize(22)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()

    lazy var personalDetailLabel: Label = {
        let view = Label()
        view.font = view.font.withSize(17)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()

    lazy var personalTokenTextField: TextField = {
        let view = TextField()
        view.textAlignment = .center
        view.keyboardType = .emailAddress
        view.autocapitalizationType = .none
        return view
    }()

    lazy var personalLoginButton: Button = {
        let view = Button()
        view.imageForNormal = R.image.icon_button_github()
        view.centerTextAndImage(spacing: inset)
        return view
    }()

    private lazy var scrollView: ScrollView = {
        let view = ScrollView()
        self.contentView.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        return view
    }()

    override func makeUI() {
        super.makeUI()

        languageChanged.subscribe(onNext: { [weak self] () in
   
            // MARK: Personal
            self?.personalTitleLabel.text = R.string.localizable.loginPersonalTitleLabelText.key.localized()
            self?.personalDetailLabel.text = R.string.localizable.loginPersonalDetailLabelText.key.localizedFormat(Configs.App.githubScope)
            self?.personalTokenTextField.placeholder = R.string.localizable.loginPersonalTokenTextFieldPlaceholder.key.localized()
            self?.personalLoginButton.titleForNormal = R.string.localizable.loginPersonalLoginButtonTitle.key.localized()
        }).disposed(by: rx.disposeBag)

        stackView.removeFromSuperview()
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(self.inset*2)
            make.centerX.equalToSuperview()
        })

        personalTitleLabel.theme.textColor = themeService.attribute { $0.text }
        personalDetailLabel.theme.textColor = themeService.attribute { $0.textGray }
        personalLogoImageView.theme.tintColor = themeService.attribute { $0.text }

        stackView.addArrangedSubview(personalLoginStackView)
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? LoginViewModel else { return }

        isLoading.asDriver().drive(onNext: { [weak self] (isLoading) in
            isLoading ? self?.startAnimating() : self?.stopAnimating()
        }).disposed(by: rx.disposeBag)

        _ = personalTokenTextField.rx.textInput <-> viewModel.personalToken


        error.subscribe(onNext: { [weak self] (error) in
            self?.view.makeToast(error.description, title: error.title, image: R.image.icon_toast_warning())
        }).disposed(by: rx.disposeBag)
    }
}
