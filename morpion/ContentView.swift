//
//  ContentView.swift
//  morpion
//
//  Created by Daniel Monteiro on 13/09/2023.
//

import SwiftUI

struct ContentView: View {
    @State var textInfo = "❌ is playing"
    @State var gameState = [["none", "none", "none"], ["none", "none", "none"], ["none", "none", "none"]]
    @State var player1 = true
    @State var player2 = false
    @State var line = 0
    @State var caseContent = [["", "", ""], ["", "", ""], ["", "", ""]]
    @State var subtractionValue = 0
    @State var confirmationDialog = false
    @State var allCasesWinner : [[[Bool]]] = [
        [[true, true, true],[false, false, false],[false, false, false]],
        [[false, false, false],[true, true, true],[false, false, false]],
        [[false, false, false],[false, false, false],[true, true, true]],
        [[true, false, false],[true, false, false],[true, false, false]],
        [[false, true, false],[false, true, false],[false, true, false]],
        [[false, false, true],[false, false, true],[false, false, true]],
        [[true, false, false],[false, true, false],[false, false, true]],
        [[false, false, true],[false, true, false],[true, false, false]],
    ]
    @State var isGameFinished = false
    @State var messageFinished = ""
    @State var gameHasWinner = false
    let columns: [GridItem] = Array(repeating: .init(.fixed(97)), count: 3)
    var body: some View {
        NavigationView {
            ZStack{
                Image("BG")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 3)
                
                VStack{
                    
                    VStack{
                        NavigationLink(destination: commentView(firstName: "", lastName: "", grade: 0, showAlert: false, message: "", canClear: false)){
                            Image("logo").resizable() .frame(width: 100, height: 100)
                        }
                        Spacer().frame(height: 50)
                        Text(textInfo).font(.title)
                        
                        
                    }
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(0..<9) { index in
                            Rectangle()
                                .frame(width: 90, height: 100)
                                .foregroundColor(Color.black)
                                .onTapGesture {
                                    //determine dans quelle ligne on est
                                    if(index <= 2){
                                        line = 1
                                        subtractionValue = 0
                                    }
                                    if(index > 2 && index <= 5){
                                        line = 2
                                        subtractionValue = 3
                                    }
                                    if(index > 5 && index <= 8){
                                        line = 3
                                        subtractionValue = 6
                                    }
                                    //changement de tableau
                                    if(gameState[line-1][index-subtractionValue] == "none" && caseContent[line-1][index-subtractionValue] == ""){
                                        gameState[line-1][index-subtractionValue] = "P1"
                                        caseContent[line-1][index-subtractionValue] = "❌"
                                        if(player1 == true){
                                            textInfo = "⭕️ is playing"
                                            gameState[line-1][index-subtractionValue] = "P1"
                                            caseContent[line-1][index-subtractionValue] = "❌"
                                        }
                                        if(player2 == true){
                                            textInfo = "❌ is playing"
                                            gameState[line-1][index-subtractionValue] = "P2"
                                            caseContent[line-1][index-subtractionValue] = "⭕️"
                                        }
                                        //check if player won
                                        if(gameStateAnlyser(array: gameState, player1: player1, player2: player2, allCasesWinner: allCasesWinner)){
                                            
                                            isGameFinished = true
                                            messageFinished = player1 ? "❌ won !" : "⭕️ won !"
                                            gameHasWinner = true
                                        }
                                        //check if grid is full
                                        if(isArrayFull(gridTextArray: caseContent) && gameHasWinner == false){
                                            isGameFinished = true
                                            messageFinished = "nobody won"
                                        }
                                        //change de joueur
                                        player1 = !player1
                                        player2 = !player2
                                    }
                                }.zIndex(2)
                                .opacity(0.5)
                                .blur(radius: 2)
                                .cornerRadius(20)
                                .overlay(Text(caseContent[yValue(number: index) ][xValue(number: index)]).font(.title))
                            
                                .alert(messageFinished, isPresented: $isGameFinished) {
                                    Button("OK", role: .cancel) {
                                        textInfo = "❌ is playing"
                                        gameState = [["none", "none", "none"], ["none", "none", "none"], ["none", "none", "none"]]
                                        player1 = true
                                        player2 = false
                                        line = 0
                                        caseContent = [["", "", ""], ["", "", ""], ["", "", ""]]
                                        subtractionValue = 0
                                        isGameFinished = false
                                        messageFinished = ""
                                        gameHasWinner = false
                                        
                                        
                                    }
                                }
                            
                            
                        }
                        
                    }
                    
                    Button("Replay") {
                        confirmationDialog = true
                    }
                    .confirmationDialog("Are you sure ?",
                                        isPresented: $confirmationDialog) {
                        Button("Replay", role: .destructive) {
                            textInfo = "❌ is playing"
                            gameState = [["none", "none", "none"], ["none", "none", "none"], ["none", "none", "none"]]
                            player1 = true
                            player2 = false
                            line = 0
                            caseContent = [["", "", ""], ["", "", ""], ["", "", ""]]
                            subtractionValue = 0
                            gameHasWinner = false
                        }
                    }
                    
                    
                    
                }
                .navigationTitle(Text("Tic Tac Toe 🕹️"))
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


func yValue(number :Int) -> Int{
    if(number <= 2){
        return 0
    }
    if(number > 2 && number <= 5){
        return 1
    }
    if(number > 5 && number <= 8){
        return 2
    }
    return 0
}


func xValue(number :Int) -> Int{
    if(number == 0 || number == 3 || number == 6){
        return 0
    }
    if(number == 1 || number == 4 || number == 7){
        return 1
    }
    if(number == 2 || number == 5 || number == 8){
        return 2
    }
    return 0
}


func gameStateAnlyser(array:[[String]], player1: Bool, player2: Bool, allCasesWinner : [[[Bool]]])->Bool{
    var textToSearch = ""
    var arrayGameState : [[Bool?]] = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
    var result = false
    var validation = 0
    if(player1 && !player2) { textToSearch = "P1" }
    else { textToSearch = "P2" }
    //convert array
    for firstDim in 0..<3 {
        for secondDim in 0..<3 {
            if(array[firstDim][secondDim] == textToSearch){
                arrayGameState[firstDim][secondDim] = true
            }
            else{
                arrayGameState[firstDim][secondDim] = false
            }
        }
        
    }
    
    
    //comparaison true doivent être dans la même place
    for element1 in 0..<8 {
        validation = 0
        for element2 in 0..<3 {
            for element3 in 0..<3 {
                if(allCasesWinner[element1][element2][element3] == true){
                    if (arrayGameState[element2][element3] != true){
                        validation=0
                        break
                        
                    }
                    else{
                        validation+=1
                        if(validation == 3){
                            result = true
                        }
                        
                    }
                }
                
            }
            
        }
        
    }
    
    return result
}


func isArrayFull(gridTextArray : [[String]])->Bool{
    var returnValue = false
    var verification = 0
    for first in 0..<3{
        for sec in 0..<3{
            if(gridTextArray[first][sec] != ""){
                verification += 1
                if(verification == 9){
                    returnValue = true
                }
            }
            else{
                verification = 0
            }
        }
        
    }
    return returnValue
}
