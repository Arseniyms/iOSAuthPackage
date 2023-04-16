//
//  SignUpViewController.swift
//  EventPasser
//
//  Created by Arseniy Matus on 17.10.2022.
//
//

import UIKit

class SignUpViewController: UIViewController {
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(exitButtonTapped))
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Выход", style: .plain, target: self, action: #selector(exitButtonTapped))
        }

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        setupUI()
    }

    @objc func exitButtonTapped(_: UIButton) {
        self.presenter?.exit()
    }

    // MARK: - Properties

    var presenter: ViewToPresenterSignUpProtocol?

    var isEmailValid = false
    var isPassValid = false
    var isConfirmPassValid = false

    var signingUp = false {
        didSet {
            if #available(iOS 15.0, *) {
                signUpButton.setNeedsUpdateConfiguration()
            }
        }
    }

    private lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        if #available(iOS 13.0, *) {
            stackView.spacing = 10
        } else {
            stackView.spacing = 5
        }

        return stackView
    }()
    
    private lazy var switchStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        
        return stackView
    } ()

    private lazy var emailTextField: UITextField = {
        let textField = self.getInfoTextField()
        textField.tag = 1
        textField.textContentType = .emailAddress
        textField.keyboardType = .emailAddress
        textField.setBorderStyle(autocorrectionType: .no, autocapitalizationType: .none)
        textField.addTarget(self, action: #selector(emailTextFieldDidChange), for: .editingChanged)

        return textField
    }()

    @objc func emailTextFieldDidChange(_ textField: UITextField) {
        self.presenter?.emailDidChange(to: textField.text ?? "")
        textField.textColor = self.isEmailValid ? .dynamic(light: .black, dark: .white) : .red
    }

    private lazy var passTextField: UITextField = {
        let textField = self.getPasswordTextField()
        textField.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
        textField.tag = 2

        return textField
    }()

    private lazy var confirmPassTextField: UITextField = {
        let textField = self.getPasswordTextField()
        textField.addTarget(self, action: #selector(passwordConfirmTextFieldDidChange), for: .editingChanged)
        textField.tag = 3

        return textField
    }()
    
    private lazy var isAdminSwitch: UISwitch = {
        let isAdminSwitch = UISwitch()
        isAdminSwitch.isOn = false
        isAdminSwitch.onTintColor = .buttonColor
        return isAdminSwitch
    } ()

    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Зарегистрироваться", for: .normal)

        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.bordered()
            config.buttonSize = .small
            config.cornerStyle = .medium
            config.baseForegroundColor = .white
            config.baseBackgroundColor = .buttonColor
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer {
                var outgoing = $0
                outgoing.font = UIFont.systemFont(ofSize: 30, weight: .light)
                return outgoing
            }

            button.configuration = config

            button.configurationUpdateHandler = { [weak self] button in
                guard let self else { return }
                var config = button.configuration
                config?.showsActivityIndicator = self.signingUp
                config?.title = self.signingUp ? "Регистрация..." : "Регистрация"
                button.isEnabled = !self.signingUp && self.isPassValid && self.isEmailValid && self.isConfirmPassValid
                button.configuration = config
            }

        } else {
            button.isEnabled = false
            button.setTitleColor(.white, for: .normal)
            button.setTitleColor(.systemGray, for: .disabled)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .light)
            button.layer.cornerRadius = 10
            button.backgroundColor = UIColor.buttonColor
        }

        button.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var invalidPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Пароль должен быть больше 8 символов и на английском"
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = .customBackgroundColor

        return label
    }()

    private lazy var invalidConfirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Пароли должны совпадать"
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = .customBackgroundColor

        return label
    }()

    // MARK: - Functions

    var bottomSignUpButtonConstraint = NSLayoutConstraint()

    func setupUI() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        view.backgroundColor = .customBackgroundColor

        switchStackView.addArrangedSubview(self.getInfoLabel("Вы админ? Только честно 🥺"))
        switchStackView.addArrangedSubview(isAdminSwitch)
        
        stackView.addArrangedSubview(self.getInfoLabel("Почта"))
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(self.getInfoLabel("Пароль"))
        stackView.addArrangedSubview(passTextField)
        stackView.addArrangedSubview(self.getInfoLabel("Подтвердите пароль"))
        stackView.addArrangedSubview(confirmPassTextField)
        stackView.addArrangedSubview(switchStackView)
        stackView.addArrangedSubview(invalidPasswordLabel)
        stackView.addArrangedSubview(invalidConfirmPasswordLabel)
        
        stackView.setCustomSpacing(20, after: confirmPassTextField)
        

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false

        bottomSignUpButtonConstraint = signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            
            signUpButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),

            bottomSignUpButtonConstraint,
        ])
        
        self.view.layoutIfNeeded()

    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            UIView.animate(withDuration: 0.5, animations: {
                if #available(iOS 13.0, *) {
                    self.bottomSignUpButtonConstraint.constant = -height - 20
                } else {
                    self.bottomSignUpButtonConstraint.constant = -height - 3
                }
                self.view.layoutIfNeeded()
            })
        }
    }

    @objc private func keyboardWillHide(notification _: NSNotification) {
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomSignUpButtonConstraint.constant = -40
            self.view.layoutIfNeeded()
        })
    }

    @objc private func passwordTextFieldDidChange(_ textField: UITextField) {
        presenter?.passDidChange(to: textField.text ?? "")
        presenter?.confirmPassDidChange(to: confirmPassTextField.text ?? "", password: textField.text ?? "")

        if !isPassValid {
            invalidPasswordLabel.textColor = .systemRed
        } else {
            invalidPasswordLabel.textColor = .customBackgroundColor
        }
        if !isConfirmPassValid, isPassValid {
            invalidConfirmPasswordLabel.textColor = .systemRed
        } else {
            invalidConfirmPasswordLabel.textColor = .customBackgroundColor
        }
    }

    @objc private func passwordConfirmTextFieldDidChange(_ textField: UITextField) {
        presenter?.confirmPassDidChange(to: textField.text ?? "", password: passTextField.text ?? "")
        if !isConfirmPassValid {
            invalidConfirmPasswordLabel.textColor = .systemRed
            invalidPasswordLabel.layoutIfNeeded()
        } else {
            invalidConfirmPasswordLabel.textColor = .customBackgroundColor
        }
    }
    
    @objc private func signUpButtonPressed(_: UIButton) {
        self.signingUp = true
        presenter?.signUpTapped(email: emailTextField.text ?? "", password: passTextField.text ?? "")
    }

    func updateSignUpButton() {
        signUpButton.isEnabled = isPassValid && isConfirmPassValid && isEmailValid
    }
}

extension SignUpViewController: PresenterToViewSignUpProtocol {
    func updatePasswordValidation(isPassValid: Bool) {
        self.isPassValid = isPassValid
        self.updateSignUpButton()
    }

    func updateConfirmPasswordValidation(isConfirmPassValid: Bool) {
        self.isConfirmPassValid = isConfirmPassValid
        self.updateSignUpButton()
    }

    func updateEmailValidation(isEmailValid: Bool) {
        self.isEmailValid = isEmailValid
        self.updateSignUpButton()
    }
    
    func signUpSuccess() {
        self.signingUp = false
    }
    
    func signUpFailed() {
        self.signingUp = false
    }
}
