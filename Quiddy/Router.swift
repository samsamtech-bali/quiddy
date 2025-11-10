//
//  Router.swift
//  Quiddy
//
//  Created by stephan on 07/11/25.
//

import Foundation
import SwiftUI

enum Route: Hashable {
    case usernameView
    case ciggerateView
    case priceView
    case successView
    case pageOne
}

final class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    static let shared = Router()
    
    private init() {
        
    }
}
