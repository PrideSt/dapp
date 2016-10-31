module Dapp
  module Config
    module Directive
      class Base < Config::Base
        def initialize(&blk)
          instance_eval(&blk) unless blk.nil?
        end

        protected

        def clone
          marshal_dup(self)
        end

        def clone_to_artifact
          raise
        end
      end
    end
  end
end