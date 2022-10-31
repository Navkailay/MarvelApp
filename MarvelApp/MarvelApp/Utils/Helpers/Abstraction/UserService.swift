//
//  UserService.swift
//  GroceryApp
//
//  Created by Navpreet Kailay on 29/09/22.
//

import Foundation

typealias ResultClouser<T> = (Result<T, Error>) -> Void

//protocol SignupService {
//    func registerUser(account: Account, completion: @escaping (ResultClouser<UserViewModel>))
//}
//
//protocol LoginService {
//    func loginUser(account: Account) -> DecodedFuture<LoginModel>
//}
