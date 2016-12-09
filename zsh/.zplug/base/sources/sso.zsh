__zplug::sources::sso::check()
{
  local    repo="$1"
  local -A tags

  if (( $# < 1 )); then
      __zplug::io::log::error \
          "too few arguments"
      return 1
  fi

  tags[dir]="$(
  __zplug::core::core::run_interfaces \
      'dir' \
      "$repo"
  )"

  [[ -d $tags[dir] ]]
  return $status
}

__zplug::sources::sso::load_plugin()
{
    local    repo="${1:?}"
    local -A tags default_tags
    local -a \
        unclassified_plugins \
        load_fpaths \
        defer_1_plugins \
        defer_2_plugins \
        defer_3_plugins \
        load_plugins \
        lazy_plugins

    __zplug::core::tags::parse "$repo"
    tags=( "${reply[@]}" )
    default_tags[use]="$(__zplug::core::core::run_interfaces 'use')"
    load_fpaths=()

    if [[ $tags[use] == $default_tags[use] ]]; then
        unclassified_plugins+=( "$tags[dir]"/*.plugin.zsh(N-.) )
    fi
    if (( $#unclassified_plugins == 0 )); then
        unclassified_plugins+=( ${(@f)"$( \
            __zplug::utils::shell::expand_glob "$tags[dir]/$tags[use]" "(N-.)"
        )"} )
        # If $tags[use] is a directory,
        # expect to expand to $tags[dir]/*.zsh
        if (( $#unclassified_plugins == 0 )); then
            unclassified_plugins+=( ${(@f)"$( \
                __zplug::utils::shell::expand_glob "$tags[dir]/$tags[use]/$default_tags[use]" "(N-.)"
            )"} )
            # Add the parent directory to fpath
            load_fpaths+=( "$tags[dir]/$tags[use]"/_*(N.:h) )
        fi
    fi
    load_fpaths+=( "$tags[dir]"/_*(N.:h) )

    # unclassified_plugins -> {defer_N_plugins,lazy_plugins,load_plugins}
    # the order of loading of plugin files
    case "$tags[defer]" in
        0)
            if (( $_zplug_boolean_true[(I)$tags[lazy]] )); then
                lazy_plugins+=( "${unclassified_plugins[@]}" )
            else
                load_plugins+=( "${unclassified_plugins[@]}" )
            fi
            ;;
        1)
            defer_1_plugins+=( "${unclassified_plugins[@]}" )
            ;;
        2)
            defer_2_plugins+=( "${unclassified_plugins[@]}" )
            ;;
        3)
            defer_3_plugins+=( "${unclassified_plugins[@]}" )
            ;;
        *)
            : # Error
            ;;
    esac
    unclassified_plugins=()

    reply=()
    [[ -n $load_plugins ]] && reply+=( "load_plugins" "${(F)load_plugins}" )
    [[ -n $defer_1_plugins ]] && reply+=( "defer_1_plugins" "${(F)defer_1_plugins}" )
    [[ -n $defer_2_plugins ]] && reply+=( "defer_2_plugins" "${(F)defer_2_plugins}" )
    [[ -n $defer_3_plugins ]] && reply+=( "defer_3_plugins" "${(F)defer_3_plugins}" )
    [[ -n $lazy_plugins ]] && reply+=( "lazy_plugins" "${(F)lazy_plugins}" )
    [[ -n $load_fpaths ]] && reply+=( "load_fpaths" "${(F)load_fpaths}" )
    [[ -n $tags[hook-load] ]] && reply+=( "hook_load" "$tags[name]\0$tags[hook-load]")

    return 0
}

__zplug::sources::sso::load_command()
{
  __zplug::io::log::error \
      "not implemented"
  return 1
}

__zplug::sources::sso::install()
{
  local repo="$1"
  tags[dir]="$(__zplug::core::core::run_interfaces 'dir' "$repo")"

  GIT_TERMINAL_PROMPT=0 \
    git clone \
    --quiet \
    --recursive \
    "$repo" "$tags[dir]" \
    2> >(__zplug::io::log::capture) >/dev/null
  return $status
}

__zplug::sources::sso::update()
{
  local    repo="$1"
  local -A tags

  if (( $# < 1 )); then
      __zplug::io::log::error \
          "too few arguments"
      return 1
  fi

  tags[dir]="$(__zplug::core::core::run_interfaces 'dir' "$repo")"
  tags[at]="$(__zplug::core::core::run_interfaces 'at' "$repo")"

  __zplug::utils::git::merge \
      --dir    "$tags[dir]" \
      --branch "$tags[at]"
  return $status
}
