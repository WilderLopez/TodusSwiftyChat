//
//  NavigationBarModifier.swift
//  toDus-SwiftUI
//
//  Created by Wilder Lopez on 1/26/21.
//  Copyright © 2021 iGhost. All rights reserved.
//

import UIKit
import SwiftUI

struct NavigationBarModifier: ViewModifier {
        
    var backgroundColor: UIColor?
    
    init( backgroundColor: UIColor?) {
        self.backgroundColor = backgroundColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        //this should be clear
        coloredAppearance.backgroundColor = UIColor(named: "NavigationBarBackgroundColor")
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor(named: "NavigationTinColor")]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = UIColor(named: "NavigationTinColor")

    }
    
    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}
