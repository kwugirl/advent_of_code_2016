def count_letter_frequencies(str)
  freq = Hash.new(0)
  str.each_char {|char| freq[char] += 1 unless char == '-' }
  freq
end

def group_letters_by_count(freq)
  grouping = {}
  freq.each do |letter, count|
    grouping[count] = "#{grouping[count]}#{letter}".chars.sort.join
  end
  grouping
end

def checksum_for_name(name)
  letter_freq = count_letter_frequencies(name)
  letters_grouped_by_counts = group_letters_by_count(letter_freq)

  checksum_for_name = ''
  letters_grouped_by_counts.sort.reverse.each do |grouping|
    checksum_for_name << grouping[1]
    return checksum_for_name[0..4] if checksum_for_name.length >= 5
  end
end

def real_room?(name, checksum)
  checksum_for_name(name) == checksum
end

def parse_line(line)
  regex_result = line.match /^(\D+)-(\d+)\[([a-z]+)\]$/
  {name: regex_result[1], sector_id: regex_result[2].to_i, checksum: regex_result[3]}
end

def sum_valid_room_sector_ids(filename)
  sector_ids_sum = 0
  File.readlines(filename).each do |line|
    parsed_line = parse_line(line)
    sector_ids_sum += parsed_line[:sector_id] if real_room?(parsed_line[:name], parsed_line[:checksum])
  end

  sector_ids_sum
end

# Part A
# puts sum_valid_room_sector_ids('day_4_input.txt')

##########################################

# Part B

def decrypted_name(name, shift)
  name.chars.map.with_index do |char, i|
    name[i] = decrypted_character(char, shift)
  end
  name
end

def decrypted_character(char, shift)
  alphabet = ('a'..'z').to_a

  if char == '-'
    ' '
  else
    char_index = alphabet.find_index(char)
    decrypted_character_index = (char_index + shift) % 26
    alphabet[decrypted_character_index]
  end
end

def find_room(filename, room_name)
  File.readlines(filename).each do |line|
    parsed_line = parse_line(line)
    valid_room = real_room?(parsed_line[:name], parsed_line[:checksum])
    plaintext_name = decrypted_name(parsed_line[:name], parsed_line[:sector_id])

    if valid_room && plaintext_name == room_name
      return parsed_line[:sector_id]
    end
  end
end

# puts find_room('day_4_input.txt', 'northpole object storage')
