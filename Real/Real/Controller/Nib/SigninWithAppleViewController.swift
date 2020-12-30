//
//  SigninWithAppleViewController.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/26.
//

import FirebaseAuth
import AuthenticationServices
import CryptoKit

protocol SigninSuccessDelegate: AnyObject {
    
    func siginSuccess()
}

class SigninWithAppleViewController: BaseViewController {
    
    @IBOutlet weak var cancelImageView: UIImageView! {
        
        didSet {
            
            cancelImageView.enableTapAction(sender: self, selector: #selector(didTaptoCancel))
        }
    }
    
    @IBOutlet weak var signinButton: CustomizeButton! {
        
        didSet {
            
            signinButton.setup(cornerRadius: 25)
        }
    }
    
    weak var delegate: SigninSuccessDelegate?
    
    var currentNonce: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func performSignin() {
        
        let request = createAppleIDRequest()
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.delegate = self
        
        authorizationController.presentationContextProvider = self
        
        authorizationController.performRequests()
    }
    
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        let request = appleIDProvider.createRequest()
        
        request.requestedScopes = []
         
        let nonce = randomNonceString()
        
        request.nonce = sha256(nonce)
        
        currentNonce = nonce
        
        return request
    }
    
    func readUser(userId: String, handler: @escaping (Bool, User?) -> Void) {
        
        firebase.read(collectionName: .user, dataType: User.self) { (result) in
            
            switch result {
            
            case .success(let data):
                
                for user in data where user.id == userId {
                    
                    handler(true, user)
                }
                
                handler(false, nil)

            case .failure(let error):
                
                print("App delegate read user", error.localizedDescription)
            
            }
        }
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce

    private func randomNonceString(length: Int = 32) -> String {
        
        precondition(length > 0)
        
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        var result = ""
        
        var remainingLength = length
        
        while remainingLength > 0 {
            
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                
                var random: UInt8 = 0
                
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                
                if errorCode != errSecSuccess {
                    
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                
                return random
            }
            
            randoms.forEach { random in
                
                if remainingLength == 0 {
                    
                    return
                }
                
                if random < charset.count {
                    
                    result.append(charset[Int(random)])
                    
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }

    // Unhashed nonce.

    @available(iOS 13, *)

    private func sha256(_ input: String) -> String {
        
        let inputData = Data(input.utf8)
        
        let hashedData = SHA256.hash(data: inputData)
        
        let hashString = hashedData.compactMap {
            
            return String(format: "%02x", $0)
            
        }.joined()
        
        return hashString
    }
    
    @IBAction func signinWithApple(_ sender: UIButton) {
    
        performSignin()
    }
    
    @IBAction func openPrivacyPolicy(_ sender: UIButton) {
        
        let viewController = PrivacyPolicyViewController.loadFromNib()
        
        fatalError()
        
        present(viewController, animated: true, completion: nil)
    }
    
    @objc func didTaptoCancel() {
        
        self.dismiss(animated: true)
    }
}

extension SigninWithAppleViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let nonce = currentNonce else {
                
                fatalError("Invalid state: A login callback was received, but no login request was sent")
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                
                print("Unable to fetch identity token")
                
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            // 開始登入
            Auth.auth().signIn(with: credential) { (result, error) in
                
                // 由於使用者沒有登入的話，會有一個預設的帳號
                guard let user = result?.user, let defaultUser = UserDefaults.standard.string(forKey: .userID) else { return }
                
                // 使用登入成功後的 Auth 的 uid 去找 firebase 裡是否已經有資料
                self.readUser(userId: user.uid) { (isHaveData, userData) in
                    
                    // 如果有資料
                    if isHaveData {
                        
                        // 帶入到 userManager 以供後續使用
                        UserManager.shared.userData = userData!
                        
                        // 刪掉在 firebase 中預設的帳號
                        self.firebase.getCollection(name: .user).document(defaultUser).delete()
                        
                    } else {
                        
                        // 如果沒有資料，新建一筆一個 User
                        UserManager.shared.createUser(id: user.uid)
                    }
                    
                    // 刪除 UserDefaults 中的資料
                    UserDefaults.standard.remove(forKey: .userID)
                        
                    self.dismiss(animated: true) {
                        
                        self.delegate?.siginSuccess()
                    }
                }
            }
        }
    }
}

extension SigninWithAppleViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        guard let view = self.view, let window = view.window else {
            
            fatalError("view is nil with sign in with apple")
        }
        
        return window
    }
}
