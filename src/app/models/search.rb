# TODO: use it in suitable controller
class Search < ActiveRecord::BaseWithoutTable
  column :pharse
  validates_length_of :pharse, :within => 3..256
end

