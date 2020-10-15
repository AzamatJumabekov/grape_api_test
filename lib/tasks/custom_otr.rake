namespace :db do
  namespace :test do
    task :environment do
      ENV['RACK_ENV'] = 'test'
    end
  end if OTR::ActiveRecord._normalizer.force_db_test_env?

  desc "Create a migration"
  task :create_migration_custom, [:name] do |_, args|
    name, version = args[:name], Time.now.utc.strftime("%Y%m%d%H%M%S")

    OTR::ActiveRecord._normalizer.migrations_paths.each do |directory|
      next unless File.exists?(directory)
      migration_files = Pathname(directory).children
      if duplicate = migration_files.find { |path| path.basename.to_s.include?(name) }
        abort "Another migration is already named \"#{name}\": #{duplicate}."
      end
    end

    filename = "#{version}_#{name}.rb"
    dirname = OTR::ActiveRecord._normalizer.migrations_path
    path = File.join(dirname, filename)

    FileUtils.mkdir_p(dirname)
    require 'pry'
    binding.pry
    File.write path, <<-MIGRATION.strip_heredoc
      class #{name.camelize} < #{OTR::ActiveRecord._normalizer.migration_base_class_name}
        def change
        end
      end
    MIGRATION

    puts path
  end
end
