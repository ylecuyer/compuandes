# encoding: utf-8

##
# Backup Generated: compuandes
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t compuandes [-c <path_to_configuration_file>]
#
# For more information about Backup's components, see the documentation at:
# http://backup.github.io/backup
#
Model.new(:compuandes, 'Compuandes (database and uploaded files)') do
  ##
  # Archive [Archive]
  #
  # Adding a file or directory (including sub-directories):
  #   archive.add "/path/to/a/file.rb"
  #   archive.add "/path/to/a/directory/"
  #
  # Excluding a file or directory (including sub-directories):
  #   archive.exclude "/path/to/an/excluded_file.rb"
  #   archive.exclude "/path/to/an/excluded_directory
  #
  # By default, relative paths will be relative to the directory
  # where `backup perform` is executed, and they will be expanded
  # to the root of the filesystem when added to the archive.
  #
  # If a `root` path is set, relative paths will be relative to the
  # given `root` path and will not be expanded when added to the archive.
  #
  #   archive.root '/path/to/archive/root'
  #
  archive :compuandes_shared do |archive|
    # Run the `tar` command using `sudo`
    # archive.use_sudo
    archive.add "/home/deploy/compuandes/shared/"
  end

  ##
  # PostgreSQL [Database]
  #
  database PostgreSQL do |db|
    # To dump all databases, set `db.name = :all` (or leave blank)
    db.name               = "compuandes"
    db.username           = "compuandes"
    db.password           = "compuandes"
    db.host               = "localhost"
    db.port               = 5432
    #db.socket             = "/tmp/pg.sock"
    # When dumping all databases, `skip_tables` and `only_tables` are ignored.
    #db.skip_tables        = ["tiger"]
    #db.only_tables        = ["only", "these", "tables"]
    db.additional_options = ["--exclude-schema=tiger", "--exclude-schema=topology"]
  end

  ##
  # Dropbox [Storage]
  #
  # Your initial backup must be performed manually to authorize
  # this machine with your Dropbox account. This authorized session
  # will be stored in `cache_path` and used for subsequent backups.
  #
  store_with Dropbox do |db|
    # Sets the path where the cached authorized session will be stored.
    # Relative paths will be relative to ~/Backup, unless the --root-path
    # is set on the command line or within your configuration file.
    db.cache_path  = ".cache"
    # :app_folder (default) or :dropbox
    db.access_type = :app_folder
    db.path        = "backups"
    db.keep        = 2
    # db.keep        = Time.now - 2592000 # Remove all backups older than 1 month.
  end

  ##
  # Bzip2 [Compressor]
  #
  compress_with Bzip2

  ##
  # Mail [Notifier]
  #
  # The default delivery method for Mail Notifiers is 'SMTP'.
  # See the documentation for other delivery options.
  #
  notify_by Mail do |mail|
    mail.on_success           = true
    mail.on_warning           = true
    mail.on_failure           = true
  end

end
