//
//  TLPhoneConnector.swift
//  Runner
//
//  Created by 林 明虎 on 2024/10/05.
//

import SwiftUI
import WatchConnectivity


class TLPhoneConnector: NSObject, ObservableObject, WCSessionDelegate  {
    static let shared = TLPhoneConnector()
    
    @Published var workspaces: [TLWorkspace]?
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            
            WCSession.default.activate()
        }
    }
    
    // iPhoneへデータを送信するメソッド
    func sendMessageToPhone(_ data: [String: Any]) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(data, replyHandler: nil) { error in
                print("Error sending message: \(error.localizedDescription)")
            }
        } else {
            print("iPhone is not reachable")
        }
    }
    
    // --- session
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith state= \(activationState.rawValue)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("didReceiveMessage: \(message)")
        
        // 受け取ったメッセージを取り出す
        if let receivedMessage = message["message"] as? String {
            //結果を画面に反映
            print(receivedMessage)
            DispatchQueue.main.async {
                //                self.counter = resultOfCount
            }
        }
        
    }
}