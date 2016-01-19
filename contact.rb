require 'pg'

# Represents a person in an address book.
class Contact

  attr_accessor :name, :email, :id

  DATABASE_NAME = 'contact_list'

  
  def save
    if persisted?
      res = self.class.conn.exec_params('UPDATE contacts SET name = $2, email = $3 WHERE id = $1::int;', [id, name, email])
    else
      res = self.class.conn.exec_params('INSERT INTO contacts (name, email) VALUES ($1, $2) RETURNING id', [name, email])
      self.id = res[0]['id']
    end
  end

  #FORMATTING - when typing puts, it first converts to string, so you format it overwriting to_s
  def to_s
    "id: #{id}\nname: #{name}\nemail: #{email}\n"
  end

  def persisted?
    !id.nil?
  end

  def destroy
    res = self.class.conn.exec_params('DELETE FROM contacts WHERE id = $1::int;', [id])
  end




  # Provides functionality for managing a list of Contacts in a database.
  class << self

    def conn
      PG::Connection.open(dbname: DATABASE_NAME)
    end

    def all
      res = conn.exec_params('SELECT * FROM contacts;')
      res.each do |contact|
        puts contact
      end
    end

    # Creates a new contact, adding it to the database, returning the new contact.
    def create
      puts "Please input contact's name: "
      name = gets.chomp
      puts "Please input contact's email: "
      email = gets.chomp
      new_contact = Contact.new
      new_contact.name = name
      new_contact.email = email
      new_contact.save
      puts "You have added:"
      puts new_contact
    end

    # Returns the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      res = conn.exec_params('SELECT * FROM contacts WHERE id = $1::int;',[id])
      found_contact = Contact.new
      found_contact.id = res[0]['id']
      found_contact.name = res[0]['name']
      found_contact.email = res[0]['email']
      found_contact
    end

    # Returns an array of contacts who match the given term.
    #use select and maybe come up with a method that changes the display
    def search(input)
      res = conn.exec_params("SELECT * FROM contacts WHERE name LIKE '%' || $1 || '%' OR email LIKE '%' || $1 || '%';", [input])
      if res.num_tuples == 0
        "No contacts found"
      else
        res.each do |contact|
          found_contact = Contact.new
          found_contact.id = contact['id']
          found_contact.name = contact['name']
          found_contact.email = contact['email']
          puts found_contact
        end
      end
    end

    def update(id)
      the_contact = find(id)
      puts "What is #{the_contact.name}'s new name? "
      new_name = gets.chomp
      puts "What will #{the_contact.name}'s new email be?\n old email:#{the_contact.email} "
      new_email = gets.chomp
      the_contact.name = new_name
      the_contact.email = new_email
      the_contact.save
      puts "You have updated the contact's info to: "
      puts the_contact
    end

    def delete(id)
      the_contact = find(id)
      name = the_contact.name
      the_contact.destroy
      puts "#{name} has been deleted from your contact list"
    end

  end

end

















