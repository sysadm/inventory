namespace :backup do
  desc 'import backup from csv file'
  task :import => :environment do
    file = ENV['csv']
    begin
      csv = File.open file
    rescue => e
      puts "Wrong filename or path"
      exit(1)
    end
    puts "Start import at: #{Time.now}"
    result = Backup.rollback_from_file file
    puts "Finish import at: #{Time.now}"
    puts "Complete." unless result == 1
  end
end
