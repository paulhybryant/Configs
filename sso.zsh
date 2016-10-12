__zplug::sources::sso::check()
{
  __zplug::io::log::error \
      "not implemented"
  return 1
}

__zplug::sources::sso::load_plugin()
{
  __zplug::io::log::error \
      "not implemented"
  return 1
}

__zplug::sources::sso::load_command()
{
  __zplug::io::log::error \
      "not implemented"
  return 1
}

__zplug::sources::sso::install()
{
  __parser__ "$1"
  zspec=( "${reply[@]}" )


  echo $zspec
  echo "git clone --quiet --recursive $tags[from] $ZPLUG_REPOS/$tags[dir]"
  return 0

  # GIT_TERMINAL_PROMPT=0 \
    # git clone \
    # --quiet \
    # --recursive \
    # "$tags[from]" "$ZPLUG_REPOS/$tags[dir]" \
    # 2> >(__zplug::io::log::capture) >/dev/null
  # return $status
}

__zplug::sources::git::update()
{
  __zplug::io::log::error \
      "not implemented"
  return 1
}
