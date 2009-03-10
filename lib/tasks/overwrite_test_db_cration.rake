
module Rake
  module TaskManager
    def redefine_task(task_class, args, &block)
      task_name, deps = resolve_args([args])
      task_name = task_class.scope_name(@scope, task_name)
      deps = [deps] unless deps.respond_to?(:to_ary)
      deps = deps.collect {|d| d.to_s }
      task = @tasks[task_name.to_s] = task_class.new(task_name, self)
      task.application = self
#      task.add_description(@last_description)
      @last_description = nil
      task.enhance(deps, &block)
      task
    end
  end
  class Task
    class << self
      def redefine_task(args, &block)
        Rake.application.redefine_task(self, args, &block)
      end
    end
  end
end

namespace :db do
  namespace :test do

    # puts 'trying to redifine task'
    # desc 'Prepare the test database and migrate schema'
    Rake::Task.redefine_task :prepare => :environment do
      ENV["RAILS_ENV"] = "test"
      Rake::Task['ept:clean_and_migrate_schema'].invoke
      # Rake::Task['db_init_data:generate_data'].invoke
      # Rake::Task['ept:load_test_data'].invoke
    end
    # puts 'task redefined'

  end
end

namespace :ept do
#  task :all_specs do
#    puts 'reinitialising DB (ept:clean_and_migrate_schema)'
#    puts Rake::Task['ept:clean_and_migrate_schema'].methods.map{|m| m=~/invoke|exec/ ? m : nil }.compact.inspect 
#    Rake::Task['ept:clean_and_migrate_schema'].invoke # invoke_with_call_chain # , invoke_prerequisites
#    puts 'loading test data (ept:load_test_data)'
#    Rake::Task['ept:load_test_data'].invoke
#
#    puts 'executing spec:models'
#    Rake::Task['spec:models'].invoke
#    puts 'executing spec:controllers'
#    Rake::Task['spec:controllers'].invoke
#  end

#  task :load_test_data do
#    ActiveRecord::Base.establish_connection(:test)
#    puts 'los gehts'
#    generator_classes = [
#      PeopleTestDataGenerator,
#      CommissionRatesTestDataGenerator,
#      RegionsTestDataGenerator,
#      GrapeVarietiesTestDataGenerator,
#      AddressesTestDataGenerator,
#      AuctionsTestDataGenerator,
#      DetailedAuctionsTestDataGenerator
#    ]
#    
#    for klass in generator_classes
#      puts "generating testdata with: #{klass.name}"
#      klass.setup
#    end
#  end
  
    desc 'Use the migrations to create the test database'
    task :clean_and_migrate_schema do
      Rake::Task['db:test:purge'].invoke
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])
      
      connection = ActiveRecord::Base.connection
      
      # load testdata from sql file
      
      puts "starting transaction"
      connection.transaction do
        f = File.new("spec/testdata/scroooge_development.sql")
        command = ''
        f.each do |line|
          puts line
          unless line =~ /\A\s*--/ # ignore comments
            if line =~ /(.*);\s*\Z/ # cut off semicolons at the end of a command
              puts "\n\n executing\n\n"
              connection.execute command + $1
              command = ''
            else
              command += line 
            end
          end
        end
      end
        
      # execute migrations that have written sinde the testdata has been dumped
      ActiveRecord::Migrator.migrate("db/migrate/")
    end

end