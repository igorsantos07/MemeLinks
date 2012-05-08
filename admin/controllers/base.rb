# -*- encoding : utf-8 -*-
Admin.controllers :base do

  get :index, :map => "/" do
    clicky = Getclicky::Client.new

    visits_json = clicky.multiple(
      [:visitors, :visitors_unique, :visitors_new, :actions],
      {:output => :json, :date => 'last-14-days', :daily => true}
    )
    @visits = {}
    JSON.parse(visits_json, :symbolize_names => true).each do |data|
      key = data[:type].gsub('-','_').to_sym
      data[:dates].each do |n|
        date_parts = n[:date].split '-'
        date = date_parts[2]+'/'+date_parts[1]
        @visits[date] = {} if @visits[date].nil?
        @visits[date][key] = n[:items][0][:value].to_i
      end
    end

    countries_json = clicky.countries :output => :json, :date => 'last-14-days', :limit => 10
    @countries = {}
    JSON.parse(countries_json, :symbolize_names => true)[0][:dates].each do |raw_data|
      raw_data[:items].each do |country|
        name = case country[:title].downcase
          when 'the united states'  then 'USA'
          when 'the united kingdom' then 'UK'
          when 'spain'              then 'ESP'
          else country[:title][0...3].upcase
        end

        @countries[name] = country[:value].to_i
      end
    end

    render "base/index"
  end
end