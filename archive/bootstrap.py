#!/usr/bin/env python
# vim: set sw=2 ts=2 sts=2 et tw=78 foldmethod=indent foldnestmax=1 nospell:

"""Entry point of the bootstrap script.

Main function definition.
"""

from abc import ABCMeta
from abc import abstractmethod
import os
import platform
import re
import subprocess
from toposort import toposort_flatten
from util import FLAGS


class ExecutionError(Exception):
  """Defines execution error.

  Allow returning error messages.
  """

  def __init__(self, value):
    super(ExecutionError, self).__init__()
    self.value = value


class Bundle(object):
  """Describes how a program / package should be installed."""
  __metaclass__ = ABCMeta

  def __init__(self, name, installer, src="", cmds=None,
               installer_args=None, deps=None):
    self._name = name
    self._installer = installer
    if installer_args is None:
      self._installer_args = []
    else:
      self._installer_args = installer_args
    self._src = src
    if cmds is None:
      self._cmds = []
    else:
      self._cmds = cmds
    self._git_dir = os.path.expandvars("$HOME/.gitrepo")
    self._fnull = open(os.devnull, "w")
    self._deps = deps

  # @staticmethod
  # def InstallPrerequisites():
    # """Install the prerequisites are installed."""

  @staticmethod
  def ExecuteSystemCmd(cmd):
    if FLAGS.dryrun:
      print os.path.expandvars(cmd)
    else:
      try:
        subprocess.check_output(os.path.expandvars(cmd), shell=True)
      except subprocess.CalledProcessError as e:
        print "Error executing %s" % cmd
        raise ExecutionError(e.output)

  @abstractmethod
  def IsInstalled(self):
    return

  def Deps(self):
    return self._deps

  def Install(self, target):
    """Install the binary."""

    if self.IsInstalled():
      print "%s is already installed." % target
      if not FLAGS.reinstall:
        print
        return

    installations = {
        "apt": Bundle.InstallWithApt,
        "git": Bundle.InstallWithGit,
        "pip": Bundle.InstallWithPip,
        "pip-user": Bundle.InstallWithPipUser,
        "brew": Bundle.InstallWithBrew,
        "curl": Bundle.InstallWithCurl,
        "gem": Bundle.InstallWithGem,
    }
    print "Installing %s..." % target
    installations[self._installer](self, target)
    print "Done installing %s" % target
    print

  def InstallWithApt(self, target):
    """Install the bundle with apt."""

    cmdlist = ["sudo", "apt-get", "install"]
    if FLAGS.reinstall:
      cmdlist.append("--reinstall")
    cmdlist.extend(["-y", target])
    cmd = " ".join(cmdlist)
    self.ExecuteSystemCmd(cmd)

  def InstallWithBrew(self, target):
    """Install the bundle with homebrew."""

    cmdlist = ["brew"]
    if FLAGS.reinstall:
      cmdlist.append("reinstall")
    else:
      cmdlist.append("install")
    cmdlist.extend(self._installer_args)
    cmdlist.append(target)
    cmd = " ".join(cmdlist)
    self.ExecuteSystemCmd(cmd)

  def InstallWithCurl(self, target):
    """Install the bundle with curl."""

    cmdlist = ["curl", "-fSsL", self._src, "-o", "/tmp/%s" % target]
    cmd = " ".join(cmdlist)
    self.ExecuteSystemCmd(cmd)

    for cmd in self._cmds:
      self.ExecuteSystemCmd(cmd)

  def InstallWithGem(self, target):
    """Install the bundle with gem"""

    cmdlist = ["sudo", "gem", "install", target]
    cmd = " ".join(cmdlist)
    self.ExecuteSystemCmd(cmd)

    for cmd in self._cmds:
      self.ExecuteSystemCmd(cmd)

  def InstallWithPip(self, target):
    """Install the bundle with pip."""

    cmdlist = ["sudo", "pip", "install"]
    if FLAGS.reinstall:
      cmdlist.extend(["--reinstall", "--ignore-installed"])
    cmdlist.append(self._name)
    cmd = " ".join(cmdlist)
    self.ExecuteSystemCmd(cmd)

  def InstallWithPipUser(self, target):
    """Install the bundle with pip2 --user."""

    cmdlist = ["pip", "install", "--user"]
    if FLAGS.reinstall:
      cmdlist.extend(["--reinstall", "--ignore-installed"])
    cmdlist.append(self._src)
    cmd = " ".join(cmdlist)
    self.ExecuteSystemCmd(cmd)

  def InstallWithGit(self, target):
    """Install the bundle by clone the repository and compile."""

    if not os.path.exists(self._git_dir):
      if FLAGS.dryrun:
        print "mkdir -p %s" % self._git_dir
      else:
        os.makedirs(self._git_dir)

    target_dir = os.path.join(self._git_dir, target)
    if os.path.isdir(target_dir):
      cmd = "cd %s; git pull" % target_dir
      self.ExecuteSystemCmd(cmd)
    else:
      cmd = "git clone %s %s; cd %s" % (self._src, target_dir, target_dir)
      self.ExecuteSystemCmd(cmd)

    for cmd in self._cmds:
      self.ExecuteSystemCmd("cd %s; %s" % (target_dir, cmd))


class Binary(Bundle):
  """Binary bundle."""

  def IsInstalled(self):
    """Check whether a specific binary is installed and available in $PATH.

    Returns:
      True or False
    """
    cmdlist = ["which", self._name]
    if FLAGS.verbose:
      print "Checking is %s installed..." % self._name
      print " ".join(cmdlist)
    status = subprocess.call(cmdlist,
                             stdout=self._fnull, stderr=subprocess.STDOUT)
    if status == 0:
      return True
    else:
      return False


class AptPackage(Bundle):
  """Package bundle."""

  def IsInstalled(self):
    """Check whether a specific package is installed.

    Returns:
      True or False
    """
    cmdlist = ["dpkg", "-s", self._name]
    if FLAGS.verbose:
      print "Checking is %s installed..." % self._name
      print " ".join(cmdlist)
    status = subprocess.call(cmdlist,
                             stdout=self._fnull, stderr=subprocess.STDOUT)
    if status == 0:
      return True
    else:
      return False


class BrewPackage(Bundle):
  """Package bundle."""

  def IsInstalled(self):
    """Check whether a specific brew package is installed.

    Returns:
      True or False
    """
    cmdlist = ["brew", "list", "-1", "|", "grep", "^%s" % self._name]
    if FLAGS.verbose:
      print "Checking is %s installed..." % self._name
      print " ".join(cmdlist)
    p1 = subprocess.Popen(["brew", "list", "-1"], stdout=subprocess.PIPE)
    p2 = subprocess.Popen(["grep", "^%s" % self._name], stdin=p1.stdout,
                          stdout=subprocess.PIPE)
    p1.stdout.close()
    output = p2.communicate()[0]
    if output.startswith(self._name):
      return True
    else:
      return False


class PipPackage(Bundle):
  """Package bundle."""

  def IsInstalled(self):
    """Check whether a specific pip package is installed.

    Returns:
      True or False
    """
    cmdlist = ["pip", "list", "|", "grep", "^%s" % self._name]
    if FLAGS.verbose:
      print "Checking is %s installed..." % self._name
      print " ".join(cmdlist)
    p1 = subprocess.Popen(["pip", "list"], stdout=subprocess.PIPE)
    p2 = subprocess.Popen(["grep", "^%s" % self._name], stdin=p1.stdout,
                          stdout=subprocess.PIPE)
    p1.stdout.close()
    output = p2.communicate()[0]
    if output.startswith(self._name):
      return True
    else:
      return False


def BootstrapDebian():
  """Bootstrap on debian based system."""

  print "Bootstraping debian based system..."
  try:
    bundles = {
        "automake": AptPackage("automake", "apt"),
        "checkinstall": AptPackage("checkinstall", "apt"),
        "git": AptPackage("git", "apt"),
        "wmctrl": AptPackage("wmctrl", "apt"),
        "pkg-config": AptPackage("pkg-config", "apt"),
        "sharutils": AptPackage("sharutils", "apt"),
        "libevent-dev": AptPackage("libevent-dev", "apt"),
        "liblzma-dev": AptPackage("liblzma-dev", "apt"),
        "libncurses5-dev": AptPackage("libncurses5-dev", "apt"),
        "libncursesw5-dev": AptPackage("libncursesw5-dev", "apt"),
        "libpcre3-dev": AptPackage("libpcre3-dev", "apt"),
        "libtool": AptPackage("libtool", "apt"),
        "python-pip": AptPackage("python-pip", "apt"),
        "terminator": AptPackage("terminator", "apt"),
        "pandoc": AptPackage("pandoc", "apt"),
        "dos2unix": AptPackage("dos2unix", "apt"),
        "vim-gtk": AptPackage(
            "vim-gtk", "apt",
            ["sudo update-alternatives --set vim /usr/bin/vim.gtk",
             "sudo update-alternatives --set gvim /usr/bin/vim.gtk",
             "sudo update-alternatives --set vimdiff /usr/bin/vim.gtk",
             "sudo update-alternatives --set gvimdiff /usr/bin/vim.gtk",
             "sudo update-alternatives --set view /usr/bin/vim.gtk",
             "sudo update-alternatives --set editor /usr/bin/vim.gtk",
             "sudo update-alternatives --set vi /usr/bin/vim.gtk"]),
        "ag": Binary("ag", "git",
                     "https://github.com/ggreer/the_silver_searcher.git",
                     ["./build.sh", "make", "sudo make install"],
                     deps=set(["libpcre3-dev", "liblzma-dev", "git"])),
        "vimpager": Binary("vimpager", "git",
                     "https://github.com/rkitover/vimpager.git",
                     ["make", "sudo make install"],
                     deps=set(["pandoc", "dos2unix", "git", "sharutils"])),
        "htop": Binary("htop", "git",
                       "https://github.com/hishamhm/htop.git",
                       ["./autogen.sh", "./configure", "make",
                        "sudo make install"],
                       deps=set(["git", "automake", "libncursesw5-dev",
                         "libtool"])),
        "powerline-shell": Binary(
            "powerline-shell.py", "git",
            "https://github.com/paulhybryant/powerline-shell.git",
            ["mkdir -p $HOME/.local/bin",
             "ln -s $HOME/.gitrepo/powerline-shell.py/powerline-shell.py"
             " $HOME/.local/bin/powerline-shell.py"], deps=set(["git"])),
        "powerline": PipPackage("powerline", "pip-user",
                                "git+git://github.com/Lokaltog/powerline",
                                deps=set(["python-pip"])),
        "python-dateutil": PipPackage("python-dateutil", "pip",
                                      deps=set(["python-pip"])),
        "tmux": Binary("tmux", "git",
                       "http://git.code.sf.net/p/tmux/tmux-code",
                       ["./autogen.sh", "./configure", "make",
                        "sudo make install"], deps=set(["git", "automake",
                          "libevent-dev", "libncurses5-dev"])),
        "tmuxinator": Binary("tmuxinator", "gem"),
        "linuxbrew": Binary("brew", "git", "https://github.com/Homebrew/linuxbrew.git",
                            ["ln -s $HOME/.gitrepo/linuxbrew $HOME/.linuxbrew"],
                            deps=set(["git"])),
    }
    dag = {}
    for name, bundle in bundles.items():
      if bundle.Deps() is not None:
        dag[name] = bundle.Deps()
    for name in toposort_flatten(dag):
      bundles[name].Install(name)
  except ExecutionError as e:
    print e.value


def BootstrapDebianWithLinuxbrew():
  """Bootstrap on debian based system with linuxbrew."""
  # ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"

  print "Bootstraping debian based system with linuxbrew..."
  try:
    bundles = {
        "git": BrewPackage("git", "brew",
                           cmds=["brew tap paulhybryant/myformulae"]),
        "powerline-shell": BrewPackage("powerline-shell", "brew"),
        "the_silver_searcher": BrewPackage("the_silver_searcher", "brew",
                                           installer_args=["--HEAD"],
                                           deps=set(["pcre"])),
        "automake": BrewPackage("automake", "brew"),
        "autoconf": BrewPackage("autoconf", "brew"),
        "pkg-config": BrewPackage("pkg-config", "brew"),
        "pcre": BrewPackage("pcre", "brew"),
        "libtool": BrewPackage("libtool", "brew"),
        "libevent": BrewPackage("libevent", "brew"),
        "vimpager": BrewPackage("vimpager", "brew"),
        "htop": BrewPackage("htop", "brew"),
        "tmux": BrewPackage("tmux", "brew"),
        "xz": BrewPackage("xz", "brew"),
        "pandoc": BrewPackage("pandoc", "brew"),
        "gettext": BrewPackage("gettext", "brew"),
        "vim": BrewPackage("vim", "brew",
                           installer_args=["--HEAD", "--without-python3",
                                           "--override-system-vi",
                                           "--with-client-server",
                                           "--with-lua", "--with-luajit",
                                           "--with-python","--disable-nls"],
                           deps=set(["python", "bison", "flex", "ncurses",
                                    "readline"])),
        "python": BrewPackage("python", "brew"),
        "bison": BrewPackage("bison", "brew"),
        "flex": BrewPackage("flex", "brew"),
        "ncurses": BrewPackage("ncurses", "brew"),
        "readline": BrewPackage("readline", "brew"),
        "dos2unix": BrewPackage("dos2unix", "brew",
                                deps=set(["gettext"])),
        "checkinstall": AptPackage("checkinstall", "apt"),
        "terminator": AptPackage("terminator", "apt"),
        "libxmu-dev": AptPackage("libxmu-dev", "apt"),
        "wmctrl": BrewPackage("wmctrl", "brew",
                              deps=set(["libxmu-dev"])),
        "powerline": PipPackage("powerline", "pip",
                                "git+git://github.com/Lokaltog/powerline",
                                deps=set(["python"])),
        "python-dateutil": PipPackage("python-dateutil", "pip",
                                      deps=set(["python"])),
        "tmuxinator": Binary("tmuxinator", "gem"),
    }
    dag = {}
    for name, bundle in bundles.items():
      if bundle.Deps() is not None:
        dag[name] = bundle.Deps()
    for name in toposort_flatten(dag):
      bundles[name].Install(name)
  except ExecutionError as e:
    print e.value


def BootstrapMac():
  """Bootstrap on mac osx family system."""

  print "Bootstraping mac system..."
  try:
    bundles = {
        "ag": BrewPackage("the_silver_searcher", "brew", deps=set(["brew"])),
        "brew": Binary(
            "brew", "curl",
            "https://raw.githubusercontent.com/Homebrew/install/master/install",
            ["ruby -e /tmp/homebrew.rb"]),
        "git": BrewPackage("git", "brew", deps=set(["brew"])),
        "macvim": BrewPackage("macvim", "brew",
                              installer_args=["--env-std",
                                              "--with-lua",
                                              "--override-system-vim",
                                              "--HEAD"],
                              deps=set(["brew"])),
        "python": BrewPackage("python", "brew", deps=set(["brew"])),
        "terminator": BrewPackage("terminator", "brew",
                                  installer_args=["--HEAD"],
                                  deps=set(["brew"])),
        "tmux": BrewPackage("tmux", "brew",
                            installer_args=["--HEAD"], deps=set(["brew"])),
        "vimpager": BrewPackage("vimpager", "brew", deps=set(["brew"])),
        "vim": BrewPackage("vim", "brew",
                           installer_args=["--with-lua",
                                           "--override-system-vi",
                                           "--HEAD"],
                           deps=set(["brew"])),
        "powerline-shell": Binary(
            "powerline-shell.py", "git",
            "https://github.com/paulhybryant/powerline-shell.git",
            ["ln -s $HOME/.gitrepo/powerline-shell/powerline-shell.py"
             " $HOME/.local/bin/powerline-shell.py"], deps=set(["git"])),
        "powerline": Binary("powerline", "pip-user",
                            "git+git://github.com/Lokaltog/powerline"),
        "htop-osx-patched": Binary(
            "htop", "git",
            "https://github.com/paulhybryant/htop-osx-patched.git",
            deps=set(["git"])),
        "tmuxinator": Binary("tmuxinator", "gem"),
    }
    dag = {}
    for name, bundle in bundles.items():
      if bundle.Deps() is not None:
        dag[name] = bundle.Deps()
    for name in toposort_flatten(dag):
      bundles[name].Install(name)
  except ExecutionError as e:
    print e.value


def main():
  # TODO(me): Use aspect python for logging
  if (bool(re.match("^linux", platform.platform(), re.IGNORECASE)) and
      bool(re.match("ubuntu|debian|deepin",
                    platform.linux_distribution()[0], re.IGNORECASE))):
    BootstrapDebianWithLinuxbrew()
  elif bool(re.match("^darwin", platform.platform(), re.IGNORECASE)):
    BootstrapMac()
  else:
    print "Unsupported platform %s." % platform.platform()


if __name__ == "__main__":
  main()
