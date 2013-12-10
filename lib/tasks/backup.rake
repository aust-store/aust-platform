namespace :backup do
  desc "Back up the uploaded files"
  task :uploads do
    if Rails.env.production?
      Bundler.with_clean_env do
        sh "RAILS_ENV=#{Rails.env} backup perform --trigger uploads_backup --config_file config/backup/uploads.rb --data-path public/uploads --log-path log --tmp-path tmp"
      end
      return true
    end
  end

  desc "Back up the cloud theme files"
  task :themes do
    if Rails.env.production?
      Bundler.with_clean_env do
        sh "RAILS_ENV=#{Rails.env} backup perform --trigger themes_backup --config_file config/backup/themes.rb --data-path public/themes/cloud --log-path log --tmp-path tmp"
      end
      return true
    end
  end
end
