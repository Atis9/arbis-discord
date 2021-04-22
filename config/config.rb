module Arbis
  class Config
    def self.load_and_define(filepath)
      path = Pathname.new(filepath)
      raise "Not found: #{path.to_s}" if !path.exist?

      @@config ||= {}
      name = path.basename(".*").to_s
      @@config[name] = YAML.load_file(path.to_s)
      define_singleton_method(name, Proc.new { @@config[name] })
    end
  end
end
