namespace :common do

  require 'term/ansicolor'
  class String
    include Term::ANSIColor
  end

  desc 'populates meme.name_lower and lowercases all keywords'
  task :lowercase_fields do
    Meme.all.each do |meme|
      puts meme.name.bold
      print "\tName     "
      if meme.update_attribute :name_lower, meme.name.downcase then puts 'OK!'.green else puts 'Ops :('.red.bold end
      print "\tKeywords "
      if meme.update_attribute :keywords, meme.keywords then puts 'OK!'.green else puts 'Ops :('.red.bold end
    end
  end

end