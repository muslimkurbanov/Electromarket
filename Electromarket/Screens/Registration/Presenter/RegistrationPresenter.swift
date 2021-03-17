//
//  ProductPresenter.swift
//  Electromarket
//
//  Created by Муслим Курбанов on 17.01.2021.
//

import Foundation

protocol RegistrationPresenterProtocol : class{
    init(view: ProductViewProtocol)
}

class RegistrationPresenter: RegistrationPresenterProtocol {
    
    private weak var view: ProductViewProtocol?
    
    required init(view: ProductViewProtocol) {
        self.view = view
    }
  
}
