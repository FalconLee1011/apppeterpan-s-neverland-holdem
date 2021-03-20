//
//  ContentView.swift
//  HwHoldem
//
//  Created by falcon on 2021/3/20.
//

import SwiftUI


struct ContentView: View {
  
  @State var cards: Array<Poker> = []
  @State var boardCards: Array<Poker> = []
  @State var boardChips: Int = 0
  @State var game: xHoldem? = nil
  @State var gameState: GameState = .Preflop
  @State var players: Array<Player> = []
  @State var playerStash: Int = -1
  @State var player: Player = Player(name: "You", role: .Dealer, cards: [], playerType: .Player)
  
  @State var GameIsReady: Bool = false
  @State var showdown: Bool = false
  @State var showResult: Bool = false
  @State var isGoingNextRound: Bool = false
  @State var playerSTurn: Bool = false
  @State var playerBankrupt: Bool = false
  @State var playerHasDetermined: Bool = false
  @State var turn: Int = 4
  
  @State var leaderboard: Dictionary<String, winnerRank> = [:]
  
  @State var prompt: String = "Bet"
  @State var currentPlayerName: String = "None"
  
  @State var turnPlace: Array<Int> = [4, 0, 1, 2, 3]
  
  @State var rolePlace: Array<Role> = [.SmallBlind, .Player, .Player, .Dealer, .BigBlind]
  
  var body: some View {
    VStack{
      
      Text("草's Holdem")
      Text(gameState.description).padding(.top, 10)
      Text(currentPlayerName).padding(0)
      HStack{
        Text("$\(player.chip)").padding()
        Spacer()
        Text("(\(player.role.description)) 1/2").padding()
      }
      
      Spacer()
      
      if(GameIsReady){
        HStack{
          VStack{
            AIPlayerView(SeatPosition: .left, player: $players[1], showdown: showdown)
            AIPlayerView(SeatPosition: .left, player: $players[0], showdown: showdown)
          }.padding(0).offset(x: -40)
          TableView(boardCards: boardCards, gameState: gameState).padding(0)
          VStack{
            AIPlayerView(SeatPosition: .right, player: $players[2], showdown: showdown)
            AIPlayerView(SeatPosition: .right, player: $players[3], showdown: showdown)
          }.padding(0).offset(x: 40)
        }.frame(minWidth: 200)
      }
      
      Spacer()
      VStack{
        Text("Your cards")
        HStack{
          if(GameIsReady){
            ForEach( player.cards, id: \.point ){ (card) in
              ZStack{
                Image(card.getFrontAsset(.blank))
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .padding(0)
                Image(card.getFrontAsset(.front))
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .padding(0)
              }
            }
          }
        }.frame(height: 135)
      }
      .sheet(isPresented: $playerBankrupt) {
        BankruptSheet()
      }
      
      HStack{
        Button(action: {
          playerDeal()
        },
        label: {
          Text(prompt)
        }).disabled(!playerSTurn)
        Button(action: {
          playerFold()
        },
        label: {
          Text("Fold")
        }).disabled(!playerSTurn)
      }
    }
    .sheet(isPresented: $showResult) {
      WinnerSheet(leaderboard: $leaderboard)
    }
    
    .onAppear(perform: initGame)
  }
  
  func initGame(){
    game = xHoldem()
    gameState = .Preflop
    cards = (game?.generatePokerSets(shuffle: true))!
    boardCards = []
    players = []
    
    rolePlace.RL()
    turnPlace.RR()
    
    for playerID in 0...3{
      players.append(Player(name: "Player\(playerID)", role: rolePlace[playerID], cards: [], playerType: .NonPlayer))
      for _ in 0...1 { players[playerID].cards.append((game?.deal(stash: &cards))!) }
    }
    
    player = Player(name: "You", role: rolePlace[4], cards: [], playerType: .Player)
    for _ in 0...1 { player.cards.append((game?.deal(stash: &cards))!) }
    
    players.append(player)
    
    self.GameIsReady = true
    
    turn = rolePlace.firstIndex(of: .Dealer)!
    print("\(players[turn].name) are the dealer.")
    print(turnPlace)
    print("---")
    
    self.play()
  }
  
  func newRound(){
    game = xHoldem()
    gameState = .Preflop
    cards = (game?.generatePokerSets(shuffle: true))!
    boardCards = []
    
    rolePlace.RL()
    turnPlace.RR()
    
    for playerID in 0...players.count - 1{
      players[playerID].cards = []
      for _ in 0...1 { players[playerID].cards.append((game?.deal(stash: &cards))!) }
      players[playerID].newGame(role: rolePlace[playerID])
    }
    
    self.GameIsReady = true
    
    turn = rolePlace.firstIndex(of: .Dealer)!
    print("\(players[turn].name) are the dealer.")
    print(turnPlace)
    print("---")
    
    self.play()
  }
  
  func play() {
    print("--Playing--")
    print(turnPlace)
    for turn in 0...turnPlace.count - 1 {
      if(players[turnPlace[turn]].playerType == .NonPlayer){
        playerSTurn = false
        if(players[turnPlace[turn]].hasFold){ continue }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(turn) * 0.5) {
          currentPlayerName = players[turn].name
          boardChips += players[turnPlace[turn]].bet(100)
          print("\(players[turnPlace[turn]].name) has played.")
        }
      }
      else{
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(turn) * 0.5) {
          if(turn != turnPlace.count - 1){
            playerStash = turn
            print("stashed players from \(players[playerStash].name)")
          }
          else{
            playerStash = -1
          }
          if(players[turnPlace[turn]].hasFold){
            stashedPlayer()
          }
          currentPlayerName = players[turn].name
          playerSTurn = true
          print("Your turn")
        }
        break
      }
    }
  }
  
  func playerFold(){
    players[4].fold()
    stashedPlayer()
  }
  
  func playerDeal(){
    if(!isGoingNextRound){
      boardChips += players[4].bet(100)
      stashedPlayer()
    }else{
      deal()
    }
  }
  
  func stashedPlayer(){
    if(playerStash != -1){
      for turn in (playerStash + 1)...(turnPlace.count - 1){
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(turn) * 0.5) {
          currentPlayerName = players[turn].name
          boardChips += players[turnPlace[turn]].bet(100)
          print("\(players[turnPlace[turn]].name) has played. (Stashed)")
        }
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + Double(turnPlace.count) * 0.5) {
        deal()
      }
    }
    deal()
  }
  
  func deal(){
    print("--Round--")
    switch gameState {
    case .Preflop:
      for _ in 0...2{
        boardCards.append((game?.deal(stash: &cards))!)
      }
      gameState = .Flop
      play()
    case .Flop:
      boardCards.append((game?.deal(stash: &cards))!)
      gameState = .Turn
      play()
    case .Turn:
      boardCards.append((game?.deal(stash: &cards))!)
      gameState = .River
      play()
    case .River:
      gameState = .Showdown
      showdown = true
      print("--Showdown--")
      leaderboard = (game?.detectWinner(cards: self.boardCards, players: self.players))!
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
        showResult = true
      }
      
      let sortedKeys = leaderboard.keys.sorted(by: { (r1, r2) -> Bool in
        return Int(leaderboard[r1]!.description)! > Int(leaderboard[r2]!.description)!
      })
      
      countWinners(sortedKeys: sortedKeys)

      if(players[4].chip <= 0){
        playerBankrupt = true
      }
      isGoingNextRound = true
      prompt = "Next Round"
    case .Showdown:
      isGoingNextRound = false
      boardChips = 0
      showdown = false
      prompt = "Bet"
      newRound()
    }
  }
  
  func countWinners(sortedKeys: [String]){
    let hPlayer = sortedKeys[0]
    var winnerCount = 0
    for p in sortedKeys{
      if leaderboard[p] == leaderboard[hPlayer] { winnerCount += 1 }
    }
    
    let chipsForEachPlayer = boardChips / winnerCount;
    
    for p in sortedKeys{
      if leaderboard[p] == leaderboard[hPlayer] {
        for idx in 0...(players.count - 1){
          if(players[idx].name == p){
            players[idx].chip += chipsForEachPlayer
          }
        }
      }
    }
  }
  
  func sd(){
    print(showdown)
    showdown = true
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .preferredColorScheme(.dark)
  }
}
