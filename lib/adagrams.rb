require 'csv'

dict_path = "./assets/dictionary-english.csv"
$dictionary = CSV.read(dict_path, headers: true).map { |row| row[0] }

# A method to build a hand of 10 letters for the user.
def draw_letters
  # Letters      A  B  C  D  E   F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z
  letter_dist = [9, 2, 2, 4, 12, 2, 3, 2, 9, 1, 1, 4, 2, 6, 8, 2, 1, 6, 4, 6, 4, 2, 2, 1, 2, 1]
  hand_size = 10
  # ASCII table number for a
  letter_a_offset = 65
  
  letter_pool = letter_dist.map.with_index { |dist, index| (index + letter_a_offset).chr * dist }
  return letter_pool.join('').split('').sample(hand_size)
end

# A method to check if the word is an anagram of some or all of the given letters in the hand.
def uses_available_letters?(input, letter_in_hand)
  hand_copy = letter_in_hand.clone
  input.upcase.split("").each do |letter|
    if hand_copy.include?(letter)
      hand_copy.delete_at(hand_copy.index(letter))
    else
      return false
    end
  end
  return true
end

# A method that returns the score of a given word as defined by the Adagrams game.
def score_word(word)
  letter_values = word.upcase.split("").map do |letter|
    case letter
      when "A", "E", "I", "O", "U", "L", "N", "R", "S", "T"
        1
      when "D", "G"
        2
      when "B", "C", "M", "P"
        3
      when "F", "H", "V", "W", "Y"
        4
      when "K"
        5
      when "J", "X"
        8
      when "Q", "Z"
        10
    end
  end
  
  if word.length >= 7 && word.length <= 10
    letter_values << 8
  end
  
  return letter_values.sum
end

# A method looks at the array of words and calculates which of these words has the highest score.
def highest_score_from(words)
  maximum_score = words.map { |word| score_word(word) }.max
  highest = words.select { |word| score_word(word) == maximum_score }
  if highest.length == 1  
    winning_word = highest.first
  else
    highest_lengths = highest.map {|i| i.length}
    if highest_lengths.any? { |x| x == 10}
      index_of_length_10 = highest_lengths.find_index(10)
      winning_word  = highest[index_of_length_10]
    else
      winning_word = highest[highest_lengths.find_index(highest_lengths.min)]
    end   
  end

  results = Hash.new
  results[:score]  = maximum_score
  results[:word] = winning_word 

  return results
end

def is_in_english_dict?(input)
  return $dictionary.include?(input)
end