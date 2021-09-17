class CsvImportsController < ApplicationController

	def index

	end

	def create
		@csv = CsvImport.import(params[:file])
		session[:year] = params[:year]
		session[:team] = params[:team]
		if @csv
			redirect_to csv_import_path(@csv)
		else
			redirect_to csv_imports_path
		end
	end

	def show
		@data_total = []
		if session[:year].present? && session[:team].empty?
			@data = CsvImport.all.group(:player_id).where(year_id: session[:year])
		elsif session[:team].present? && session[:year].empty?
			@data = CsvImport.all.group(:player_id).where(team_id: session[:team])
		elsif session[:team].present? && session[:year].present?
			@data = CsvImport.all.group(:player_id).where(year_id: session[:year], team_id: session[:team])
		else
			@data = CsvImport.all.group(:player_id)
		end
		@data.each do |d|
			team_ids = CsvImport.where(player_id: d.player_id).pluck(:team_id) rescue nil
			team_names = Team.where(id: team_ids).pluck(:team_name) rescue nil
		
			batting_average = 0
			if team_ids.length > 1
				players = CsvImport.where(player_id: d.player_id)
				players&.each do |p|
					average = p&.h/p&.ab
					batting_average += average
				end
			else
				batting_average = d&.h/d&.ab
			end
			@data_total << { player_id: d&.player_id, year_id: d&.year_id, team_name: team_names, batting_average: batting_average }
			@data_total = @data_total.sort_by { |h | h[:batting_average] }.reverse!		
		end
	end
end
