//
//  ButterBot.swift
//  butterbot
//
//  Created by Allan Vialatte on 10/03/2018.
//

import Foundation
import SlackKit
import MySQL

class ButterBot {
  let database: Database
  let slackKit: SlackKit
  let features: [Feature]
  
  init() throws {
    let env = try Environment()

    self.database = Database(with: env)
    self.slackKit = SlackKit()
    self.features = [Karma(with: database)]

    slackKit.addRTMBotWithAPIToken(env.slackBotToken)
  }
  
  func listen(event:EventType) {
    self.slackKit.notificationForEvent(.message) { [weak self] (event, clientConnection) in
      guard let this = self, let client = clientConnection else { return }
      this.features.forEach { $0.eventReceive(event: event, client: client) }
    }
  }
}
