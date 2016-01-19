require_relative 'contact'
require 'pg'

# # Interfaces between a user and their contact list. Reads from and writes to standard I/O.



# class ContactList

#   # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  
  
# end

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
    puts "Please input the new contact's name: "
    name = gets.chomp.to_s.capitalize!
    puts "Please input the new contact's email: "
    email = gets.chomp.to_s
    Contact.create(name, email)
    puts "Your new contact has been added to the list."
  when "list"
    puts Contact.all
  when "show"
    if ARGV.length > 1
      id = ARGV[1]
    else
      ARGV.clear
      puts "Please enter the contact's index: "
      id = gets.chomp.to_s
    end
    puts Contact.find(id)
  when "search"
    if ARGV.length > 1
      input = ARGV[1]
    else
      ARGV.clear
      puts "Please enter the contact's name or email: "
      input = gets.chomp.to_s
    end
    Contact.search(input)
  when "update"
    if ARGV.length > 1
      input = ARGV[1]
    else
      ARGV.clear
      puts "Please enter the contact's id: "
      input = gets.chomp.to_s
    end
    ARGV.clear
    Contact.update(input)
  when "delete"
    if ARGV.length > 1
      input = ARGV[1]
    else
      ARGV.clear
      puts "Please enter the contact's id: "
      input = gets.chomp.to_s
    end
    Contact.delete(input)
  end