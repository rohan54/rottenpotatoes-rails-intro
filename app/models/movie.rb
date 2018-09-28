class Movie < ActiveRecord::Base

    def self.get_valid_ratings
        obj = ['G','PG','PG-13','R']
    end
    
end
