module Dapp
  module Builder
    # Base
    class Base
      attr_reader :application

      def initialize(application)
        @application = application
      end

      def before_application_export
      end

      def before_application_run
      end

      def before_install?
        false
      end

      def before_install(_image)
        raise
      end

      def before_install_checksum
        raise
      end

      def before_setup?
        false
      end

      def before_setup(_image)
        raise
      end

      def before_setup_checksum
        raise
      end

      def install?
        false
      end

      def install(_image)
        raise
      end

      def install_checksum
        raise
      end

      def setup?
        false
      end

      def setup(_image)
        raise
      end

      def setup_checksum
        raise
      end

      def chef_cookbooks(_image)
      end

      def chef_cookbooks_checksum
        []
      end
    end # Base
  end # Builder
end # Dapp
