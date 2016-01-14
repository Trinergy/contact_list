require 'csv'

# Represents a person in an address book.
class Contact

  attr_accessor :name, :email
  

  def initialize(name, email)
    @name = name
    @email = email
    index = CSV.read('contacts.csv').length + 1
    contacts = File.open('contacts.csv', 'a')
    contacts.puts "#{index}, #{name}, #{email}"
  end



  # Provides functionality for managing a list of Contacts in a database.
  class << self

    # Returns an Array of Contacts loaded from the database.
    def all
      contacts = CSV.read('contacts.csv')
      contacts
      # TODO: Return an Array of Contact instances made from the data in 'contacts.csv'.
    end

    # Creates a new contact, adding it to the database, returning the new contact.
    def create(name, email)
      Contact.new name, email
      # TODO: Instantiate a Contact, add its data to the 'contacts.csv' file, and return it.
    end

    # Returns the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      id = id.to_s
      CSV.foreach('contacts.csv') do |row|
        return row if row.include?(id)
      end
    end

    # Returns an array of contacts who match the given term.
    #use select and maybe come up with a method that changes the display
    def search(term)
      term = term.to_s
      File.open('contacts.csv').readlines.each do |line|
        puts line if line.include?(term)
      end

      # TODO: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
    end

  end

end

# print Contact.all

# print Contact.find(1)

# contacts = File.open('contacts.csv', 'wb') do |file|
#   file.readlines.each_with_index do |line, idx|
#     puts idx
#   end
# end

# contacts = CSV.read('contacts.csv')
# puts contacts.length

# contacts = File.open('contacts.csv', 'a')
# contacts.puts "hello"


# Contact.search("@gmail")

# puts Contact.find(3)




