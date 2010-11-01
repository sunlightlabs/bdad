module SketchesHelper

  def view_box(bounds)
    [
      bounds[:min_x],
      bounds[:min_y],
      bounds[:max_x] - bounds[:min_x],
      bounds[:max_y] - bounds[:min_y],
    ].join(' ')
  end

  def fun_name
    NAMES.choice
  end
  
  def adjective
    ADJECTIVES.choice
  end

  def fun_title(district)
    "The #{adjective} " + case district.district_code.to_i
    when 1  then "First"
    when 2  then "Second"
    when 3  then "Third"
    when 4  then "Fourth"
    when 5  then "Fifth"
    when 6  then "Sixth"
    when 7  then "Seventh"
    when 8  then "Eighth"
    when 9  then "Ninth"
    when 10 then "Tenth"
    when 11 then "Eleventh"
    when 12 then "Twelfth"
    when 13 then "Thirteenth"
    when 14 then "Fourteenth"
    when 15 then "Fifteenth"
    when 16 then "Sixteenth"
    when 17 then "Seventeenth"
    when 18 then "Eighteenth"
    when 19 then "Nineteenth"
    when 20 then "Twentieth"
    when 21 then "Twenty-First"
    when 22 then "Twenty-Second"
    when 23 then "Twenty-Third"
    when 24 then "Twenty-Fourth"
    when 25 then "Twenty-Fifth"
    when 26 then "Twenty-Sixth"
    when 27 then "Twenty-Seventh"
    when 28 then "Twenty-Eighth"
    when 29 then "Twenty-Ninth"
    when 30 then "Twirthieth"
    when 31 then "Thirty-First"
    when 32 then "Thirty-Second"
    when 33 then "Thirty-Third"
    when 34 then "Thirty-Fourth"
    when 35 then "Thirty-Fifth"
    when 36 then "Thirty-Sixth"
    when 37 then "Thirty-Seventh"
    when 38 then "Thirty-Eighth"
    when 39 then "Thirty-Ninth"
    when 40 then "Fourtieth"
    when 41 then "Fourty-First"
    when 42 then "Fourty-Second"
    when 43 then "Fourty-Third"
    when 44 then "Fourty-Fourth"
    when 45 then "Fourty-Fifth"
    when 46 then "Fourty-Sixth"
    when 47 then "Fourty-Seventh"
    when 48 then "Fourty-Eighth"
    when 49 then "Fourty-Ninth"
    when 50 then "Fiftieth"
    when 51 then "Fifty-First"
    when 52 then "Fifty-Second"
    when 53 then "Fifty-Third"
    when 54 then "Fifty-Fourth"
    when 55 then "Fifty-Fifth"
    when 56 then "Fifty-Sixth"
    when 57 then "Fifty-Seventh"
    when 58 then "Fifty-Eighth"
    when 59 then "Fifty-Ninth"
    end
  end

  ADJECTIVES = %w(
    Able
    Agile
    Arid
    Bizarre
    Boring
    Circular
    Comely
    Contorted
    Dodgy
    Dogged
    Effervescent
    Elegant
    Fantastic
    Fickle
    Fiesty
    Fighting
    Flip-Flopping
    Fun
    Fun-Filled
    Funny
    Gargantuan
    Graceful
    Herculean
    Heroic
    Humid
    Jaundiced
    Lackadaisical
    Lilliputian
    Lucky
    Misshapen
    Mysterious
    Nimble
    Oddball
    Ornery
    Perfectly-Shaped
    Powerful
    Rambunctious
    Really-Messed-Up
    Rectangular
    Ridiculous
    Round
    Rowdy
    Scrappy
    Serious
    Silly
    Slothful
    Squarish
    Staid
    Strangely-Shaped
    Strapping
    Stupendous
    Successful
    Terrible
    Thoughtful
    Tomfoolerous
    Trapezoidal
    Triangular
    Zany
  )

  NAMES = [
    "Al Franken",
    "Alan Abel",
    "Alexander Hamilton",
    "Andy Warhol",
    "Bill Maher",
    "Chris Rock",
    "Claude Monet",
    "Dante Alighieri",
    "David Cross",
    "David Hasselhoff",
    "Dennis Miller",
    "Elbridge Gerry",
    "George Carlin",
    "George Washingon",
    "Glenn Beck",
    "Henri de Toulouse-Lautrec",
    "Henri Matisse",
    "Henri Rousseau",
    "Howard Dean",
    "Janeane Garofalo",
    "Jerry Seinfeld",
    "John Adams",
    "John Stewart",
    "Karl Rove",
    "Leonardo Da Vinci",
    "Lewis Black",
    "Michelangelo",
    "Niccolo Machiavelli",
    "Pablo Picasso",
    "Patton Oswalt",
    "Paul Klee",
    "Pierre-Auguste Renoir",
    "Rick Astley",
    "Salvador Dali",
    "Stephen Colbert",
    "Thomas Jefferson",
    "Vincent Van Gogh",
  ]

end
