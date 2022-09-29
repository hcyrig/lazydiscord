//
//  MainViewController.swift
//

import AppKit

import NOFoundation

import lazyapi

class MainViewController: BaseViewController {
  
  @IBOutlet weak var graphStackView: NSStackView!
  @IBOutlet private weak var musicButton: NSButton!
  
  var discordHTTPClient: DiscordHTTPClient!
  var soundtrackPlayer = SoundtrackPlayer()
  
  var chainOfContent: NOLazyList?
  
  override func setupInterface() {
    super.setupInterface()
    
    musicButton.state = .off
    
    self.discordHTTPClient = DiscordHTTPClient(context: .init(
      auth: "YOUR_API_KEY",
      userName: "USERNAME"
      ))
    
    chainOfContent = .init(value: .init(identifier: "init", values: [.init(value: NSView())]))
    
    showMeChannelsAction(context: discordHTTPClient.context)
  }
}

extension MainViewController {
  
  public func makeContentBox(
    container: NSStackView,
    value: NOLazyValue,
    viewBoxClosure: SetValueCallback<NOActionsView>) {
      
      var value = value
      
      chainOfContent?.removeTail(value)
      
      let separatorView = NSBox()
      separatorView.boxType = .separator
      container.addArrangedSubview(separatorView)
      
      let view = NOActionsView()
      view.viewWidthCallback = { [weak container] in
        
        guard let container = container else { return .zero }
        
        return container.frame.size.width
      }
      viewBoxClosure(view)
      container.addArrangedSubview(view)
      
      value.values = [
        .init(value: separatorView),
        .init(value: view)
      ]
      chainOfContent?.addNode(value)
    }
}
