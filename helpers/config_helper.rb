require 'yaml'
require 'logger'

class ConfigHelper

  @logger = Logger.new(STDOUT)
  @logger.level = Logger::INFO

  @config_yaml = YAML.load_file 'config/config.yml'

  def self.config(tag)
    @config_yaml[tag]
  end

  def self.get_text_message(id)
    config(:messages)[id]
  end

  def self.log(message)
    @logger.info(
        "GotSurfService #{message.from.username} id.#{message.from.id} at #{Time.now} from #{message.from.language_code}"
    )
  end

end
