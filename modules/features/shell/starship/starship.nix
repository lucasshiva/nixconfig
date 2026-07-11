{ lib, ... }:
{
  shiv.shell.prompts.starship = {
    homeManager =
      { config, ... }:
      {

        config = {
          programs.starship = {
            enable = true;
            enableBashIntegration = lib.mkDefault true;
            enableZshIntegration = lib.mkDefault true;
            enableFishIntegration = lib.mkDefault true;
            enableNushellIntegration = lib.mkDefault true;
            presets = [ "plain-text-symbols" ];
            settings = {
              add_newline = true;
              shell = {
                bash_indicator = "bash";
                fish_indicator = "fish";
                disabled = false;
              };
              directory = {
                truncation_length = 0;
                truncate_to_repo = false;
                disabled = false;
              };
              direnv = {
                disabled = false;
              };
              username = {
                show_always = true;
                format = "[$user]($style)";
              };
              hostname = {
                ssh_only = false;
                format = "@[$hostname ]($style)";
              };
              os.disabled = true;
              buf.disabled = true;
              bun.disabled = true;
              c.disabled = true;
              cpp.disabled = true;
              cobol.disabled = true;
              conda.disabled = true;
              container.disabled = true;
              crystal.disabled = true;
              cmake.disabled = true;
              daml.disabled = true;
              dart.disabled = true;
              deno.disabled = true;
              elixir.disabled = true;
              elm.disabled = true;
              erlang.disabled = true;
              fennel.disabled = true;
              fortran.disabled = true;
              fossil_branch.disabled = true;
              gleam.disabled = true;
              haskell.disabled = true;
              haxe.disabled = true;
              helm.disabled = true;
              hg_branch.disabled = true;
              kubernetes.disabled = true;
              lua.disabled = true;
              maven.disabled = true;
              meson.disabled = true;
              mojo.disabled = true;
              nats.disabled = true;
              netns.disabled = true;
              nim.disabled = true;
              ocaml.disabled = true;
              odin.disabled = true;
              opa.disabled = true;
              openstack.disabled = true;
              package.disabled = true;
              perl.disabled = true;
              php.disabled = true;
              pijul_channel.disabled = true;
              pixi.disabled = true;
              pulumi.disabled = true;
              purescript.disabled = true;
              quarto.disabled = true;
              raku.disabled = true;
              red.disabled = true;
              rlang.disabled = true;
              ruby.disabled = true;
              scala.disabled = true;
              shlvl.disabled = true;
              spack.disabled = true;
              solidity.disabled = true;
              swift.disabled = true;
              vagrant.disabled = true;
              terraform.disabled = true;
              xmake.disabled = true;
              zig.disabled = true;
            };
          };
        };
      };
  };
}
