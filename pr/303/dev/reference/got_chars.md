# Game of Thrones POV characters

The data is from the [repurrrsive
package](https://github.com/jennybc/repurrrsive).

## Usage

``` r
got_chars
```

## Format

A unnamed list with 30 components, each representing a POV character.
Each character's component is a named list of length 18, containing
information such as name, aliases, and house allegiances.

## Source

<https://anapioficeandfire.com>

## Details

Info on the point-of-view (POV) characters from the first five books in
the Song of Ice and Fire series by George R. R. Martin. Retrieved from
An API Of Ice And Fire.

## Examples

``` r
got_chars
#> [[1]]
#> [[1]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/1022"
#> 
#> [[1]]$id
#> [1] 1022
#> 
#> [[1]]$name
#> [1] "Theon Greyjoy"
#> 
#> [[1]]$gender
#> [1] "Male"
#> 
#> [[1]]$culture
#> [1] "Ironborn"
#> 
#> [[1]]$born
#> [1] "In 278 AC or 279 AC, at Pyke"
#> 
#> [[1]]$died
#> [1] ""
#> 
#> [[1]]$alive
#> [1] TRUE
#> 
#> [[1]]$titles
#> [1] "Prince of Winterfell"                                
#> [2] "Captain of Sea Bitch"                                
#> [3] "Lord of the Iron Islands (by law of the green lands)"
#> 
#> [[1]]$aliases
#> [1] "Prince of Fools" "Theon Turncloak" "Reek"            "Theon Kinslayer"
#> 
#> [[1]]$father
#> [1] ""
#> 
#> [[1]]$mother
#> [1] ""
#> 
#> [[1]]$spouse
#> [1] ""
#> 
#> [[1]]$allegiances
#> [1] "House Greyjoy of Pyke"
#> 
#> [[1]]$books
#> [1] "A Game of Thrones" "A Storm of Swords" "A Feast for Crows"
#> 
#> [[1]]$povBooks
#> [1] "A Clash of Kings"     "A Dance with Dragons"
#> 
#> [[1]]$tvSeries
#> [1] "Season 1" "Season 2" "Season 3" "Season 4" "Season 5" "Season 6"
#> 
#> [[1]]$playedBy
#> [1] "Alfie Allen"
#> 
#> 
#> [[2]]
#> [[2]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/1052"
#> 
#> [[2]]$id
#> [1] 1052
#> 
#> [[2]]$name
#> [1] "Tyrion Lannister"
#> 
#> [[2]]$gender
#> [1] "Male"
#> 
#> [[2]]$culture
#> [1] ""
#> 
#> [[2]]$born
#> [1] "In 273 AC, at Casterly Rock"
#> 
#> [[2]]$died
#> [1] ""
#> 
#> [[2]]$alive
#> [1] TRUE
#> 
#> [[2]]$titles
#> [1] "Acting Hand of the King (former)" "Master of Coin (former)"         
#> 
#> [[2]]$aliases
#>  [1] "The Imp"            "Halfman"            "The boyman"        
#>  [4] "Giant of Lannister" "Lord Tywin's Doom"  "Lord Tywin's Bane" 
#>  [7] "Yollo"              "Hugor Hill"         "No-Nose"           
#> [10] "Freak"              "Dwarf"             
#> 
#> [[2]]$father
#> [1] ""
#> 
#> [[2]]$mother
#> [1] ""
#> 
#> [[2]]$spouse
#> [1] "https://www.anapioficeandfire.com/api/characters/2044"
#> 
#> [[2]]$allegiances
#> [1] "House Lannister of Casterly Rock"
#> 
#> [[2]]$books
#> [1] "A Feast for Crows"         "The World of Ice and Fire"
#> 
#> [[2]]$povBooks
#> [1] "A Game of Thrones"    "A Clash of Kings"     "A Storm of Swords"   
#> [4] "A Dance with Dragons"
#> 
#> [[2]]$tvSeries
#> [1] "Season 1" "Season 2" "Season 3" "Season 4" "Season 5" "Season 6"
#> 
#> [[2]]$playedBy
#> [1] "Peter Dinklage"
#> 
#> 
#> [[3]]
#> [[3]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/1074"
#> 
#> [[3]]$id
#> [1] 1074
#> 
#> [[3]]$name
#> [1] "Victarion Greyjoy"
#> 
#> [[3]]$gender
#> [1] "Male"
#> 
#> [[3]]$culture
#> [1] "Ironborn"
#> 
#> [[3]]$born
#> [1] "In 268 AC or before, at Pyke"
#> 
#> [[3]]$died
#> [1] ""
#> 
#> [[3]]$alive
#> [1] TRUE
#> 
#> [[3]]$titles
#> [1] "Lord Captain of the Iron Fleet" "Master of the Iron Victory"    
#> 
#> [[3]]$aliases
#> [1] "The Iron Captain"
#> 
#> [[3]]$father
#> [1] ""
#> 
#> [[3]]$mother
#> [1] ""
#> 
#> [[3]]$spouse
#> [1] ""
#> 
#> [[3]]$allegiances
#> [1] "House Greyjoy of Pyke"
#> 
#> [[3]]$books
#> [1] "A Game of Thrones" "A Clash of Kings"  "A Storm of Swords"
#> 
#> [[3]]$povBooks
#> [1] "A Feast for Crows"    "A Dance with Dragons"
#> 
#> [[3]]$tvSeries
#> [1] ""
#> 
#> [[3]]$playedBy
#> [1] ""
#> 
#> 
#> [[4]]
#> [[4]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/1109"
#> 
#> [[4]]$id
#> [1] 1109
#> 
#> [[4]]$name
#> [1] "Will"
#> 
#> [[4]]$gender
#> [1] "Male"
#> 
#> [[4]]$culture
#> [1] ""
#> 
#> [[4]]$born
#> [1] ""
#> 
#> [[4]]$died
#> [1] "In 297 AC, at Haunted Forest"
#> 
#> [[4]]$alive
#> [1] FALSE
#> 
#> [[4]]$titles
#> [1] ""
#> 
#> [[4]]$aliases
#> [1] ""
#> 
#> [[4]]$father
#> [1] ""
#> 
#> [[4]]$mother
#> [1] ""
#> 
#> [[4]]$spouse
#> [1] ""
#> 
#> [[4]]$allegiances
#> list()
#> 
#> [[4]]$books
#> [1] "A Clash of Kings"
#> 
#> [[4]]$povBooks
#> [1] "A Game of Thrones"
#> 
#> [[4]]$tvSeries
#> [1] ""
#> 
#> [[4]]$playedBy
#> [1] "Bronson Webb"
#> 
#> 
#> [[5]]
#> [[5]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/1166"
#> 
#> [[5]]$id
#> [1] 1166
#> 
#> [[5]]$name
#> [1] "Areo Hotah"
#> 
#> [[5]]$gender
#> [1] "Male"
#> 
#> [[5]]$culture
#> [1] "Norvoshi"
#> 
#> [[5]]$born
#> [1] "In 257 AC or before, at Norvos"
#> 
#> [[5]]$died
#> [1] ""
#> 
#> [[5]]$alive
#> [1] TRUE
#> 
#> [[5]]$titles
#> [1] "Captain of the Guard at Sunspear"
#> 
#> [[5]]$aliases
#> [1] ""
#> 
#> [[5]]$father
#> [1] ""
#> 
#> [[5]]$mother
#> [1] ""
#> 
#> [[5]]$spouse
#> [1] ""
#> 
#> [[5]]$allegiances
#> [1] "House Nymeros Martell of Sunspear"
#> 
#> [[5]]$books
#> [1] "A Game of Thrones" "A Clash of Kings"  "A Storm of Swords"
#> 
#> [[5]]$povBooks
#> [1] "A Feast for Crows"    "A Dance with Dragons"
#> 
#> [[5]]$tvSeries
#> [1] "Season 5" "Season 6"
#> 
#> [[5]]$playedBy
#> [1] "DeObia Oparei"
#> 
#> 
#> [[6]]
#> [[6]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/1267"
#> 
#> [[6]]$id
#> [1] 1267
#> 
#> [[6]]$name
#> [1] "Chett"
#> 
#> [[6]]$gender
#> [1] "Male"
#> 
#> [[6]]$culture
#> [1] ""
#> 
#> [[6]]$born
#> [1] "At Hag's Mire"
#> 
#> [[6]]$died
#> [1] "In 299 AC, at Fist of the First Men"
#> 
#> [[6]]$alive
#> [1] FALSE
#> 
#> [[6]]$titles
#> [1] ""
#> 
#> [[6]]$aliases
#> [1] ""
#> 
#> [[6]]$father
#> [1] ""
#> 
#> [[6]]$mother
#> [1] ""
#> 
#> [[6]]$spouse
#> [1] ""
#> 
#> [[6]]$allegiances
#> list()
#> 
#> [[6]]$books
#> [1] "A Game of Thrones" "A Clash of Kings" 
#> 
#> [[6]]$povBooks
#> [1] "A Storm of Swords"
#> 
#> [[6]]$tvSeries
#> [1] ""
#> 
#> [[6]]$playedBy
#> [1] ""
#> 
#> 
#> [[7]]
#> [[7]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/1295"
#> 
#> [[7]]$id
#> [1] 1295
#> 
#> [[7]]$name
#> [1] "Cressen"
#> 
#> [[7]]$gender
#> [1] "Male"
#> 
#> [[7]]$culture
#> [1] ""
#> 
#> [[7]]$born
#> [1] "In 219 AC or 220 AC"
#> 
#> [[7]]$died
#> [1] "In 299 AC, at Dragonstone"
#> 
#> [[7]]$alive
#> [1] FALSE
#> 
#> [[7]]$titles
#> [1] "Maester"
#> 
#> [[7]]$aliases
#> [1] ""
#> 
#> [[7]]$father
#> [1] ""
#> 
#> [[7]]$mother
#> [1] ""
#> 
#> [[7]]$spouse
#> [1] ""
#> 
#> [[7]]$allegiances
#> list()
#> 
#> [[7]]$books
#> [1] "A Storm of Swords" "A Feast for Crows"
#> 
#> [[7]]$povBooks
#> [1] "A Clash of Kings"
#> 
#> [[7]]$tvSeries
#> [1] "Season 2"
#> 
#> [[7]]$playedBy
#> [1] "Oliver Ford"
#> 
#> 
#> [[8]]
#> [[8]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/130"
#> 
#> [[8]]$id
#> [1] 130
#> 
#> [[8]]$name
#> [1] "Arianne Martell"
#> 
#> [[8]]$gender
#> [1] "Female"
#> 
#> [[8]]$culture
#> [1] "Dornish"
#> 
#> [[8]]$born
#> [1] "In 276 AC, at Sunspear"
#> 
#> [[8]]$died
#> [1] ""
#> 
#> [[8]]$alive
#> [1] TRUE
#> 
#> [[8]]$titles
#> [1] "Princess of Dorne"
#> 
#> [[8]]$aliases
#> [1] ""
#> 
#> [[8]]$father
#> [1] ""
#> 
#> [[8]]$mother
#> [1] ""
#> 
#> [[8]]$spouse
#> [1] ""
#> 
#> [[8]]$allegiances
#> [1] "House Nymeros Martell of Sunspear"
#> 
#> [[8]]$books
#> [1] "A Game of Thrones"    "A Clash of Kings"     "A Storm of Swords"   
#> [4] "A Dance with Dragons"
#> 
#> [[8]]$povBooks
#> [1] "A Feast for Crows"
#> 
#> [[8]]$tvSeries
#> [1] ""
#> 
#> [[8]]$playedBy
#> [1] ""
#> 
#> 
#> [[9]]
#> [[9]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/1303"
#> 
#> [[9]]$id
#> [1] 1303
#> 
#> [[9]]$name
#> [1] "Daenerys Targaryen"
#> 
#> [[9]]$gender
#> [1] "Female"
#> 
#> [[9]]$culture
#> [1] "Valyrian"
#> 
#> [[9]]$born
#> [1] "In 284 AC, at Dragonstone"
#> 
#> [[9]]$died
#> [1] ""
#> 
#> [[9]]$alive
#> [1] TRUE
#> 
#> [[9]]$titles
#> [1] "Queen of the Andals and the Rhoynar and the First Men, Lord of the Seven Kingdoms"
#> [2] "Khaleesi of the Great Grass Sea"                                                  
#> [3] "Breaker of Shackles/Chains"                                                       
#> [4] "Queen of Meereen"                                                                 
#> [5] "Princess of Dragonstone"                                                          
#> 
#> [[9]]$aliases
#>  [1] "Dany"                    "Daenerys Stormborn"     
#>  [3] "The Unburnt"             "Mother of Dragons"      
#>  [5] "Mother"                  "Mhysa"                  
#>  [7] "The Silver Queen"        "Silver Lady"            
#>  [9] "Dragonmother"            "The Dragon Queen"       
#> [11] "The Mad King's daughter"
#> 
#> [[9]]$father
#> [1] ""
#> 
#> [[9]]$mother
#> [1] ""
#> 
#> [[9]]$spouse
#> [1] "https://www.anapioficeandfire.com/api/characters/1346"
#> 
#> [[9]]$allegiances
#> [1] "House Targaryen of King's Landing"
#> 
#> [[9]]$books
#> [1] "A Feast for Crows"
#> 
#> [[9]]$povBooks
#> [1] "A Game of Thrones"    "A Clash of Kings"     "A Storm of Swords"   
#> [4] "A Dance with Dragons"
#> 
#> [[9]]$tvSeries
#> [1] "Season 1" "Season 2" "Season 3" "Season 4" "Season 5" "Season 6"
#> 
#> [[9]]$playedBy
#> [1] "Emilia Clarke"
#> 
#> 
#> [[10]]
#> [[10]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/1319"
#> 
#> [[10]]$id
#> [1] 1319
#> 
#> [[10]]$name
#> [1] "Davos Seaworth"
#> 
#> [[10]]$gender
#> [1] "Male"
#> 
#> [[10]]$culture
#> [1] "Westeros"
#> 
#> [[10]]$born
#> [1] "In 260 AC or before, at King's Landing"
#> 
#> [[10]]$died
#> [1] ""
#> 
#> [[10]]$alive
#> [1] TRUE
#> 
#> [[10]]$titles
#> [1] "Ser"                       "Lord of the Rainwood"     
#> [3] "Admiral of the Narrow Sea" "Hand of the King"         
#> 
#> [[10]]$aliases
#> [1] "Onion Knight"    "Davos Shorthand" "Ser Onions"      "Onion Lord"     
#> [5] "Smuggler"       
#> 
#> [[10]]$father
#> [1] ""
#> 
#> [[10]]$mother
#> [1] ""
#> 
#> [[10]]$spouse
#> [1] "https://www.anapioficeandfire.com/api/characters/1676"
#> 
#> [[10]]$allegiances
#> [1] "House Baratheon of Dragonstone" "House Seaworth of Cape Wrath"  
#> 
#> [[10]]$books
#> [1] "A Feast for Crows"
#> 
#> [[10]]$povBooks
#> [1] "A Clash of Kings"     "A Storm of Swords"    "A Dance with Dragons"
#> 
#> [[10]]$tvSeries
#> [1] "Season 2" "Season 3" "Season 4" "Season 5" "Season 6"
#> 
#> [[10]]$playedBy
#> [1] "Liam Cunningham"
#> 
#> 
#> [[11]]
#> [[11]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/148"
#> 
#> [[11]]$id
#> [1] 148
#> 
#> [[11]]$name
#> [1] "Arya Stark"
#> 
#> [[11]]$gender
#> [1] "Female"
#> 
#> [[11]]$culture
#> [1] "Northmen"
#> 
#> [[11]]$born
#> [1] "In 289 AC, at Winterfell"
#> 
#> [[11]]$died
#> [1] ""
#> 
#> [[11]]$alive
#> [1] TRUE
#> 
#> [[11]]$titles
#> [1] "Princess"
#> 
#> [[11]]$aliases
#>  [1] "Arya Horseface"       "Arya Underfoot"       "Arry"                
#>  [4] "Lumpyface"            "Lumpyhead"            "Stickboy"            
#>  [7] "Weasel"               "Nymeria"              "Squan"               
#> [10] "Saltb"                "Cat of the Canaly"    "Bets"                
#> [13] "The Blind Girh"       "The Ugly Little Girl" "Mercedenl"           
#> [16] "Mercye"              
#> 
#> [[11]]$father
#> [1] ""
#> 
#> [[11]]$mother
#> [1] ""
#> 
#> [[11]]$spouse
#> [1] ""
#> 
#> [[11]]$allegiances
#> [1] "House Stark of Winterfell"
#> 
#> [[11]]$books
#> list()
#> 
#> [[11]]$povBooks
#> [1] "A Game of Thrones"    "A Clash of Kings"     "A Storm of Swords"   
#> [4] "A Feast for Crows"    "A Dance with Dragons"
#> 
#> [[11]]$tvSeries
#> [1] "Season 1" "Season 2" "Season 3" "Season 4" "Season 5" "Season 6"
#> 
#> [[11]]$playedBy
#> [1] "Maisie Williams"
#> 
#> 
#> [[12]]
#> [[12]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/149"
#> 
#> [[12]]$id
#> [1] 149
#> 
#> [[12]]$name
#> [1] "Arys Oakheart"
#> 
#> [[12]]$gender
#> [1] "Male"
#> 
#> [[12]]$culture
#> [1] "Reach"
#> 
#> [[12]]$born
#> [1] "At Old Oak"
#> 
#> [[12]]$died
#> [1] "In 300 AC, at the Greenblood"
#> 
#> [[12]]$alive
#> [1] FALSE
#> 
#> [[12]]$titles
#> [1] "Ser"
#> 
#> [[12]]$aliases
#> [1] ""
#> 
#> [[12]]$father
#> [1] ""
#> 
#> [[12]]$mother
#> [1] ""
#> 
#> [[12]]$spouse
#> [1] ""
#> 
#> [[12]]$allegiances
#> [1] "House Oakheart of Old Oak"
#> 
#> [[12]]$books
#> [1] "A Game of Thrones"    "A Clash of Kings"     "A Storm of Swords"   
#> [4] "A Dance with Dragons"
#> 
#> [[12]]$povBooks
#> [1] "A Feast for Crows"
#> 
#> [[12]]$tvSeries
#> [1] ""
#> 
#> [[12]]$playedBy
#> [1] ""
#> 
#> 
#> [[13]]
#> [[13]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/150"
#> 
#> [[13]]$id
#> [1] 150
#> 
#> [[13]]$name
#> [1] "Asha Greyjoy"
#> 
#> [[13]]$gender
#> [1] "Female"
#> 
#> [[13]]$culture
#> [1] "Ironborn"
#> 
#> [[13]]$born
#> [1] "In 275 AC or 276 AC, at Pyke"
#> 
#> [[13]]$died
#> [1] ""
#> 
#> [[13]]$alive
#> [1] TRUE
#> 
#> [[13]]$titles
#> [1] "Princess"                    "Captain of the Black Wind"  
#> [3] "Conqueror of Deepwood Motte"
#> 
#> [[13]]$aliases
#> [1] "Esgred"                "The Kraken's Daughter"
#> 
#> [[13]]$father
#> [1] ""
#> 
#> [[13]]$mother
#> [1] ""
#> 
#> [[13]]$spouse
#> [1] "https://www.anapioficeandfire.com/api/characters/1372"
#> 
#> [[13]]$allegiances
#> [1] "House Greyjoy of Pyke" "House Ironmaker"      
#> 
#> [[13]]$books
#> [1] "A Game of Thrones" "A Clash of Kings" 
#> 
#> [[13]]$povBooks
#> [1] "A Feast for Crows"    "A Dance with Dragons"
#> 
#> [[13]]$tvSeries
#> [1] "Season 2" "Season 3" "Season 4"
#> 
#> [[13]]$playedBy
#> [1] "Gemma Whelan"
#> 
#> 
#> [[14]]
#> [[14]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/168"
#> 
#> [[14]]$id
#> [1] 168
#> 
#> [[14]]$name
#> [1] "Barristan Selmy"
#> 
#> [[14]]$gender
#> [1] "Male"
#> 
#> [[14]]$culture
#> [1] "Westeros"
#> 
#> [[14]]$born
#> [1] "In 237 AC"
#> 
#> [[14]]$died
#> [1] ""
#> 
#> [[14]]$alive
#> [1] TRUE
#> 
#> [[14]]$titles
#> [1] "Ser"               "Hand of the Queen"
#> 
#> [[14]]$aliases
#> [1] "Barristan the Bold" "Arstan Whitebeard"  "Ser Grandfather"   
#> [4] "Barristan the Old"  "Old Ser"           
#> 
#> [[14]]$father
#> [1] ""
#> 
#> [[14]]$mother
#> [1] ""
#> 
#> [[14]]$spouse
#> [1] ""
#> 
#> [[14]]$allegiances
#> [1] "House Selmy of Harvest Hall"       "House Targaryen of King's Landing"
#> 
#> [[14]]$books
#> [1] "A Game of Thrones"         "A Clash of Kings"         
#> [3] "A Storm of Swords"         "A Feast for Crows"        
#> [5] "The World of Ice and Fire"
#> 
#> [[14]]$povBooks
#> [1] "A Dance with Dragons"
#> 
#> [[14]]$tvSeries
#> [1] "Season 1" "Season 3" "Season 4" "Season 5"
#> 
#> [[14]]$playedBy
#> [1] "Ian McElhinney"
#> 
#> 
#> [[15]]
#> [[15]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/2066"
#> 
#> [[15]]$id
#> [1] 2066
#> 
#> [[15]]$name
#> [1] "Varamyr"
#> 
#> [[15]]$gender
#> [1] "Male"
#> 
#> [[15]]$culture
#> [1] "Free Folk"
#> 
#> [[15]]$born
#> [1] "At a village Beyond the Wall"
#> 
#> [[15]]$died
#> [1] "In 300 AC, at a village Beyond the Wall"
#> 
#> [[15]]$alive
#> [1] FALSE
#> 
#> [[15]]$titles
#> [1] ""
#> 
#> [[15]]$aliases
#> [1] "Varamyr Sixskins" "Haggon"           "Lump"            
#> 
#> [[15]]$father
#> [1] ""
#> 
#> [[15]]$mother
#> [1] ""
#> 
#> [[15]]$spouse
#> [1] ""
#> 
#> [[15]]$allegiances
#> list()
#> 
#> [[15]]$books
#> [1] "A Storm of Swords"
#> 
#> [[15]]$povBooks
#> [1] "A Dance with Dragons"
#> 
#> [[15]]$tvSeries
#> [1] ""
#> 
#> [[15]]$playedBy
#> [1] ""
#> 
#> 
#> [[16]]
#> [[16]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/208"
#> 
#> [[16]]$id
#> [1] 208
#> 
#> [[16]]$name
#> [1] "Brandon Stark"
#> 
#> [[16]]$gender
#> [1] "Male"
#> 
#> [[16]]$culture
#> [1] "Northmen"
#> 
#> [[16]]$born
#> [1] "In 290 AC, at Winterfell"
#> 
#> [[16]]$died
#> [1] ""
#> 
#> [[16]]$alive
#> [1] TRUE
#> 
#> [[16]]$titles
#> [1] "Prince of Winterfell"
#> 
#> [[16]]$aliases
#> [1] "Bran"            "Bran the Broken" "The Winged Wolf"
#> 
#> [[16]]$father
#> [1] ""
#> 
#> [[16]]$mother
#> [1] ""
#> 
#> [[16]]$spouse
#> [1] ""
#> 
#> [[16]]$allegiances
#> [1] "House Stark of Winterfell"
#> 
#> [[16]]$books
#> [1] "A Feast for Crows"
#> 
#> [[16]]$povBooks
#> [1] "A Game of Thrones"    "A Clash of Kings"     "A Storm of Swords"   
#> [4] "A Dance with Dragons"
#> 
#> [[16]]$tvSeries
#> [1] "Season 1" "Season 2" "Season 3" "Season 4" "Season 6"
#> 
#> [[16]]$playedBy
#> [1] "Isaac Hempstead-Wright"
#> 
#> 
#> [[17]]
#> [[17]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/216"
#> 
#> [[17]]$id
#> [1] 216
#> 
#> [[17]]$name
#> [1] "Brienne of Tarth"
#> 
#> [[17]]$gender
#> [1] "Female"
#> 
#> [[17]]$culture
#> [1] ""
#> 
#> [[17]]$born
#> [1] "In 280 AC"
#> 
#> [[17]]$died
#> [1] ""
#> 
#> [[17]]$alive
#> [1] TRUE
#> 
#> [[17]]$titles
#> [1] ""
#> 
#> [[17]]$aliases
#> [1] "The Maid of Tarth"  "Brienne the Beauty" "Brienne the Blue"  
#> 
#> [[17]]$father
#> [1] ""
#> 
#> [[17]]$mother
#> [1] ""
#> 
#> [[17]]$spouse
#> [1] ""
#> 
#> [[17]]$allegiances
#> [1] "House Baratheon of Storm's End" "House Stark of Winterfell"     
#> [3] "House Tarth of Evenfall Hall"  
#> 
#> [[17]]$books
#> [1] "A Clash of Kings"     "A Storm of Swords"    "A Dance with Dragons"
#> 
#> [[17]]$povBooks
#> [1] "A Feast for Crows"
#> 
#> [[17]]$tvSeries
#> [1] "Season 2" "Season 3" "Season 4" "Season 5" "Season 6"
#> 
#> [[17]]$playedBy
#> [1] "Gwendoline Christie"
#> 
#> 
#> [[18]]
#> [[18]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/232"
#> 
#> [[18]]$id
#> [1] 232
#> 
#> [[18]]$name
#> [1] "Catelyn Stark"
#> 
#> [[18]]$gender
#> [1] "Female"
#> 
#> [[18]]$culture
#> [1] "Rivermen"
#> 
#> [[18]]$born
#> [1] "In 264 AC, at Riverrun"
#> 
#> [[18]]$died
#> [1] "In 299 AC, at the Twins"
#> 
#> [[18]]$alive
#> [1] FALSE
#> 
#> [[18]]$titles
#> [1] "Lady of Winterfell"
#> 
#> [[18]]$aliases
#> [1] "Catelyn Tully"     "Lady Stoneheart"   "The Silent Sistet"
#> [4] "Mother Mercilesr"  "The Hangwomans"   
#> 
#> [[18]]$father
#> [1] ""
#> 
#> [[18]]$mother
#> [1] ""
#> 
#> [[18]]$spouse
#> [1] "https://www.anapioficeandfire.com/api/characters/339"
#> 
#> [[18]]$allegiances
#> [1] "House Stark of Winterfell" "House Tully of Riverrun"  
#> 
#> [[18]]$books
#> [1] "A Feast for Crows"    "A Dance with Dragons"
#> 
#> [[18]]$povBooks
#> [1] "A Game of Thrones" "A Clash of Kings"  "A Storm of Swords"
#> 
#> [[18]]$tvSeries
#> [1] "Season 1" "Season 2" "Season 3"
#> 
#> [[18]]$playedBy
#> [1] "Michelle Fairley"
#> 
#> 
#> [[19]]
#> [[19]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/238"
#> 
#> [[19]]$id
#> [1] 238
#> 
#> [[19]]$name
#> [1] "Cersei Lannister"
#> 
#> [[19]]$gender
#> [1] "Female"
#> 
#> [[19]]$culture
#> [1] "Westerman"
#> 
#> [[19]]$born
#> [1] "In 266 AC, at Casterly Rock"
#> 
#> [[19]]$died
#> [1] ""
#> 
#> [[19]]$alive
#> [1] TRUE
#> 
#> [[19]]$titles
#> [1] "Light of the West"      "Queen Dowager"          "Protector of the Realm"
#> [4] "Lady of Casterly Rock"  "Queen Regent"          
#> 
#> [[19]]$aliases
#> list()
#> 
#> [[19]]$father
#> [1] ""
#> 
#> [[19]]$mother
#> [1] ""
#> 
#> [[19]]$spouse
#> [1] "https://www.anapioficeandfire.com/api/characters/901"
#> 
#> [[19]]$allegiances
#> [1] "House Lannister of Casterly Rock"
#> 
#> [[19]]$books
#> [1] "A Game of Thrones" "A Clash of Kings"  "A Storm of Swords"
#> 
#> [[19]]$povBooks
#> [1] "A Feast for Crows"    "A Dance with Dragons"
#> 
#> [[19]]$tvSeries
#> [1] "Season 1" "Season 2" "Season 3" "Season 4" "Season 5" "Season 6"
#> 
#> [[19]]$playedBy
#> [1] "Lena Headey"
#> 
#> 
#> [[20]]
#> [[20]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/339"
#> 
#> [[20]]$id
#> [1] 339
#> 
#> [[20]]$name
#> [1] "Eddard Stark"
#> 
#> [[20]]$gender
#> [1] "Male"
#> 
#> [[20]]$culture
#> [1] "Northmen"
#> 
#> [[20]]$born
#> [1] "In 263 AC, at Winterfell"
#> 
#> [[20]]$died
#> [1] "In 299 AC, at Great Sept of Baelor in King's Landing"
#> 
#> [[20]]$alive
#> [1] FALSE
#> 
#> [[20]]$titles
#> [1] "Lord of Winterfell"     "Warden of the North"    "Hand of the King"      
#> [4] "Protector of the Realm" "Regent"                
#> 
#> [[20]]$aliases
#> [1] "Ned"            "The Ned"        "The Quiet Wolf"
#> 
#> [[20]]$father
#> [1] ""
#> 
#> [[20]]$mother
#> [1] ""
#> 
#> [[20]]$spouse
#> [1] "https://www.anapioficeandfire.com/api/characters/232"
#> 
#> [[20]]$allegiances
#> [1] "House Stark of Winterfell"
#> 
#> [[20]]$books
#> [1] "A Clash of Kings"          "A Storm of Swords"        
#> [3] "A Feast for Crows"         "A Dance with Dragons"     
#> [5] "The World of Ice and Fire"
#> 
#> [[20]]$povBooks
#> [1] "A Game of Thrones"
#> 
#> [[20]]$tvSeries
#> [1] "Season 1" "Season 6"
#> 
#> [[20]]$playedBy
#> [1] "Sean Bean"       "Sebastian Croft" "Robert Aramayo" 
#> 
#> 
#> [[21]]
#> [[21]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/529"
#> 
#> [[21]]$id
#> [1] 529
#> 
#> [[21]]$name
#> [1] "Jaime Lannister"
#> 
#> [[21]]$gender
#> [1] "Male"
#> 
#> [[21]]$culture
#> [1] "Westerlands"
#> 
#> [[21]]$born
#> [1] "In 266 AC, at Casterly Rock"
#> 
#> [[21]]$died
#> [1] ""
#> 
#> [[21]]$alive
#> [1] TRUE
#> 
#> [[21]]$titles
#> [1] "Ser"                              "Lord Commander of the Kingsguard"
#> [3] "Warden of the East (formerly)"   
#> 
#> [[21]]$aliases
#> [1] "The Kingslayer"        "The Lion of Lannister" "The Young Lion"       
#> [4] "Cripple"              
#> 
#> [[21]]$father
#> [1] ""
#> 
#> [[21]]$mother
#> [1] ""
#> 
#> [[21]]$spouse
#> [1] ""
#> 
#> [[21]]$allegiances
#> [1] "House Lannister of Casterly Rock"
#> 
#> [[21]]$books
#> [1] "A Game of Thrones" "A Clash of Kings" 
#> 
#> [[21]]$povBooks
#> [1] "A Storm of Swords"    "A Feast for Crows"    "A Dance with Dragons"
#> 
#> [[21]]$tvSeries
#> [1] "Season 1" "Season 2" "Season 3" "Season 4" "Season 5"
#> 
#> [[21]]$playedBy
#> [1] "Nikolaj Coster-Waldau"
#> 
#> 
#> [[22]]
#> [[22]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/576"
#> 
#> [[22]]$id
#> [1] 576
#> 
#> [[22]]$name
#> [1] "Jon Connington"
#> 
#> [[22]]$gender
#> [1] "Male"
#> 
#> [[22]]$culture
#> [1] "Stormlands"
#> 
#> [[22]]$born
#> [1] "In or between 263 AC and 265 AC"
#> 
#> [[22]]$died
#> [1] ""
#> 
#> [[22]]$alive
#> [1] TRUE
#> 
#> [[22]]$titles
#> [1] "Lord of Griffin's Roost" "Hand of the King"       
#> [3] "Hand of the True King"  
#> 
#> [[22]]$aliases
#> [1] "Griffthe Mad King's Hand"
#> 
#> [[22]]$father
#> [1] ""
#> 
#> [[22]]$mother
#> [1] ""
#> 
#> [[22]]$spouse
#> [1] ""
#> 
#> [[22]]$allegiances
#> [1] "House Connington of Griffin's Roost" "House Targaryen of King's Landing"  
#> 
#> [[22]]$books
#> [1] "A Storm of Swords"         "A Feast for Crows"        
#> [3] "The World of Ice and Fire"
#> 
#> [[22]]$povBooks
#> [1] "A Dance with Dragons"
#> 
#> [[22]]$tvSeries
#> [1] ""
#> 
#> [[22]]$playedBy
#> [1] ""
#> 
#> 
#> [[23]]
#> [[23]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/583"
#> 
#> [[23]]$id
#> [1] 583
#> 
#> [[23]]$name
#> [1] "Jon Snow"
#> 
#> [[23]]$gender
#> [1] "Male"
#> 
#> [[23]]$culture
#> [1] "Northmen"
#> 
#> [[23]]$born
#> [1] "In 283 AC"
#> 
#> [[23]]$died
#> [1] ""
#> 
#> [[23]]$alive
#> [1] TRUE
#> 
#> [[23]]$titles
#> [1] "Lord Commander of the Night's Watch"
#> 
#> [[23]]$aliases
#> [1] "Lord Snow"                                    
#> [2] "Ned Stark's Bastard"                          
#> [3] "The Snow of Winterfell"                       
#> [4] "The Crow-Come-Over"                           
#> [5] "The 998th Lord Commander of the Night's Watch"
#> [6] "The Bastard of Winterfell"                    
#> [7] "The Black Bastard of the Wall"                
#> [8] "Lord Crow"                                    
#> 
#> [[23]]$father
#> [1] ""
#> 
#> [[23]]$mother
#> [1] ""
#> 
#> [[23]]$spouse
#> [1] ""
#> 
#> [[23]]$allegiances
#> [1] "House Stark of Winterfell"
#> 
#> [[23]]$books
#> [1] "A Feast for Crows"
#> 
#> [[23]]$povBooks
#> [1] "A Game of Thrones"    "A Clash of Kings"     "A Storm of Swords"   
#> [4] "A Dance with Dragons"
#> 
#> [[23]]$tvSeries
#> [1] "Season 1" "Season 2" "Season 3" "Season 4" "Season 5" "Season 6"
#> 
#> [[23]]$playedBy
#> [1] "Kit Harington"
#> 
#> 
#> [[24]]
#> [[24]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/60"
#> 
#> [[24]]$id
#> [1] 60
#> 
#> [[24]]$name
#> [1] "Aeron Greyjoy"
#> 
#> [[24]]$gender
#> [1] "Male"
#> 
#> [[24]]$culture
#> [1] "Ironborn"
#> 
#> [[24]]$born
#> [1] "In or between 269 AC and 273 AC, at Pyke"
#> 
#> [[24]]$died
#> [1] ""
#> 
#> [[24]]$alive
#> [1] TRUE
#> 
#> [[24]]$titles
#> [1] "Priest of the Drowned God"             
#> [2] "Captain of the Golden Storm (formerly)"
#> 
#> [[24]]$aliases
#> [1] "The Damphair"   "Aeron Damphair"
#> 
#> [[24]]$father
#> [1] ""
#> 
#> [[24]]$mother
#> [1] ""
#> 
#> [[24]]$spouse
#> [1] ""
#> 
#> [[24]]$allegiances
#> [1] "House Greyjoy of Pyke"
#> 
#> [[24]]$books
#> [1] "A Game of Thrones"    "A Clash of Kings"     "A Storm of Swords"   
#> [4] "A Dance with Dragons"
#> 
#> [[24]]$povBooks
#> [1] "A Feast for Crows"
#> 
#> [[24]]$tvSeries
#> [1] "Season 6"
#> 
#> [[24]]$playedBy
#> [1] "Michael Feast"
#> 
#> 
#> [[25]]
#> [[25]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/605"
#> 
#> [[25]]$id
#> [1] 605
#> 
#> [[25]]$name
#> [1] "Kevan Lannister"
#> 
#> [[25]]$gender
#> [1] "Male"
#> 
#> [[25]]$culture
#> [1] ""
#> 
#> [[25]]$born
#> [1] "In 244 AC"
#> 
#> [[25]]$died
#> [1] "In 300 AC, at King's Landing"
#> 
#> [[25]]$alive
#> [1] FALSE
#> 
#> [[25]]$titles
#> [1] "Ser"                    "Master of laws"         "Lord Regent"           
#> [4] "Protector of the Realm"
#> 
#> [[25]]$aliases
#> [1] ""
#> 
#> [[25]]$father
#> [1] ""
#> 
#> [[25]]$mother
#> [1] ""
#> 
#> [[25]]$spouse
#> [1] "https://www.anapioficeandfire.com/api/characters/327"
#> 
#> [[25]]$allegiances
#> [1] "House Lannister of Casterly Rock"
#> 
#> [[25]]$books
#> [1] "A Game of Thrones" "A Clash of Kings"  "A Storm of Swords"
#> [4] "A Feast for Crows"
#> 
#> [[25]]$povBooks
#> [1] "A Dance with Dragons"
#> 
#> [[25]]$tvSeries
#> [1] "Season 1" "Season 2" "Season 5" "Season 6"
#> 
#> [[25]]$playedBy
#> [1] "Ian Gelder"
#> 
#> 
#> [[26]]
#> [[26]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/743"
#> 
#> [[26]]$id
#> [1] 743
#> 
#> [[26]]$name
#> [1] "Melisandre"
#> 
#> [[26]]$gender
#> [1] "Female"
#> 
#> [[26]]$culture
#> [1] "Asshai"
#> 
#> [[26]]$born
#> [1] "At Unknown"
#> 
#> [[26]]$died
#> [1] ""
#> 
#> [[26]]$alive
#> [1] TRUE
#> 
#> [[26]]$titles
#> [1] ""
#> 
#> [[26]]$aliases
#> [1] "The Red Priestess"     "The Red Woman"         "The King's Red Shadow"
#> [4] "Lady Red"              "Lot Seven"            
#> 
#> [[26]]$father
#> [1] ""
#> 
#> [[26]]$mother
#> [1] ""
#> 
#> [[26]]$spouse
#> [1] ""
#> 
#> [[26]]$allegiances
#> list()
#> 
#> [[26]]$books
#> [1] "A Clash of Kings"  "A Storm of Swords" "A Feast for Crows"
#> 
#> [[26]]$povBooks
#> [1] "A Dance with Dragons"
#> 
#> [[26]]$tvSeries
#> [1] "Season 2" "Season 3" "Season 4" "Season 5" "Season 6"
#> 
#> [[26]]$playedBy
#> [1] "Carice van Houten"
#> 
#> 
#> [[27]]
#> [[27]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/751"
#> 
#> [[27]]$id
#> [1] 751
#> 
#> [[27]]$name
#> [1] "Merrett Frey"
#> 
#> [[27]]$gender
#> [1] "Male"
#> 
#> [[27]]$culture
#> [1] "Rivermen"
#> 
#> [[27]]$born
#> [1] "In 262 AC"
#> 
#> [[27]]$died
#> [1] "In 300 AC, at Near Oldstones"
#> 
#> [[27]]$alive
#> [1] FALSE
#> 
#> [[27]]$titles
#> [1] ""
#> 
#> [[27]]$aliases
#> [1] "Merrett Muttonhead"
#> 
#> [[27]]$father
#> [1] ""
#> 
#> [[27]]$mother
#> [1] ""
#> 
#> [[27]]$spouse
#> [1] "https://www.anapioficeandfire.com/api/characters/712"
#> 
#> [[27]]$allegiances
#> [1] "House Frey of the Crossing"
#> 
#> [[27]]$books
#> [1] "A Game of Thrones"    "A Clash of Kings"     "A Feast for Crows"   
#> [4] "A Dance with Dragons"
#> 
#> [[27]]$povBooks
#> [1] "A Storm of Swords"
#> 
#> [[27]]$tvSeries
#> [1] ""
#> 
#> [[27]]$playedBy
#> [1] ""
#> 
#> 
#> [[28]]
#> [[28]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/844"
#> 
#> [[28]]$id
#> [1] 844
#> 
#> [[28]]$name
#> [1] "Quentyn Martell"
#> 
#> [[28]]$gender
#> [1] "Male"
#> 
#> [[28]]$culture
#> [1] "Dornish"
#> 
#> [[28]]$born
#> [1] "In 281 AC, at Sunspear, Dorne"
#> 
#> [[28]]$died
#> [1] "In 300 AC, at Meereen"
#> 
#> [[28]]$alive
#> [1] FALSE
#> 
#> [[28]]$titles
#> [1] "Prince"
#> 
#> [[28]]$aliases
#> [1] "Frog"                         "Prince Frog"                 
#> [3] "The prince who came too late" "The Dragonrider"             
#> 
#> [[28]]$father
#> [1] ""
#> 
#> [[28]]$mother
#> [1] ""
#> 
#> [[28]]$spouse
#> [1] ""
#> 
#> [[28]]$allegiances
#> [1] "House Nymeros Martell of Sunspear"
#> 
#> [[28]]$books
#> [1] "A Game of Thrones" "A Clash of Kings"  "A Storm of Swords"
#> [4] "A Feast for Crows"
#> 
#> [[28]]$povBooks
#> [1] "A Dance with Dragons"
#> 
#> [[28]]$tvSeries
#> [1] ""
#> 
#> [[28]]$playedBy
#> [1] ""
#> 
#> 
#> [[29]]
#> [[29]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/954"
#> 
#> [[29]]$id
#> [1] 954
#> 
#> [[29]]$name
#> [1] "Samwell Tarly"
#> 
#> [[29]]$gender
#> [1] "Male"
#> 
#> [[29]]$culture
#> [1] "Andal"
#> 
#> [[29]]$born
#> [1] "In 283 AC, at Horn Hill"
#> 
#> [[29]]$died
#> [1] ""
#> 
#> [[29]]$alive
#> [1] TRUE
#> 
#> [[29]]$titles
#> [1] ""
#> 
#> [[29]]$aliases
#> [1] "Sam"              "Ser Piggy"        "Prince Pork-chop" "Lady Piggy"      
#> [5] "Sam the Slayer"   "Black Sam"        "Lord of Ham"     
#> 
#> [[29]]$father
#> [1] ""
#> 
#> [[29]]$mother
#> [1] ""
#> 
#> [[29]]$spouse
#> [1] ""
#> 
#> [[29]]$allegiances
#> [1] "House Tarly of Horn Hill"
#> 
#> [[29]]$books
#> [1] "A Game of Thrones"    "A Clash of Kings"     "A Dance with Dragons"
#> 
#> [[29]]$povBooks
#> [1] "A Storm of Swords" "A Feast for Crows"
#> 
#> [[29]]$tvSeries
#> [1] "Season 1" "Season 2" "Season 3" "Season 4" "Season 5" "Season 6"
#> 
#> [[29]]$playedBy
#> [1] "John Bradley-West"
#> 
#> 
#> [[30]]
#> [[30]]$url
#> [1] "https://www.anapioficeandfire.com/api/characters/957"
#> 
#> [[30]]$id
#> [1] 957
#> 
#> [[30]]$name
#> [1] "Sansa Stark"
#> 
#> [[30]]$gender
#> [1] "Female"
#> 
#> [[30]]$culture
#> [1] "Northmen"
#> 
#> [[30]]$born
#> [1] "In 286 AC, at Winterfell"
#> 
#> [[30]]$died
#> [1] ""
#> 
#> [[30]]$alive
#> [1] TRUE
#> 
#> [[30]]$titles
#> [1] "Princess"
#> 
#> [[30]]$aliases
#> [1] "Little bird"  "Alayne Stone" "Jonquil"     
#> 
#> [[30]]$father
#> [1] ""
#> 
#> [[30]]$mother
#> [1] ""
#> 
#> [[30]]$spouse
#> [1] "https://www.anapioficeandfire.com/api/characters/1052"
#> 
#> [[30]]$allegiances
#> [1] "House Baelish of Harrenhal" "House Stark of Winterfell" 
#> 
#> [[30]]$books
#> [1] "A Dance with Dragons"
#> 
#> [[30]]$povBooks
#> [1] "A Game of Thrones" "A Clash of Kings"  "A Storm of Swords"
#> [4] "A Feast for Crows"
#> 
#> [[30]]$tvSeries
#> [1] "Season 1" "Season 2" "Season 3" "Season 4" "Season 5" "Season 6"
#> 
#> [[30]]$playedBy
#> [1] "Sophie Turner"
#> 
#> 
str(lapply(got_chars, `[`, c("name", "culture")))
#> List of 30
#>  $ :List of 2
#>   ..$ name   : chr "Theon Greyjoy"
#>   ..$ culture: chr "Ironborn"
#>  $ :List of 2
#>   ..$ name   : chr "Tyrion Lannister"
#>   ..$ culture: chr ""
#>  $ :List of 2
#>   ..$ name   : chr "Victarion Greyjoy"
#>   ..$ culture: chr "Ironborn"
#>  $ :List of 2
#>   ..$ name   : chr "Will"
#>   ..$ culture: chr ""
#>  $ :List of 2
#>   ..$ name   : chr "Areo Hotah"
#>   ..$ culture: chr "Norvoshi"
#>  $ :List of 2
#>   ..$ name   : chr "Chett"
#>   ..$ culture: chr ""
#>  $ :List of 2
#>   ..$ name   : chr "Cressen"
#>   ..$ culture: chr ""
#>  $ :List of 2
#>   ..$ name   : chr "Arianne Martell"
#>   ..$ culture: chr "Dornish"
#>  $ :List of 2
#>   ..$ name   : chr "Daenerys Targaryen"
#>   ..$ culture: chr "Valyrian"
#>  $ :List of 2
#>   ..$ name   : chr "Davos Seaworth"
#>   ..$ culture: chr "Westeros"
#>  $ :List of 2
#>   ..$ name   : chr "Arya Stark"
#>   ..$ culture: chr "Northmen"
#>  $ :List of 2
#>   ..$ name   : chr "Arys Oakheart"
#>   ..$ culture: chr "Reach"
#>  $ :List of 2
#>   ..$ name   : chr "Asha Greyjoy"
#>   ..$ culture: chr "Ironborn"
#>  $ :List of 2
#>   ..$ name   : chr "Barristan Selmy"
#>   ..$ culture: chr "Westeros"
#>  $ :List of 2
#>   ..$ name   : chr "Varamyr"
#>   ..$ culture: chr "Free Folk"
#>  $ :List of 2
#>   ..$ name   : chr "Brandon Stark"
#>   ..$ culture: chr "Northmen"
#>  $ :List of 2
#>   ..$ name   : chr "Brienne of Tarth"
#>   ..$ culture: chr ""
#>  $ :List of 2
#>   ..$ name   : chr "Catelyn Stark"
#>   ..$ culture: chr "Rivermen"
#>  $ :List of 2
#>   ..$ name   : chr "Cersei Lannister"
#>   ..$ culture: chr "Westerman"
#>  $ :List of 2
#>   ..$ name   : chr "Eddard Stark"
#>   ..$ culture: chr "Northmen"
#>  $ :List of 2
#>   ..$ name   : chr "Jaime Lannister"
#>   ..$ culture: chr "Westerlands"
#>  $ :List of 2
#>   ..$ name   : chr "Jon Connington"
#>   ..$ culture: chr "Stormlands"
#>  $ :List of 2
#>   ..$ name   : chr "Jon Snow"
#>   ..$ culture: chr "Northmen"
#>  $ :List of 2
#>   ..$ name   : chr "Aeron Greyjoy"
#>   ..$ culture: chr "Ironborn"
#>  $ :List of 2
#>   ..$ name   : chr "Kevan Lannister"
#>   ..$ culture: chr ""
#>  $ :List of 2
#>   ..$ name   : chr "Melisandre"
#>   ..$ culture: chr "Asshai"
#>  $ :List of 2
#>   ..$ name   : chr "Merrett Frey"
#>   ..$ culture: chr "Rivermen"
#>  $ :List of 2
#>   ..$ name   : chr "Quentyn Martell"
#>   ..$ culture: chr "Dornish"
#>  $ :List of 2
#>   ..$ name   : chr "Samwell Tarly"
#>   ..$ culture: chr "Andal"
#>  $ :List of 2
#>   ..$ name   : chr "Sansa Stark"
#>   ..$ culture: chr "Northmen"
```
