//
//  MainViewController+ChannelsListView.swift
//

import AppKit

import NOFoundation

import lazyapi

extension MainViewController {
  
  func showMeChannelsAction(context: DiscordHTTPClient.Context) {
    
    self.discordHTTPClient.userChannels(authKey: context.auth) { [weak self] response in
      
      guard let `self` = self else {return }
      
      let channelsIDS = response.compactMap({ $0.id })
      
      DispatchQueue.main.async { [weak self] in
        
        guard let `self` = self else { return }
        
        self.makeChannelsListView(context: context,
                                  channels: channelsIDS)
      }
    }
  }
  
  func makeChannelsListView(context: DiscordHTTPClient.Context,
                            channels: [String]) {
    
    makeContentBox(container: graphStackView,
                   value: .init(identifier: "ChannelsListView")) { view in
      
      view.actions = channels.compactMap({ .init(title: $0,
                                                value: $0) })
      
      view.actionCallback = { [weak self] values in
        
        guard let `self` = self else {return }
        
        self.channelMessagesActions(
          context: context,
          channels: values.compactMap( { $0.value as? String }))
      }
    }
  }
  
  func channelMessagesActions(context: DiscordHTTPClient.Context,
                              channels: [String]) {
    
    guard let channelID = channels.first else { return }
    
    context.channelID = channelID
    
    makeMessagesListActionsView(context: context)
  }
}
