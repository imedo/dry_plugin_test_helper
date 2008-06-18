class CreateEnvironment < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.column :title, :string
      t.column :body, :text
      t.column :author_id, :integer
      t.column :active, :integer, :default => 1
      t.column :hidden, :integer, :default => 0
      t.column :deactivated_at, :datetime
    end

    create_table :authors do |t|
      t.column :name, :string
    end

    create_table :comments do |t|
      t.column :body, :text
      t.column :article_id, :integer
      t.column :user_id, :integer
    end

    create_table :users do |t|
      t.column :name, :string
    end  
  end
  
  def self.down
    drop_table :articles
    drop_table :authors
    drop_table :comments
    drop_table :users
  end
end