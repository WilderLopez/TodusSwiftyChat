//
//  ChatManager.swift
//  Todus-SwiftyChat
//
//  Created by Wilder Lopez on 2/8/21.
//

import Foundation
import Combine
import SwiftyChat


class ChatManager : ObservableObject{
    @Published var message : MockMessages.ChatMessageItem?
    @Published var oneMessage : MockMessages.ChatMessageItem?
    
    func receiveMessages(){
        for newMessage in TodusDataSource.mockMessages { 
        
            let randomTime = Int.random(in: 5000...10000)
        
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(randomTime)) { [self] in
                message = newMessage
            }
        }
    }
    
    func receiveOneMessage(){
        let index =  Int.random(in: 0...TodusDataSource.mockMessages.count-1)
        oneMessage = TodusDataSource.mockMessages[index]
    }
}
