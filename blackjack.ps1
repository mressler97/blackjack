cls
<#
    members:      Ethan Cochran, Nic Alfonso, William Norman, Michael Ressler
    Date:         30 May 2022
    Description:  This is the card game, blackjack. The player can have the choice to either stand or hit during their turn. Going over 21 is a bust. Once the player stands, 
                  it will be the dealers turn to play. The dealer will hit until their total is at least 17. If neither player busts, the winner goes to whoever is closer to 21.
                  A draw will result in a push. Once the boot gets low on cards, the game will automatically reshuffle the deck. Good luck!
#>

$script:cardCount = 0 #tracker for cards played, used to know when to reshuffle the deck

#class for the card, with attributes being its point value and its symbol. The aces hold a secondary value of 11.
class Card {
    [string]$symbol
    [int]$value
}

# Function creates 52 objects (cards) with their respective symbol and value, and first parameter is the amount of decks wanted in the boot
function CreateDecks($num, $deck) {
    $j = 0
    $count = 0

    # loops for amount of decks wanted
    do {
        $symbols = "A♤", "A❤", "A♧", "A♢", "2♤", "2❤", "2♧", "2♢", "3♤", "3❤", "3♧", "3♢", "4♤", "4❤", "4♧", "4♢",
                "5♤", "5❤", "5♧", "5♢", "6♤", "6❤", "6♧", "6♢", "7♤", "7❤", "7♧", "7♢", "8♤", "8❤", "8♧", "8♢",
                "9♤", "9❤", "9♧", "9♢", "10♤", "10❤", "10♧", "10♢", "J♤", "J❤", "J♧", "J♢", "Q♤", "Q❤", "Q♧",
                "Q♢", "K♤", "K❤", "K♧", "K♢"
        $values = @(1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,8,8,8,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10)

        $i = 0
    
        # loops to create one deck of 52 cards
        foreach($item in $symbols) {
            $deck += [Card]::new()
            $deck[$j].symbol = $item
            $deck[$j].value = $values[$i]


            $i++
            $j++
        }
        $count++
    } until($count -eq $num)

    return $deck

}

# Function that reshuffles the boot with played cards
function Shuffle($decks) {
    write-host "shuffling" 
    start-sleep -seconds 2
    $decks = $decks | Sort-Object {Get-Random}
    return $decks
}


#function checks if an ace is in a hand, and will calculate if 1 or 11 points is better
function CheckAce ($hand, $score)
{
    $temp = $score
    foreach ($card in $hand)
    {
        
        if ($card.value -eq 1)
        {
            $temp += 10
            switch($temp) {
                {$_ -gt 21} {$temp-=10; Break}
                Default {}
            }
            
        }
        
        
    }

    return $temp
}


#function prints dealer's hand and player's hand and score
function print($arr, $arr2, $score, $dealerScore, $dealerTurn) {
    cls
    if ($dealerTurn) {
        write-host("Dealer Hand: " + $arr2.symbol) 
        write-host("Your Hand: " + $arr.symbol)
        write-host("Dealer score: " + $dealerScore)
        write-host("Your score: " + $score)
    } else {

        write-host("Dealer Hand: " + $arr2[0].symbol) 
        write-host("Your Hand:   " + $arr.symbol)
        write-host("Current score: " + $score) 
    }
}

# function that plays as dealer, will hit until score is at least 17
function dealerPlay($boot, $index, $hand, $score) {
    $score = CheckAce $hand $score 
    for($i=0; $i -lt 1; $i++) {
        if($score -lt 17) {
            $hand += $boot[$index]
            $score += $boot[$index].value
            $script:cardCount++
            $index++
            $score = CheckAce $hand $score 
            
            if($score -ge 17) {
                return $hand, $score, $index
            }
        } else {
            return $hand, $score, $index
        }
        $i--
    }
    $hand.symbol
    $score
}


# main function of the game loop, it is the game controller 
function Play() {
    write "Welcome to Blackjack"
    do {
        try {
            [int]$amount = read-host "# of decks (1-10) you would like in boot ->"
        } catch {
            "wrong input"
        }
    } until($amount -gt 0 -and $amount -lt 11)

    $deck = @()
    $boot = CreateDecks $amount $deck

    $boot = shuffle $boot

    write "`n"
   
    $i = 0
    
    while ($True) {
        
        [int]$playerScore = $null
        [int]$dealerScore = $null

        $playerHand = @()
        $dealerHand = @()

        $playerHand += $boot[$i], $boot[$i+1]
        $dealerHand += $boot[$i+2], $boot[$i+3]
        $i += 4
        $script:cardCount += 4

        $playerHand.value | Foreach { $playerScore += $_}
        $dealerHand.value | Foreach { $dealerScore += $_}

        [int]$playerscore = CheckAce $playerHand $playerscore 

        print $playerHand $dealerHand $playerScore $dealerScore $False


        do {
            #player's turn

            if ($playerScore -le 21) {
                $option = read-host "hit (h) or stand? (s)"
                if ($option -eq "h") {
                    $playerHand += $boot[$i]
                    $playerScore += $boot[$i].value
                    $script:cardCount++
                    $playerscore = CheckAce $playerHand $playerscore 
                    $i++
                    print $playerHand $dealerHand $playerScore $dealerScore $False
                
                } elseif($option -eq "s") {
                    #dealer turn, returns hand, score, index

                    $array = dealerPlay $boot $i $dealerHand $dealerScore 
                    $dealerHand = $array[0]
                    $dealerScore = $array[1]
                    $i = $array[2]
                    print $playerHand $dealerHand $playerScore $dealerScore $True
                    break
                } else {
                    $option = "Wrong input"
                    $option
                }
            } else {
                write-host("You busted!")
                break
            }
        } while($option -eq "Wrong input" -or $option -eq "h")
        
        if (($playerScore -gt $dealerScore) -and ($playerScore -le 21))
        {
            write-host "you win"
        }
        elseif (($dealerScore -gt $playerScore)-and ($dealerscore -le 21) -or ($playerScore -gt 21))
        {
            write-host "you lose"
        } elseif($dealerScore -gt 21 -and $playerScore -le 21) {
            write-host "You win!"
        }
        else
        {
            write-host "push"
        }

        do {
            $choice = read-host "Play again? y/n"
            
            if ($choice -eq "n") { 
                exit
            } 
            if ($script:cardCount -ge ($boot.Length-15)) {
                $script:cardCount = 0
                $boot = shuffle $boot
                $i = 0
            }
        } until ($choice -eq "n" -or $choice -eq "y")
    }
 }



Play
