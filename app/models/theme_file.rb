class ThemeFile
  FILES_WHITELIST = [
    "layout.mustache",
    "home.mustache",
    "product.mustache",
    "style.css",
    "application.js"
  ]

  def initialize(theme, filename = nil)
    @theme = theme
    @filename = filename
    @theme_files = []
  end

  def find(filename)
    found = all_files.find { |file| file == filename }
    self.class.new(theme, found) if found.present?
  end

  def all
    all_files.sort.map do |filename|
      self.class.new(theme, filename)
    end
  end

  def update_attributes(attributes)
    if attributes[:body].present?
      return if path =~ /\/checked_out\//
      File.open(path, "w+") { |f| f.write(attributes[:body]) }
    end
  end

  def id
    filename
  end

  def filename
    @filename
  end

  def body
    File.read(path)
  end

  def name
    I18n.t("#{i18n_string}.name")
  end

  def description
    I18n.t("#{i18n_string}.description")
  end

  def to_json
    { id:          id,
      filename:    filename,
      name:        name,
      description: description,
      theme_id:    theme.id,
      body:        body }
  end

  private

  attr_reader :theme

  def all_files
    @all_files ||= Dir.glob("#{theme.full_path}/*").keep_if do |full_path|
      filename = full_path.split("/").last
      FILES_WHITELIST.include?(filename)
    end.map do |file_path|
      file_path.split("/").last
    end
  end

  def path
    [theme.full_path, filename].join("/")
  end

  def i18n_string
    @i18n_string ||= "admin.theme_files.#{filename.gsub(/\./, "_")}"
  end
end
