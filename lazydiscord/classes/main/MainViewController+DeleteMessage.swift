//
//  MainViewController+DeleteMessage.swift
//

import AppKit

import NOFoundation

import lazyapi

extension MainViewController {
  
  func deleteMessageAction(context: DiscordHTTPClient.Context,
                           _ messageID: String,
                           callback: @escaping VoidCallback) {
    
    guard let channelID = context.channelID else { return }
    
    discordHTTPClient.channelDeleteMessage(
      channelID: channelID,
      messageID: messageID,
      authKey: context.auth,
      responseCallback: { response in
        
        switch response {
          
        case .failure(_, _):
          NOSTDOUT.display("NOT Removed \(messageID) message")
        case .success(_, _):
          NOSTDOUT.display("Removed \(messageID) message")
        }
        
        callback()
      })
  }
  
  func deleteMessageAction(context: DiscordHTTPClient.Context,
                           messagesIds: [String],
                           callback: @escaping VoidCallback) {
    
    guard let channelID = context.channelID else {
      callback()
      return
    }
    
    if messagesIds.isEmpty {
      callback()
      return
    }
    
    var messagesIds = messagesIds
    let messageId = messagesIds.removeLast()
    
    discordHTTPClient.channelDeleteMessage(
      channelID: channelID,
      messageID: messageId,
      authKey: context.auth,
      responseCallback: { [weak self] response in
        
        guard let `self` = self else { return }
        
        switch response {
            
          case .failure(_, _):
            NOSTDOUT.display("NOT Removed \(messageId) message")
          case .success(_, _):
            NOSTDOUT.display("Removed \(messageId) message")
        }
        
        sleep(8)
        
        self.deleteMessageAction(context: context,
                                 messagesIds: messagesIds, callback: callback)
      })
  }
}
