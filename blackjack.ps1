cls

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

function dealerPlay($boot, $index, $hand, $score) {
    $score = CheckAce $hand $score 
    for($i=0; $i -lt 1; $i++) {
        if($score -lt 17) {
            $hand += $boot[$index]
            
            $score += $boot[$index].value
            $score = CheckAce $hand $score 
            
            if($score -ge 17) {
                return $hand, $score, $index
            }
            $index++
        } else {
            return $hand, $score, $index
        }
        $i--
    }
    $hand.symbol
    $score
}


function Play() {
    write "Welcome to blackjack"
    read-host "press enter to continue"

    $deck = @()
    $boot = CreateDecks 7 $deck

    $boot = shuffle $boot

    write "shuffling" 
    start-sleep -seconds 2

    write "`n"
   
    
    
    while ($True) {
        $i = 0
        [int]$playerScore = $null
        [int]$dealerScore = $null

        $playerHand = @()
        $dealerHand = @()

        $playerHand += $boot[$i], $boot[$i+1]
        $dealerHand += $boot[$i+2], $boot[$i+3]
        $i += 4

        $playerHand.value | Foreach { $playerScore += $_}
        $dealerHand.value | Foreach { $dealerScore += $_}

        [int]$playerscore = CheckAce $playerHand $playerscore 

        print $playerHand $dealerHand $playerScore $dealerScore $False


        do {
            
            if ($playerScore -le 21) {
                $option = read-host "hit (h) or stand? (s)"
                if ($option -eq "h") {
                    $playerHand += $boot[$i]
                    $playerScore += $boot[$i].value
                    $playerscore = CheckAce $playerHand $playerscore 
                    $i++
                    print $playerHand $dealerHand $playerScore $dealerScore $False
                
                } elseif($option -eq "s") {
                    #dealer turn, returns hand, score, index
                    $array = dealerPlay $boot $i $dealerHand $dealerScore 
                    $dealerHand = $array[0]
                    $dealerScore = $array[1]
                    $i = $index
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

        $choice = read-host "Play again? y/n"
        do {
            if ($choice -eq "n") { 
                exit
            } 
        } until ($choice -eq "n" -or $choice -eq "y")
    }
 }



Play
