# Nushell Environment Config File
#
# version = "0.92.1"

def create_left_prompt [] {
  if IN_NIX_SHELL in $env {
    $"(ansi blue_bold)# nix shell\n(ansi reset)"
  } else {
    ""
  }
}

# def create_left_prompt [] {
#     let dir = match (do --ignore-shell-errors { $env.PWD | path relative-to $nu.home-path }) {
#         null => $env.PWD
#         '' => '~'
#         $relative_pwd => ([~ $relative_pwd] | path join)
#     }
# 
#     let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
#     let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold }) 
#     let path_segment = $"($path_color)($dir)"
# 
#     $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
# }
# 
# def create_right_prompt [] {
#     # create a right prompt in magenta with green separators and am/pm underlined
#     let time_segment = ([
#         (ansi reset)
#         (ansi magenta)
#         (date now | format date '%x %X') # try to respect user's locale
#     ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
#         str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")
# 
#     let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
#         (ansi rb)
#         ($env.LAST_EXIT_CODE)
#     ] | str join)
#     } else { "" }
# 
#     ([$last_exit_code, (char space), $time_segment] | str join)
# }

$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| }

$env.PROMPT_INDICATOR = {|| "; " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| "; " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "; " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts')
]

$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins')
]

$env.MANPAGER = "nvim +Man!"
$env.MANWIDTH = "80"
$env.NIX_BUILD_SHELL = "bash"

# This is a hack
$env.NIX_LD = "/run/current-system/sw/share/nix-ld/lib/ld.so"
$env.NIX_LD_LIBRARY_PATH = "/run/current-system/sw/share/nix-ld/lib"

$env.PASSWORD_STORE_DIR =  "/home/alex/dropbox-maestral/Alex_home/passwords/"

alias cdc = cd ~/babelfish-files/
alias cdu = cd ~/dropbox-maestral/Alex_University/
alias cdh = cd ~/dropbox-maestral/Alex_home/

$env.TERM = xterm-256color


$env._JAVA_AWT_WM_NONREPARENTING = "1"
$env.AWT_TOOLKIT = "MToolkit"
