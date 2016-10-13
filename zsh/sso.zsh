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
  local    repo="$1"
  local -A tags
  local -a unclassified_plugins
  local -a load_fpaths
  local    expanded_path
  local -a expanded_paths
  local    lazy_pattern

  if (( $# < 1 )); then
      __zplug::io::log::error \
          "too few arguments"
      return 1
  fi

  __zplug::core::tags::parse "$repo"
  tags=( "${reply[@]}" )

  expanded_paths=( $(
  zsh -c "$_ZPLUG_CONFIG_SUBSHELL; echo ${tags[dir]}${lazy_pattern:+/$lazy_pattern}" \
      2> >(__zplug::io::log::capture)
  ) )

  for expanded_path in "${expanded_paths[@]}"
  do
      if [[ -f $expanded_path ]]; then
          unclassified_plugins+=( "$expanded_path" )

          # Add parent directory to fpath
          if (( $_zplug_boolean_true[(I)$tags[lazy]] )); then
              load_fpaths+=( $expanded_path(N-.:h) )
          fi
      elif [[ -d $expanded_path ]]; then
          if (( $_zplug_boolean_true[(I)$tags[lazy]] )); then
              load_fpaths+=( $expanded_path(N-/) )
          else
              # Note: $tags[use] defaults to '*.zsh'
              unclassified_plugins+=( $(
              zsh -c "$_ZPLUG_CONFIG_SUBSHELL; echo $expanded_path/$tags[use]" \
                  2> >(__zplug::io::log::capture)
              ) )

              load_fpaths+=(
                  "$expanded_path"/{_*,**/_*}(N-.:h)
              )
          fi
      fi
  done

  if (( $#unclassified_plugins == 0 )) && (( $#load_fpaths == 0 )); then
      __zplug::io::log::warn \
          "no matching file or directory in $tags[dir]"
      return 1
  fi

  reply=()
  [[ -n $load_fpaths ]] && reply+=( load_fpaths "${(F)load_fpaths}" )
  [[ -n $unclassified_plugins ]] && reply+=( unclassified_plugins "${(F)unclassified_plugins}" )

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
  GIT_TERMINAL_PROMPT=0 \
    git clone \
    --quiet \
    --recursive \
    "$repo" "$ZPLUG_REPOS/$tags[dir]" \
    2> >(__zplug::io::log::capture) >/dev/null
  return $status
}

__zplug::sources::git::update()
{
  local    repo="$1"
  local    rev_local rev_remote rev_base
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
