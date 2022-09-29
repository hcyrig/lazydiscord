//
//  MainViewController+MessagesView.swift
//

import AppKit

import NOFoundation

import lazyapi

extension MainViewController {
  
  func showMessagesView(context: DiscordHTTPClient.Context,
                        messages: [DiscordHTTPAPIChannelMessages.Response],
                        unique: Bool = false) {
    
    let indentifier = "MessageHistoryView" + (unique ? .unique : .empty)
    
    makeContentBox(container: graphStackView,
                   value: .init(identifier: indentifier)) { view in
      
      view.actions = messages.compactMap( { .init(title: $0.content ?? .empty,
                                                  value: $0) } )
      view.actionCallback = { [weak self] tags in
        
        guard let `self` = self else { return }
        
        guard let message = tags.first?.value as? DiscordHTTPAPIChannelMessages.Response else {
          return
        }
        
        self.deleteMessageAction(context: context,
                                 message.id,
                                 callback: {})
      }
    }
  }
}
