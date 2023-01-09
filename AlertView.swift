//
//  AlertView.swift
//  TicTacToe
//
//  Created by Wasitul Hoque on 8/1/23.
//

import SwiftUI

struct alerts: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    
    static let userWin = alerts(title: Text("You Win"), message: Text("win"), buttonTitle: Text("Restart"))
    static let computerWin = alerts(title: Text("You Lost"), message: Text("lost"), buttonTitle: Text("Restart"))
    static let draw = alerts(title: Text("Draw"), message: Text("draw"), buttonTitle: Text("Restart"))
}
