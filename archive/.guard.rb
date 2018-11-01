# interactor :off
# logger device: '/Users/yuhuang/.local/var/log/guard.log'
directories %w(/Users/yuhuang/.local/var/log)
guard :shell do
  watch(/synergy.log/) {|m| `/Users/yuhuang/.local/bin/karabiner-switch.zsh` }
end
