//
//  Chat.swift
//  Todus-SwiftyChat
//
//  Created by Wilder Lopez on 2/8/21.
//

import SwiftUI
import SwiftyChat
import UIKit

struct Chat: View {
    @EnvironmentObject var chatManager : ChatManager
    @State var oneMessage : MockMessages.ChatMessageItem?
    @State var messages: [MockMessages.ChatMessageItem] = []
    @State var onAppearMessage = MockMessages.ChatMessageItem(securityID: "nil", user: MockMessages.ChatUserItem(userName: "nil"), messageKind: .text("nil"))
    
    @State var scrollToBottom : Bool = false
    @State var isBottomArea = false
    @State var startRecording = false
    @State var canDismissKeyboard = false
    @State var refreshOldMessages = false
    @State var currentPagination = 0
    @State var canRefresh = true
    @State var lastMessageInScrollPosition : UUID = UUID()
    
    @State var isBlocked : Bool = false
    
    @State var loading = false
    @State var delBlockId = ""
    @State var showAlert = false
    
    @State var isKeyboardActive = false
    
    @State var fixedWidth : CGFloat = 0.0
    @State var canScrollDown : Bool = true
    
    var body: some View {
//        UITableView.appearance().keyboardDismissMode = .interactive
        return ZStack(alignment: .top){
            GeometryReader{ proxy in
//                VStack(spacing: 0){
                chatview
                .background(
                    //bg_portrait
                    //Background-ChatView
                        Image("gb-ChatView")
                            .resizable()
                            .scaledToFill()
                            .frame(width: proxy.size.width, height: UIScreen.main.bounds.height - 35)
                            .edgesIgnoringSafeArea(.all)
                            .background(Color.InputMessageBackgroundColor)
//                            .foregroundColor(.ForengroundBackColor)
                            )
                    
                    .ignoresSafeArea(.all, edges: .bottom)
                    .padding(.bottom, isKeyboardActive ? 0 : proxy.safeAreaInsets.bottom - 33 > 0 ? proxy.safeAreaInsets.bottom - 33 : 0)
                    .animation(nil)
                    
                
                .onTapGesture {
                    if !startRecording {
                        self.endEditing(true)
                    }
                }
                    .onAppear{
                        
                        //MARK: Simulate receive messages
                        chatManager.receiveMessages()
                        
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { (_) in
//                    withAnimation {
                        isKeyboardActive = true
//                    print("Keyboard x1: \(proxy.size.height)")
//                    fixedWidth = max(self.fixedWidth, proxy.size.height)
//                    print("max heigt x1: \(fixedWidth)")
//                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { (_) in
                    if isKeyboardActive && startRecording {
        //                self.endEditing(false)
                    }else {
//                        withAnimation(.easeOut(duration: 0.1)) {
                            isKeyboardActive = false
//                        print("Keyboard x2: \(proxy.size.height)")
//                        fixedWidth = max(self.fixedWidth, proxy.size.width)
//                        print("max heigt x2: \(fixedWidth)")
//                        }
                    }
                }
                //Recibir todos los mensajes
                .onReceive(chatManager.$message) { (newMessage) in
                    if newMessage != nil {
                        messages.append(newMessage!)
                        //bajar solo si estoy en bottom
                        if canScrollDown{
                            canScrollDown.toggle() //setting false
                            scrollToBottom = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                                canScrollDown.toggle()//setting true
                            })
                        }
                    }
                }
                    
            }
        }
    }
    
    
    
    private var chatview: some View {
        ChatView<MockMessages.ChatMessageItem, MockMessages.ChatUserItem>(messages: $messages, onAppearMessage: $onAppearMessage, scrollToBottom: $scrollToBottom, isBottom: $isBottomArea, refreshOldMessages: $refreshOldMessages, IDToScrollMove: $lastMessageInScrollPosition){
            
            // InputView here, continue reading..
            VStack(spacing: 0){
                if !isBottomArea {
                    HStack{
                        Spacer()
                    Button(action: {
                        scrollToBottom = true
                    }){
                        Image(systemName: "chevron.down")
                            .font(.system(size: 20))
                            .padding(8)
                            .background(Color.primaryTodusColor)
                            .foregroundColor(.white)
                            .clipShape(Circle())

                    }
                    }.padding([.trailing, .bottom], 5)
                }
                
                if isBlocked{
                    blockedView
                    .frame(height: 40, alignment: .center)
                    .background(Color.white)
                }else {
                    
                //MARK: - Todus InputView
                TodusInputView(sendAction: { (messageKind) in
                let id = UUID().uuidString.lowercased()
                let date = Date()
//                let time = Int64 (date.millisecondsSince1970)
                let newMessage = MockMessages.ChatMessageItem(
                    securityID: id, user: MockMessages.ChatUserItem(userName: "iGhost"),
                    messageKind: messageKind,
                    isSender: true,
                    date: date)
                    
                    
                    //add action to move scroll
                    DispatchQueue.main.async {
                        
                        messages.append(newMessage)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10), execute: {
                        scrollToBottom = true
                        
                    })

            }
                , scrollToBottom: $scrollToBottom, isRecording: $startRecording)
                }
                                
            }
            
            .edgesIgnoringSafeArea(.all)
            .embedInAnyView()
        }
        .environmentObject(ChatMessageCellStyle())
        
    }
    
    
    private var blockedView: some View{
        HStack{
            Spacer()
            Button {
                print("desbloquear")
                showAlert = true
            } label: {
                Text("Desbloquear").bold().foregroundColor(.primaryTodusColor)
            }.alert(isPresented: $showAlert) { () -> Alert in
                Alert(title: Text("Desbloquear contacto"), primaryButton: .default(Text("Desbloquear"), action: {
//                        TodusDefaults.delBlockUser(blockedUser: selectedContact.coredataInfo!.username)
//                    delBlockId = UUID().uuidString.lowercased()
//                    chatManager.streamManager?.xmppController.delBlock(id: delBlockId, to: GenericRoom(room: (chatManager.streamManager?.currentRoom)!).getJID())
                    
                }), secondaryButton: .cancel(Text("Cancelar")))
            }
            
            
//            if loading {
//                LoadingUIKit()
//            }
            Spacer()
        }
    }
}

struct Chat_Previews: PreviewProvider {
    static var previews: some View {
        Chat()
    }
}
