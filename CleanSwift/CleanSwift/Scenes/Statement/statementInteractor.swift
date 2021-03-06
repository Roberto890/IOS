//
//  statementInteractor.swift
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

protocol statementBusinessLogic
{
  func doSomething(request: statement.Something.Request)
}

protocol statementDataStore
{
  //var name: String { get set }
}

class statementInteractor: statementBusinessLogic, statementDataStore
{
  var presenter: statementPresentationLogic?
  var worker: statementWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: statement.Something.Request)
  {
    worker = statementWorker()
    worker?.doSomeWork()
    
    let response = statement.Something.Response()
    presenter?.presentSomething(response: response)
  }
}
