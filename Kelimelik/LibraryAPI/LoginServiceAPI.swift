//
//  LoginServiceAPI.swift
//  Kelimelik
//
//  Created by Belma İbrahimbaş on 21.11.2017.
//  Copyright © 2017 Belma Ibrahimbas. All rights reserved.
//

import Foundation

final class LoginService {
   
    private let loginManager = LoginManager()
    static let sharedInstance = LoginService()
    
    private init() {}
    
    //TODO: Login bilgisi database de saklanacak ! Oda oluştururken request sonrası eşleştirme yapılırken kullanıcıların logon durumları kontrol edilecek.
    
    func checkIfUserLoggedIn() -> Bool {
        return loginManager.checkIfUserLoggedIn()
    }
    
    
    
    func UserLogin(loginMethod: LoginMethod, completed: @escaping (LoginResult) -> Void) {
        switch loginMethod {
        case LoginMethod.Facebook:
            loginManager.LoginWithFB {
                self.loginManager.getFBUserProfile {
                    self.loginManager.LoginExistingUser(completed: { (result) in
                        completed(LoginResult.LoginOk)
                    })
                    completed(LoginResult.LoginOk)
                }
            }
        case LoginMethod.Guest:
            loginManager.guestUserLogin()
            completed(LoginResult.LoginOk)
        case LoginMethod.Email:
            loginManager.LoginExistingUser(completed: { (result) in
                if(result == GetUserFromDBResult.NoUserFound) {
                    completed(LoginResult.NoUserFound)
                }
                else if(result == GetUserFromDBResult.UserFound) {
                    completed(LoginResult.LoginOk)
                }
            })
        default:
            print("xx")
        }
    }
    
}
