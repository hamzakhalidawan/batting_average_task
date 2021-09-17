class CsvImport < ApplicationRecord
  require 'csv'

  def self.import(file)
    if file.present?
      CSV.foreach(file.path, headers: true) do |row|
        to_hash = row.to_hash

        # Deal with to_hash header and data. Example Create
        CsvImport.create(player_id: to_hash['player_id'],
          year_id: to_hash['year_id'],
          stint: to_hash['stint'],
          team_id: to_hash['team_id'],
          ab: to_hash['ab'],
          h: to_hash['h'] ) rescue nil
      end
    end
  end
end
