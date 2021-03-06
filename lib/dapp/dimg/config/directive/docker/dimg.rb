module Dapp
  module Dimg
    module Config
      module Directive
        module Docker
          class Dimg < Base
            attr_reader :_volume, :_expose, :_env, :_label, :_cmd, :_onbuild, :_workdir, :_user, :_entrypoint

            def initialize(**kwargs, &blk)
              @_volume = []
              @_expose = []
              @_env = {}
              @_label = {}
              @_cmd = []
              @_onbuild = []

              super(**kwargs, &blk)
            end

            def volume(*args)
              sub_directive_eval { @_volume.concat(args) }
            end

            def expose(*args)
              sub_directive_eval { @_expose.concat(args) }
            end

            def env(**options)
              sub_directive_eval { @_env.merge!(options) }
            end

            def label(**options)
              sub_directive_eval { @_label.merge!(options) }
            end

            def cmd(*args)
              sub_directive_eval { @_cmd.concat(args) }
            end

            def onbuild(*args)
              sub_directive_eval { @_onbuild.concat(args) }
            end

            def workdir(path)
              sub_directive_eval { @_workdir = path_format(path) }
            end

            def user(val)
              sub_directive_eval { @_user = val }
            end

            def entrypoint(*cmd_with_args)
              sub_directive_eval { @_entrypoint = cmd_with_args.flatten }
            end

            def _change_options
              {
                volume: _volume,
                expose: _expose,
                env: _env,
                label: _label,
                cmd: _cmd,
                onbuild: _onbuild,
                workdir: _workdir,
                user: _user,
                entrypoint: _entrypoint
              }
            end

            def clone_to_artifact
              Artifact.new(dapp: dapp).tap do |docker|
                docker.instance_variable_set('@_from', @_from)
              end
            end
          end
        end
      end
    end
  end
end
