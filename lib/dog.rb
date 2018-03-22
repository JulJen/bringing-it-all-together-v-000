require 'pry'

require_relative "../config/environment.rb"

class Dog
  attr_accessor :name, :breed
  attr_reader :id

  def initialize(id:nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
        )
    SQL
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS dogs"

    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO dogs(name, breed)
        VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end
    self
  end


  def update
    sql = "UPDATE dogs SET name = ? WHERE id = ?"

    DB[:conn].execute(sql, self.name, self.id)
  end

  def self.create(row)
    dog = Dog.new(row)
    dog.save
    dog
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM dogs WHERE id = ?"
    result = DB[:conn].execute(sql, id)[0]

binding.pry
    dog = {}
    dog[:id] = result[0]
    dog[:name] = result[1]
    dog[:breed] = result[2]
    dog = self.new(dog)
    dog.save
    dog
  end



end


  # takes in a hash of attributes and uses metaprogramming to create a new dog object. Then it uses the save method to save that dog to the database
