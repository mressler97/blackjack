﻿cls

class Card {
    [string]$symbol
    [int]$value
    [int]$value2

   
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

            if($deck[$j].symbol -eq "A♤" -or $deck[$j].symbol -eq "A❤" -or $deck[$j].symbol -eq "A♧" -or $deck[$j].symbol -eq "A♢") {
                $deck[$j].value2 = 11
            }
            $i++
            $j++
        }
        $count++
    } until($count -eq $num)

    return $deck

}

function Shuffle($decks) {
    $decks = $decks | Sort-Object {Get-Random}
    return $decks
}

function print($arr, $arr2, $score) {
    cls
    write-host("Dealer Hand: " + $arr2[0].symbol) 

    if ($arr.Length -eq 2) {
        write-host("Your Hand:   " + $arr[0].symbol, $arr[1].symbol)
        write-host("Current score: " + $score) 
    } elseif($arr.Length -eq 3) {
        $score = 0
        #$arr.value | Foreach { $score += $_}
        write-host("Your Hand:   " + $arr[0].symbol, $arr[1].symbol, $arr[2].symbol)
        write-host("Current score: " + $score) 
    } else {
        $score = 0
        #$arr.value | Foreach { $score += $_} 
        write-host("Your Hand: " + $arr.symbol)
        write-host("Current score: " + $score)
    }
    
}



function Play() {
    $deck = @()
    $boot = CreateDecks 7 $deck

    $boot = shuffle $boot

    #$boot 

    write "`n"
    
    #amount of cards in boot
    #$boot.Length

    # first card of the boot
    #$boot[0]

    #last card of the boot
    #$boot[-1]

    # get a random card from the boot
    #Get-Random -InputObject $boot

    
    $i = 0
    while ($True) {
        $playerScore = $null
        $dealerScore = $null

        $playerHand = @()
        $dealerHand = @()

        $playerHand += $boot[$i], $boot[$i+1]
        $dealerHand += $boot[$i+2], $boot[$i+3]
        $i += 4

        $score = 0
        $playerHand.value | Foreach { $score += $_}
        $score

        print $playerHand $dealerHand $score


        do {
            $option = read-host "hit (h) or stand? (s)"
            if ($score -lt 21) {
                if ($option -eq "h") {
                    $playerHand += $boot[$i]
                    $score += $boot[$i].value
                    $i++
                    print $playerHand $dealerHand $score
                
                } elseif($option -eq "s") {
                    #dealer turn
                    break
                } else {
                    $option = "Wrong input"
                    $option
                }
            }
        } while($option -eq "Wrong input" -or $option -eq "h")
        break
    }
 }



Play
