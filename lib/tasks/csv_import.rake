require 'csv'

namespace :import_csv do
  task :data => :environment do
    CSV.foreach('team.csv', headers: true) do |row|
        to_hash = row.to_hash

        # Deal with to_hash header and data. Example Create
        Team.create(id: to_hash['id'],
          team_name: to_hash['team_name'] ) rescue nil
      end
  end
end 