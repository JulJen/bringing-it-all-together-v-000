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


  def self.new_from_db(row)
    new_dog = {}
    new_dog[:id]= row[0]
    new_dog[:name] = row[1]
    new_dog[:breed] = row[2]
    new_dog = self.new(dog)
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
    sql = <<-SQL
      SELECT *
      FROM dogs
      WHERE id = ?
    SQL
    result = DB[:conn].execute(sql, id)[0]

  #   DB[:conn].execute(sql, name).map do |row|
  #     self.new_from_db(row)
  #   end.first
  # end

    dog = {}
    dog[:id] = result[0]
    dog[:name] = result[1]
    dog[:breed] = result[2]
    dog = self.new(dog)
  end



  # def  self.find_or_create_by(name:, breed:)
  #   dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed)
  #   if !dog.empty?
  #     dog_data = dog[0]
  #     dog = self.new(dog_data [0], dog_data [1], dog_data[2])
  #   else
  #     dog = self.create(name: name, breed: breed)
  #   end
  #   dog
  # end



end


  # takes in a hash of attributes and uses metaprogramming to create a new dog object. Then it uses the save method to save that dog to the database
