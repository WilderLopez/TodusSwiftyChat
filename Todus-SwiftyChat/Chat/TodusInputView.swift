//
//  TodusInputView.swift
//  toDus-SwiftUI
//
//  Created by Wilder Lopez on 10/19/20.
//  Copyright © 2020 iGhost. All rights reserved.
//

import SwiftUI
import SwiftyChat

public struct TodusInputView: View, InputViewProtocol {
    
    public var sendAction: (ChatMessageKind) -> Void
    @Binding var scrollToBottom : Bool
    
    public init(sendAction: @escaping (ChatMessageKind) -> Void, scrollToBottom: Binding<Bool>, isRecording: Binding<Bool>) {
        self.sendAction = sendAction
        self._scrollToBottom = scrollToBottom
        self._startRecording = isRecording
    }
    
    private let mainContainerHeight: CGFloat = 30
    
    @State private var textfield: String = ""
    @State private var isKeyboardActive: Bool = false
    
    @State private var presentCameraSheet: Bool = false
    @State private var moreActionSheet: Bool = false
    
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    @State private var isCameraSelected = false
    @State private var selectedImg : UIImage?
    
    
    
    public var body: some View {
        VStack(spacing: 0){
//            Divider()
            HStack(spacing: 16){
//                if !changeStructure{
                ZStack{
                    HStack(spacing: 16){
                    moreButton
                    inputField
                    }.transition(.move(edge: .bottom))
                    .offset(y: changeStructure ? 300 : 0)
//                }else {//MARK: Recording Structure
                    recordingStructure
                        .transition(.move(edge: .top))
                        .offset(y: !changeStructure ? 300 : 0)
                }
//                }
    //            cameraButton
//                if isKeyboardActive{
                    sendButton
//                }
            }
            .frame(minHeight: mainContainerHeight)
            .padding(.vertical, 8)
            .background(
                Color.InputMessageBackgroundColor.sheet(isPresented: $presentCameraSheet, onDismiss: {
                    if self.selectedImg != nil {
                        print("image was selected")
                        sendAction(.image(.local(self.selectedImg!)))
//                        self.messagetype = .photo
//                        self.sendMessage()
                    }
                }) {
                    CaptureImageView(isShown: $presentCameraSheet, image: $selectedImg, isCamera: $isCameraSelected)
    //                ImagePicker(sourceType: sourceType) { (image) in
    //                    self.sendAction(.image(.local(image)))
    //                }
                }
            )
            
            .accentColor(.primaryTodusColor)
        
//        .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { (_) in
            withAnimation {
                isKeyboardActive = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { (_) in
            if isKeyboardActive && startRecording {
//                self.endEditing(false)
            }else {
                withAnimation(.easeOut(duration: 0.1)) {
                    isKeyboardActive = false
                }
            }
        }
        .actionSheet(isPresented: $moreActionSheet) { () -> ActionSheet in
            ActionSheet(title: Text("Enviar ..."), buttons: [
                .default(Text("Cámara"), action: {
                    print("from Camera")
                    presentCameraSheet.toggle()
                    isCameraSelected = true
                }),
                .default(Text("Foto"), action: {
                    print("from galery")
                    presentCameraSheet.toggle()
                    isCameraSelected = false
                }),
                .default(Text("Archivo"), action: {
                    print("from file")
                }),
                .default(Text("Ubicación"), action: {
                    print("from location map")
                }),
                .default(Text("Contacto"), action: {
                    print("from contacts")
                }),
                .cancel(Text("Cancelar"))
            ])
        }
    }
    
    // MARK: - Input Field
    private var inputField: some View {
//        TextField("Type..", text: $textfield)
        MultilineTextField("Mensaje",text: $textfield)
            .padding(.horizontal, 12)
            .background(
                ZStack{
                    Color.InputMessageBackgroundColor
                    
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.primary.opacity(0.2))
                        .padding(2)
                        
                }.clipped()
            )
            .padding(.vertical , -2)
            .cornerRadius(20)
            
            
            .onTapGesture {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                    self.scrollToBottom = true
                    print("🍽")
                }
            }
//        .foregroundColor(.white)
//        .padding(.horizontal, 12)
//        .padding(.vertical, 6)
//        .background(Color(#colorLiteral(red: 0.2663825154, green: 0.2648050189, blue: 0.2675990462, alpha: 1)))
//        .clipShape(Capsule())
//        .overlay(
//            Capsule()
//                .stroke(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), lineWidth: 1)
//        )
//        .frame(height: mainContainerHeight * 0.7)
    }
    
    
    //MARK: - Drag Gesture
    private var dragMicroUp: some Gesture{
        DragGesture().onChanged({ (value) in
//                print("translation: \(value.translation)")
            print("position: \(value.location)")
            
            if value.location.y >= -100 && !isCancelRecordingAudio && value.location.y <= 0 && !isAncleRecordingAudio{//por debajo de TOP
                positionDrag = value.location
            }else if !isCancelRecordingAudio && value.location.y < -100 && !isAncleRecordingAudio && (value.location.x >= -40 && value.location.x < 50){//por encima de TOP
                isAncleRecordingAudio = true
                positionDrag = value.location
                //vibrar success anclado
                print("📦")
            }
            if !isCancelRecordingAudio && value.location.x <= -40 && !isAncleRecordingAudio{
                cancelRecordingAudio()
                print("🐣")
                //vibrar cancel
            }
            }).onEnded({ (isDragEnd) in
                if (positionDrag.y > -100 || positionDrag.y > 0) && !isAncleRecordingAudio{
                    //like Cancelar Event
                    print("height < 100 ->> \(positionDrag.y)")
                    print("status:\n isAncle >>  \(isAncleRecordingAudio)\n isCancel >> \(isCancelRecordingAudio)")
                    cancelRecordingAudio()
                    isCancelRecordingAudio = false
                }
        })
    }
    //MARK: - Long Press Gesture
    private var longpress: some Gesture {
        LongPressGesture(minimumDuration: 0.3)
        .onEnded({ (isEndFirst) in
        print("is end First > \(isEndFirst)")
        withAnimation(.linear(duration: 0.1)) {
            changeStructure = true
        }
        bigMicro = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            startRecording = bigMicro ? true : false
            print("Start Recording")
        }
      })
    }
    
    // MARK: - Send Button
    private func cancelRecordingAudio(){
        bigMicro = false
        changeStructure = false
        startRecording = false
        isAncleRecordingAudio = false
        isCancelRecordingAudio = true
        positionDrag = CGPoint(x: 0, y: 0)
        timerCounter = 0
    }
    @State private var bigMicro = false
    @State private var changeStructure = false
    @Binding var startRecording : Bool
    @State private var  isCancelRecordingAudio = false
    @State private var positionDrag = CGPoint(x: 0, y: 0)
    private var sendButton: some View {
        
        ZStack(alignment: .center){
            
            if bigMicro{
                ZStack(alignment: .center){
                    Image(systemName: !isAncleRecordingAudio ? "lock.open" : "lock")
                    .font(.system(size: 20))
                    .frame(width: 30, alignment: .center)
                }.background(
                    Capsule().frame(width: 30, height: 50, alignment: .center)
                        .foregroundColor(Color.black.opacity(0.3))
                )
                .offset(x: 0, y: -130)
                .foregroundColor(Color.primaryTodusColor)
            
                Image(systemName: "arrow.up")
                    .font(.system(size: 20, weight: .bold, design:.default))
                    .offset(y: isAncleRecordingAudio ? 0 : positionDrag.y)
                    .foregroundColor(.primaryTodusColor)
//                    .animation(Animation.linear(duration: 0.1))
            
            }
            
            
            Button(action: {
                print("microphone pressed")
                withAnimation(.linear(duration: 0.1)) {
                    cancelRecordingAudio()
                    isCancelRecordingAudio = false
                }
            }) {
                Image(systemName: isAncleRecordingAudio ? "arrow.up" : "mic").resizable()
                    .frame(width: !textfield.isEmpty ? 0 : 15, height: !textfield.isEmpty ? 0 : 25, alignment: .center)
                    .foregroundColor(bigMicro ? .white : .primaryTodusColor)
                    .background(
                        ZStack{
                            if bigMicro{
                                Circle().foregroundColor(Color.primaryTodusColor)
                            .frame(width: bigMicro ? 80 : 0, height: bigMicro ? 80 : 0, alignment: .center)
                                    
                            Circle().foregroundColor(Color.primaryTodusColor.opacity(startRecording ? 0 : 0.7))
                                .frame(width: 80, height: 80, alignment: .center)
                                .scaleEffect(startRecording ? 2 : 1)
                                .animation(Animation.linear(duration: 0.9)
                                            .delay(0.2).repeat(while: startRecording, autoreverses: false)
//                                .repeatForever(autoreverses: false)
                                )
                            }
                        }
                    )
            }.buttonStyle(VoiceRecorderButtonStyle())
            .simultaneousGesture(longpress)
            .simultaneousGesture(dragMicroUp)
            
            Button(action: {
                let trimmedString = textfield.trimmedString()
                if trimmedString != ""{
                self.sendAction(.text(trimmedString))
                textfield.removeAll()
                textfield = ""
                }
                print("Send 🐮")
            }) {
            Image(systemName: "arrow.up")
            .resizable()
                .frame(width: textfield.isEmpty ? 0 : 16, height: textfield.isEmpty ? 0 : 18, alignment: .center)
                .foregroundColor(.white)
                .padding(.horizontal, 2)
                .background(Circle()
                    .frame(width: textfield.isEmpty ? 0 : 30, height: textfield.isEmpty ? 0 : 30, alignment: .center)
                    .foregroundColor(.primaryTodusColor)
            )
        }

        }.frame(width: 35, alignment: .center)
        
//        Button(action: {
//            print("send tapped")
//            sendAction(.text(textfield))
//            textfield.removeAll()
//        }) {
//
//            Image(systemName: "paperplane.fill")
//                .resizable()
//                .scaledToFit()
//                .foregroundColor(.blue)
//                .frame(height: 20)
//                .padding(6)
//                .background(Color.white)
//                .clipShape(Circle())
//
//        }
//        .animation(.linear(duration: 0.1))
        .padding(.leading, 0)
        .padding(.trailing, 16)
    }
    
    // MARK: - Camera Button
    private var cameraButton: some View {
        Button(action: {
            print("camera tapped")
            presentCameraSheet = true
        }) {
            Image(systemName: "camera")
                .resizable()
                .scaledToFit()
                .foregroundColor(.blue)
                .frame(width: 24)
            
        }.padding(.trailing, 16)
    }
    
    // MARK: - More Button
    private var moreButton: some View {
        Button(action: {
            print("plus tapped")
            moreActionSheet = true
        }) {
            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
//                .foregroundColor(.blue)
                .frame(height: 20)
            
        }.padding(.leading, 16)
    }
    
    
    //MARK: - Recording Structure
    @State var isAncleRecordingAudio = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timerCounter = 0
    private var recordingStructure: some View {
        HStack{
            //0:00:00 timer
            Text(String.timeString(time: TimeInterval(timerCounter)))
                .onReceive(timer, perform: { _ in
                    if startRecording{
                        timerCounter += 1
                    }
                })
            Spacer()
            if isAncleRecordingAudio{
            Button("Cancelar"){
                print("Cancelar audio recorder with button")
                cancelRecordingAudio()
                isCancelRecordingAudio = false
                textfield = ""
            }
            }else {
                HStack{
                Image(systemName: "chevron.left")
                Text("Cancelar")
                }
            }
            Spacer()
        }.padding(.horizontal, 16)
    }
    
}

struct TodusInputView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.primaryBubble
        TodusInputView(sendAction: { (kind) in
            
        }, scrollToBottom: .constant(false), isRecording: .constant(false))
        
        }
//        .previewLayout(PreviewLayout.fixed(width: 400, height: 400))
    }
}

struct VoiceRecorderButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.primaryTodusColor)
    }
}
