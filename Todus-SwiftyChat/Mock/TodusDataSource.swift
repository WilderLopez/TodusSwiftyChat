//
//  TodusDataSource.swift
//  Todus-SwiftyChat
//
//  Created by Wilder Lopez on 2/8/21.
//

import Foundation
import SwiftyChat
import UIKit

struct TodusDataSource {
    static var mockMessages = [
        MockMessages.ChatMessageItem(
            securityID: UUID().uuidString, user: MockMessages.ChatUserItem(userName: "iGhost"),
            messageKind: .text("Hola que tal 🤓"),
            isSender: false,
            date: Date()),
        MockMessages.ChatMessageItem(
            securityID: UUID().uuidString, user: MockMessages.ChatUserItem(userName: "iGhost"),
            messageKind: .text("Este es un ejemplo de como seria el chat de todus."),
            isSender: false,
            date: Date()),
        MockMessages.ChatMessageItem(
            securityID: UUID().uuidString, user: MockMessages.ChatUserItem(userName: "iGhost"),
            messageKind: .text("Verifica que siempre que llegan mensajes el scroll se desplaza lento."),
            isSender: false,
            date: Date()),
        MockMessages.ChatMessageItem(
            securityID: UUID().uuidString, user: MockMessages.ChatUserItem(userName: "iGhost"),
            messageKind: .text("Segun las investigaciones debe ser alguna animacion mal empleada."),
            isSender: false,
            date: Date()),
        MockMessages.ChatMessageItem(
            securityID: UUID().uuidString, user: MockMessages.ChatUserItem(userName: "iGhost"),
            messageKind: .text("He revisado un monton de cosas pero no he tenido tiempo suficiente para ello"),
            isSender: false,
            date: Date())
    ]
}
