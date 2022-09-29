//
//  MainViewController+MessagesListActionsView.swift
//

import AppKit

import NOFoundation

import lazyapi

extension MainViewController {
  
  typealias CoversationHistoryAction = (title: String, action: VoidCallback)
  
  func makeMessagesListActionsView(context: DiscordHTTPClient.Context) {
    
    makeContentBox(container: graphStackView,
                   value: .init(identifier: "MessageActionsView")) { view in
      
      let actions = [
        (title: "Delete messages", action: { [weak self] in
          
          guard let `self` = self else { return }
          
          self.deleteMessagesAction(context: context)
          
        }),
        (title: "Show messages", action: { [weak self] in
          
          guard let `self` = self else { return }
          
          MainViewController.messagesCount = .zero
          
          self.showMessagesAction(context: context)
        })
      ]
      
      view.actions = actions.compactMap( { .init(title: $0.title, value: $0) } )
      view.actionCallback = { actions in
        
        guard let action = actions.first?.value as? CoversationHistoryAction
        else { return }
        
        action.action()
      }
    }
  }
  
  static var messagesCount: Double = .zero
  
  func deleteMessagesAction(nextMessageID: String? = nil,
                            context: DiscordHTTPClient.Context) {
    
    guard let channelID = context.channelID else { return }
    
    let userName = context.userName
    
    self.discordHTTPClient.channelMessages(
      channelID: channelID,
      authKey: context.auth,
      nextMessageID: nextMessageID) { [weak self] messages in
        
        guard let `self` = self else { return }
        
        let mymessages = messages.filter( { $0.author.username == userName } ).filter({ $0.content?.isEmpty != true })
        let mymessagesIds = mymessages.compactMap({ $0.id })
        
        if mymessagesIds.isEmpty {
          
          if !messages.isEmpty {
            
            self.deleteMessagesAction(nextMessageID: messages.last?.id, context: context)
          }
          return
        }
        
        DispatchQueue.main.async { [weak self] in
          
          guard let `self` = self else { return }
          
          self.showMessagesView(context: context, messages: mymessages, unique: true)
        }
        
        self.deleteMessageAction(context: context,
                                 messagesIds: mymessagesIds) { [weak self] in
          
          guard let `self` = self else { return }
          
          if !messages.isEmpty {
            
            self.deleteMessagesAction(nextMessageID: messages.last?.id, context: context)
          }
        }
      }
  }
  
  func showMessagesAction(nextMessageID: String? = nil,
                          context: DiscordHTTPClient.Context) {
    
    guard let channelID = context.channelID else { return }
    
    let userName = context.userName
    
    self.discordHTTPClient.channelMessages(
      channelID: channelID,
      authKey: context.auth,
      nextMessageID: nextMessageID) { [weak self] messages in
        
        guard let `self` = self else { return }
        
        DispatchQueue.main.async { [weak self] in
          
          guard let `self` = self else { return }
          
          let mymessages = messages.filter( { $0.author.username == userName } )
          
          DispatchQueue.main.async { [weak self] in
            
            guard let `self` = self else { return }
            
            self.showMessagesView(context: context, messages: mymessages, unique: true)
          }
          
          if !messages.isEmpty {
            
            MainViewController.messagesCount += Double(mymessages.count)
            
            NOSTDOUT.display("Messages: \(MainViewController.messagesCount)")
            
            self.showMessagesAction(nextMessageID: messages.last?.id, context: context)
          }
        }
      }
  }
}
