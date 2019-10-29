class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.json_format(*keys)
    keys.each do |key|
      define_method "#{key}_json" do |option=nil|
        begin
          JSON.parse(self.send(key)).symbolize_keys
        rescue
          {}
        end
      end

      define_method "#{key}_json=" do |d|
        self.send("#{key}=", d.to_json)
      end

      define_method "#{key}_json_append" do |k, v|
        s = self.send("#{key}_json")
        s[k] = v
        self.send("#{key}_json=", s)
      end
    end
  end

end
