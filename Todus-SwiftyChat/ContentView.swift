//
//  ContentView.swift
//  Todus-SwiftyChat
//
//  Created by Wilder Lopez on 2/8/21.
//

import SwiftUI
import SwiftyChat

struct ContentView: View {
    @EnvironmentObject var chatManager : ChatManager
    @State var oneMessage : MockMessages.ChatMessageItem?
    var body: some View{
        NavigationView{
            Chat(oneMessage: oneMessage)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Button {
                            print("Show profile Info")
//                            showProfileInfo = true
//                            infoShowed = true
                        } label: {
                            
                            VStack{
                                Text("iGhost Z17")
                                    .bold()
                                Text("description")
//                                Text(lastDescription == "..." ? "" : "\(lastDescription)").font(.system(size: 13))
                            }
                            
                        }.accentColor(.white)
                        
                    }
                }
                .navigationBarItems(trailing:
                                        Button(action: {
                                            chatManager.receiveOneMessage()
                                        }, label: {
                                            Text("One More")
                                        })
                )
                .navigationBarColor(UIColor(named: "NavigationBarBackgroundColor"))
                .onReceive(chatManager.$oneMessage) { (newMessage) in
                    if newMessage != nil {
                        oneMessage = newMessage
                        print(oneMessage?.messageKind)
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
