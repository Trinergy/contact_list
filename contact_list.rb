require_relative 'contact'
# # Interfaces between a user and their contact list. Reads from and writes to standard I/O

puts "Here is a list of available commands: \b
       new      - Create a new contact\b
       list     - List all contacts\b
       show     - Show a contact\b
       search   - Search contacts\b
       update   - update contact\b
       delete   - remove contact"

  if ARGV.first
    user_input = ARGV.first
  else
    user_input = gets.chomp
  end

  case user_input
  when "new"
    ARGV.clear
    puts "What is your new contact's name?"
    contact_name = gets.chomp
    puts "What is #{contact_name}'s email?"
    contact_email = gets.chomp
    Contact.create(name: contact_name,
                   email: contact_email)
  when "list"
    Contact.all.each do |contact|
      puts contact.inspect
    end
  when "show"
    if ARGV.length > 1
      id = ARGV[1]
    else
      ARGV.clear
      puts "Please enter the contact's id: "
      id = gets.chomp.to_s
    end
    puts Contact.find(id).inspect
  when "search"
    if ARGV.length > 1
      input = ARGV[1]
    else
      ARGV.clear
      puts "Please enter the contact's name or email: "
      input = gets.chomp.to_s
    end
    Contact.where("name LIKE '%' || ? || '%' OR email LIKE '%' || ? || '%'", input, input).each do |contact|
      puts contact.inspect
    end
  when "update"
    if ARGV.length > 1
      input = ARGV[1]
    else
      ARGV.clear
      puts "Please enter the contact's id: "
      input = gets.chomp.to_s
    end
    ARGV.clear
    contact = Contact.find(input)
    puts "What is #{contact.name}'s new name? "
    name = gets.chomp
    puts "What is #{contact.name}'s new email? \b old email:#{contact.email}"
    email = gets.chomp
    contact.update(name: name, email: email)
  when "delete"
    if ARGV.length > 1
      input = ARGV[1]
    else
      ARGV.clear
      puts "Please enter the contact's id: "
      input = gets.chomp.to_s
    end
    Contact.find(input).destroy
  end