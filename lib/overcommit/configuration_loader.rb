require 'yaml'

module Overcommit
  # Manages configuration file loading.
  class ConfigurationLoader
    DEFAULT_CONFIG_PATH = File.join(OVERCOMMIT_HOME, 'config', 'default.yml')

    class << self
      def load_repo_config
        overcommit_yml = File.join(Overcommit::Utils.repo_root,
                                   OVERCOMMIT_CONFIG_FILE_NAME)

        if File.exist?(overcommit_yml)
          load_file(overcommit_yml)
        else
          default_configuration
        end
      end

      def default_configuration
        @default_config ||= load_from_file(DEFAULT_CONFIG_PATH)
      end

      private

      # Loads a configuration, ensuring it extends the default configuration.
      def load_file(file)
        config = load_from_file(file)

        default_configuration.merge(config)
      rescue => error
        raise Overcommit::Exceptions::ConfigurationError,
              "Unable to load configuration from '#{file}': #{error}",
              error.backtrace
      end

      def load_from_file(file)
        hash =
          if yaml = YAML.load_file(file)
            yaml.to_hash
          else
            {}
          end

        Overcommit::Configuration.new(hash)
      end
    end
  end
end
