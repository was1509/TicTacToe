//
//  ContentView.swift
//  TicTacToe
//
//  Created by Wasitul Hoque on 8/1/23.
//

import SwiftUI
struct ContentView: View {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var startMatch = false
    @State private var userTurn = true
    @State private var isAlert: alerts?
    var body: some View {
        GeometryReader {geometry in
            VStack {
                Text("TicTacToe")
                    .font(.system(size: 30))
                    .fontWeight(.semibold)
                Toggle(isOn: $startMatch) {
                    HStack { Spacer()
                        Text("Start Match").fontWeight(.semibold)
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 25).fill(Color.gray).opacity(0.2).shadow(radius: 7))
                        
                    }
                }
                Spacer()
                if startMatch == true {
                    LazyVGrid(columns: columns) {
                        // Mark: Index
                        // 0 1 2
                        // 3 4 5
                        // 6 7 8
                        ForEach(0..<9) { i in
                            ZStack {
                                Circle()
                                    .foregroundColor(.teal)
                                    .opacity(0.5)
                                    .frame(width: 100, height: 100)
                                Image(systemName: moves[i]?.indicator ?? "")
                                    .resizable()
                                    .foregroundColor(.blue)
                                    .frame(width: 40, height: 40)
                                
                            }
                            .onTapGesture {
                                if moveAlready(in: moves, forIndex: i) {return}
                                moves[i] = Move(player: userTurn ? .human : .computer, boardIndex: i)
                                //userTurn.toggle()
                                if winMatch(for: .human, in: moves) {
                                    isAlert = AlertContext.userWin
                                    return
                                }
                                
                                if isDraw(in: moves) {
                                    isAlert = AlertContext.draw
                                    return
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    let computerPosition = computerMove(in: moves)
                                    moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                    
                                    if winMatch(for: .computer, in: moves) {
                                        isAlert = AlertContext.computerWin
                                        return
                                    }
                                    if isDraw(in: moves) {
                                        isAlert = AlertContext.draw
                                        return
                                    }
                                }
                            }
                        }
                    }
                }
                Spacer()
            }.padding()
                .alert(item: $isAlert, content: {isAlert in Alert(title: isAlert.title, message: isAlert.message, dismissButton: .default(isAlert.buttonTitle , action: {restartGame()}))})
        }
    }
    func moveAlready(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    func computerMove(in moves: [Move?]) -> Int {
        var movePosition = Int.random(in: 0..<9)
        
        while moveAlready(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    func winMatch(for player: User, in moves: [Move?]) -> Bool {
        let winCombinations: Set<Set<Int>> = [[0,1,2] , [3,4,5] , [6,7,8] , [0,4,8] , [2,4,6] , [0,3,6] , [1,4,7] , [2,5,8]]
        
        let playermoves = moves.compactMap {$0}.filter {$0.player == player}
        
        let playerPositions = Set(playermoves.map { $0.boardIndex})
        
        for pattern in winCombinations where pattern.isSubset(of: playerPositions) { return true}
        
        return false
    }
    
    func isDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap {$0}.count == 9
    }
    
    func restartGame() {
        moves = Array(repeating: nil, count: 9)
    }
}

enum User {
    case human, computer
}

struct Move {
    
    let player: User
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
