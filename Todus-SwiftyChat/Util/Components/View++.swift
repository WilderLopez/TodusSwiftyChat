//
//  View++.swift
//  toDus-SwiftUI
//
//  Created by Wilder Lopez on 9/3/20.
//  Copyright © 2020 iGhost. All rights reserved.
//

import SwiftUI

extension View{
    func embedInAnyView() -> AnyView {
        return AnyView(self)
    }
    
    func endEditing(_ force: Bool) {
        UIApplication.shared.windows.forEach { $0.endEditing(force)}
    }
}

//extension UIApplication {
//    func endEditing(_ force: Bool) {
//        self.windows
//            .filter{$0.isKeyWindow}
//            .first?
//            .endEditing(force)
//    }
//}

//struct ResignKeyboardOnDragGesture: ViewModifier {
//    var gesture = DragGesture().onChanged{_ in
//        UIApplication.shared.endEditing(true)
//    }
//    func body(content: Content) -> some View {
//        content.gesture(gesture)
//    }
//}
//
//extension View {
//    func resignKeyboardOnDragGesture() -> some View {
//        return modifier(ResignKeyboardOnDragGesture())
//    }
//}

//if-else
extension View {
  @ViewBuilder
  func `if`<TrueContent: View, FalseContent: View>(
    _ condition: Bool,
    if ifTransform: (Self) -> TrueContent,
    else elseTransform: (Self) -> FalseContent
  ) -> some View {
    if condition {
      ifTransform(self)
    } else {
      elseTransform(self)
    }
  }
}


//if
extension View {
  @ViewBuilder
  func `if`<Transform: View>(
    _ condition: Bool,
    transform: (Self) -> Transform
  ) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }
}

//ifLet
//extension View {
//  @ViewBuilder
//  func ifLet<V, Transform: View>(
//    _ value: V?,
//    transform: (Self, V) -> Transform
//  ) -> some View {
//    if let value = value {
//      transform(self, value)
//    } else {
//      self
//    }
//  }
//}

//MARK: Annimation Extension
extension Animation {
    func `repeat`(while expression: Bool, autoreverses: Bool = true) -> Animation {
        if expression {
            return self.repeatForever(autoreverses: autoreverses)
        } else {
            return self
        }
    }
}

extension View {
    dynamic func dismissKeyboardOnTappingOutside(force: Bool = true) -> some View {
        print("inside force :\(force)")
        return ModifiedContent(content: self, modifier: DismissKeyboardOnTappingOutside(endEditing: force))
    }
    
    func navigationBarColor(_ backgroundColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor))
    }
}

public struct DismissKeyboardOnTappingOutside: ViewModifier {
    var endEditing : Bool
    public func body(content: Content) -> some View {
        content
            .onTapGesture {
                print("in tap editing: \(endEditing)")
                let keyWindow = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .map({$0 as? UIWindowScene})
                        .compactMap({$0})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first
                keyWindow?.endEditing(endEditing)
        }
    }
}

