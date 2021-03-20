//
//  AIPlayerView.swift
//  HwHoldem
//
//  Created by falcon on 2021/3/20.
//

import SwiftUI

enum SeatPosition{
  case left
  case right
}

struct AIPlayerView: View {
  let SeatPosition: SeatPosition
  @State var rotation: Double = 0
  @State var topPadding: CGFloat = -50
  @State var topPaddingType: Edge.Set = .leading
  
  @Binding var player: Player
  @State var playerName: String = "Player"
  @State var playerRole: String = "Role"
  var showdown: Bool = false
  
  var body: some View{
    HStack{
      if(SeatPosition == .right){
        Text("\(playerName) $\(player.chip)\n\(player.role.description)").rotationEffect(.degrees(rotation)).padding(topPaddingType, topPadding / 2)
      }
      HStack{
        
        VStack{
          ForEach( player.cards, id: \.point ){ (card) in
            ZStack{
              Image(card.getFrontAsset(.blank))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .rotationEffect(.degrees(rotation))
                .padding(0)
              if(showdown){
                Image(card.getFrontAsset(.front))
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .rotationEffect(.degrees(rotation))
                  .padding(0)
              }
              else{
                Image(card.getFrontAsset(.back))
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .rotationEffect(.degrees(rotation))
                  .padding(0)
              }
            }
          }
        }
      }.aspectRatio(contentMode: .fit).padding(0)
      if(SeatPosition == .left){
        Text("\(playerName) $\(player.chip)\n\(player.role.description)").rotationEffect(.degrees(rotation)).padding(topPaddingType, topPadding / 2)
      }
    }.padding(topPaddingType, topPadding)
    .onAppear(perform: initPlayer)
  }
  
  func initPlayer() {
    switch(self.SeatPosition){
    case .left:
      self.topPaddingType = .trailing
      self.rotation = 90
      break
    case .right:
      self.topPaddingType = .leading
      self.rotation = -90
      break
    }
    self.playerName = self.player.name
  }
}

//struct AIPlayerView_Previews: PreviewProvider {
//  static var previews: some View {
//    let game = xHoldem()
//    var cards = game.generatePokerSets()
//    let c0 = (game.deal(stash: &cards))!
//    let c1 = (game.deal(stash: &cards))!
//    AIPlayerView(SeatPosition: .left, player: $Player(name: "Player0", role: .Player, cards: [c0, c1]))
//  }
//}
