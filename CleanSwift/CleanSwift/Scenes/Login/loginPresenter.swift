//
//  loginPresenter.swift
//  CleanSwift
//
//  Created by Virtual Machine on 14/09/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol loginPresentationLogic{
    func presentSomething(response: login.Login.Response)
    func presentSomethingError(response: login.Login.Response)
}

class loginPresenter: loginPresentationLogic
{
    
    
    weak var viewController: loginDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: login.Login.Response){
        let viewModel = login.Login.ViewModel(user: response.user)
        viewController?.displaySomething(viewModel: viewModel)
    }
    func presentSomethingError(response: login.Login.Response) {
        print("aaa")
    }
}