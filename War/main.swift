//
//  main.swift
//  WarCommandLine
//
//  Created by Davidson, Liam on 2020-02-06.
//  Copyright © 2020 Davidson, Liam. All rights reserved.
//

import Foundation

//create the suit enumeration
enum Suit: Int {
    case heart = 0, spade, diamond, club
}

//create a Value enumeration
enum Value: Int {
    case two = 2, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace
}

//create a structure to define a card using both enumerations
struct Card {
    var suit: Suit
    var value: Value
    
}

//create a hand structure to define either hand using a Card array
struct Hand {
    
    //variabe for the cards in the hand (array)
    var cards : [Card]
    
    //function that lets us draw and remove a card and return  reference to the new card
    mutating func drawTopCard() -> Card {
        let drawnCard = cards[0]
        cards.remove(at: 0)
        return drawnCard
    }
    
}

struct Player {
    var name : String
    var hand : Hand
    var numberOfHandsWon = 0
    var numberOfGamesWon = 0
    var bounty = Hand(cards: [])
    
    mutating func resetHandStats() {
        numberOfHandsWon = 0
    }
}

struct WarGame {
    
    //create a player and computer hand of structure Hand
    var player1 : Player
    var player2 : Player
    var gameHasBeenPlayed = false
    
    
    mutating func createAndRandomlyDealCards() {
        //create a full deck array (empty) to add cards to
        var fullDeck: [Card] = []
        
        //generate a full deck of cards with loops and add them to the full deck
        for generatedSuit in 0...3 {
            for generatedValue in 2...14 {
                fullDeck.append(Card(suit: Suit(rawValue: generatedSuit)!, value: Value(rawValue: generatedValue)!))
            }
        }
        
        //shuffle the deck and divide up the cards into each player's hand
        for i in 0...51 {
            
            //get the index of a random card in the full deck
            let randomIndex = Int.random(in: 0...(fullDeck.count - 1))
            //get a reference to what card will be given to a player
            let cardToMove: Card = fullDeck[randomIndex]
            
            //decide which player to give the card to
            if i % 2 == 0 {
                player1.hand.cards.append(cardToMove)
            } else {
                player2.hand.cards.append(cardToMove)
            }
            
            //remove the card from the full deck
            fullDeck.remove(at: randomIndex)
            
        }
    }
    
    mutating func doAWar(playerOnesCard: Card, playerTwosCard: Card) {
        
        player1.bounty.cards.append(playerOnesCard)
        player1.bounty.cards.append(playerOnesCard)
        
        let onesWarCard = player1.hand.drawTopCard()
        let twosWarCard = player2.hand.drawTopCard()
        //add to the bounties (place three cards face down)
        
        if player1.hand.cards.count > 3 && player2.hand.cards.count > 3 {
            for _ in 0...2 {
                
                if player1.hand.cards.count > 3 && player2.hand.cards.count > 3 {
                    player1.bounty.cards.append(player1.hand.drawTopCard())
                    player2.bounty.cards.append(player2.hand.drawTopCard())
                } else if player1.hand.cards.count <= 3 {
                    player2.numberOfGamesWon += 1
                    endGame(winnerIs: player2)
                    return
                } else if player2.hand.cards.count <= 3 {
                    player1.numberOfGamesWon += 1
                    endGame(winnerIs: player1)
                    return
                } else {
                    print("Something weird happened.")
                }
                
                player1.bounty.cards.append(player1.hand.drawTopCard())
                player2.bounty.cards.append(player2.hand.drawTopCard())
            }
        } else if player1.hand.cards.count <= 3 {
            player2.numberOfGamesWon += 1
            endGame(winnerIs: player2)
            return
        } else if player2.hand.cards.count <= 3 {
            player1.numberOfGamesWon += 1
            endGame(winnerIs: player1)
            return
        } else {
            print("Something weird happened.")
        }
        
        
        
        if onesWarCard.value.rawValue > twosWarCard.value.rawValue {
            //add to number of hands won
            player1.numberOfHandsWon += 1
            
            //give both cards to the winner
            player1.hand.cards.append(onesWarCard)
            player1.hand.cards.append(twosWarCard)
            player1.hand.cards.append(contentsOf: player1.bounty.cards)
            player1.hand.cards.append(contentsOf: player2.bounty.cards)
            
        } else if onesWarCard.value.rawValue < twosWarCard.value.rawValue {
            //add to number of hands won
            player2.numberOfHandsWon += 1
            
            //give both cards to the winner
            player2.hand.cards.append(onesWarCard)
            player2.hand.cards.append(twosWarCard)
            player2.hand.cards.append(contentsOf: player1.bounty.cards)
            player2.hand.cards.append(contentsOf: player2.bounty.cards)
            
        } else if onesWarCard.value.rawValue == twosWarCard.value.rawValue {
            
            if player1.hand.cards.count > 3 && player2.hand.cards.count > 3 {
                print("Another War!")
                doAWar(playerOnesCard: onesWarCard, playerTwosCard: twosWarCard)
            } else if player1.hand.cards.count <= 3 {
                player2.numberOfGamesWon += 1
                endGame(winnerIs: player2)
                return
            } else if player2.hand.cards.count <= 3 {
                player1.numberOfGamesWon += 1
                endGame(winnerIs: player1)
                return
            } else {
                print("Something weird happened.")
            }
            
        }
        
        player1.bounty.cards.removeAll()
        player2.bounty.cards.removeAll()
        
    }
    
    mutating func playHand() {
        //draw the two cards to be compared
        let onesPlayedCard = player1.hand.drawTopCard()
        let twosPlayedCard = player2.hand.drawTopCard()
        
        //compare the cards
        if onesPlayedCard.value.rawValue > twosPlayedCard.value.rawValue {
            //add to number of hands won
            player1.numberOfHandsWon += 1
            
            //give both cards to the winner
            player1.hand.cards.append(onesPlayedCard)
            player1.hand.cards.append(twosPlayedCard)
            
        } else if onesPlayedCard.value.rawValue < twosPlayedCard.value.rawValue {
            //add to number of hands won
            player2.numberOfHandsWon += 1
            
            //give both cards to the winner
            player2.hand.cards.append(onesPlayedCard)
            player2.hand.cards.append(twosPlayedCard)
            
        } else if onesPlayedCard.value.rawValue == twosPlayedCard.value.rawValue {
            
            if player1.hand.cards.count > 3 && player2.hand.cards.count > 3 {
                print("It's a war.")
                doAWar(playerOnesCard: onesPlayedCard, playerTwosCard: twosPlayedCard)
            } else if player1.hand.cards.count <= 3 {
                player2.numberOfGamesWon += 1
                endGame(winnerIs: player2)
                return
            } else if player2.hand.cards.count <= 3 {
                player1.numberOfGamesWon += 1
                endGame(winnerIs: player1)
                return
            } else {
                print("Something weird happened.")
            }
            
            
        }
        
        //        print(player2.numberOfHandsWon)
        //        print(player1.numberOfHandsWon)
        if gameHasBeenPlayed == true {
            return
        }
        
        print(player1.hand.cards.count)
        print(player2.hand.cards.count)
        
        if player1.hand.cards.count + player2.hand.cards.count == 52 {
            print("The right number of cards are in play.")
        } else {
            print("Something is wrong.")
        }
        
        print("Total cards: \(player1.hand.cards.count + player2.hand.cards.count)")
        
        print("=============================")
        
    }
    
    mutating func endGame(winnerIs: Player) {
        
        let winnerMessage = "The winner is \(winnerIs.name). They won \(winnerIs.numberOfHandsWon) hands. They've won a total of \(winnerIs.numberOfGamesWon) games."
        print(winnerMessage)
        gameHasBeenPlayed = true
        
    }
    
    mutating func playGame() {
        
        createAndRandomlyDealCards()
        
        while gameHasBeenPlayed == false {
            
            
            
            if player1.hand.cards.count > 3 && player2.hand.cards.count > 3 {
                playHand()
            } else if player1.hand.cards.count <= 3 {
                player2.numberOfGamesWon += 1
                endGame(winnerIs: player2)
            } else if player2.hand.cards.count <= 3 {
                player1.numberOfGamesWon += 1
                endGame(winnerIs: player1)
            } else {
                print("Something weird happened.")
            }
        }
    }
    
    mutating func reset() {
        gameHasBeenPlayed = false
        player1.resetHandStats()
        player2.resetHandStats()
    }
    
}

//var liamVsJulio = WarGame()
//
//print(liamVsJulio.playerHand.cardsInHand)
//
//liamVsJulio.createAndRandomlyDealCards()
//
//print(liamVsJulio.playerHand.cardsInHand)

//create two players to play the war
var liam = Player(name: "Liam", hand: Hand(cards: []))
var julio = Player(name: "Julio", hand: Hand(cards: []))

var ultimateWar = WarGame(player1: liam, player2: julio)

//for _ in 0...100 {
//    liam.hand.cards.removeAll()
//    julio.hand.cards.removeAll()
//    ultimateWar.reset()
//    ultimateWar.playGame()
//}

ultimateWar.playGame()


