# vim: set sw=2 ts=2 sts=2 et tw=78 foldmethod=indent foldnestmax=1 nospell:
"""Utility module.

Defines utility classes and functions.
"""

from optparse import OptionParser


class Singleton(type):
  """Singleton class."""

  _instances = {}

  def __call__(cls, *args, **kwargs):
    if cls not in cls._instances:
      cls._instances[cls] = super(Singleton, cls).__call__(*args, **kwargs)
    return cls._instances[cls]


class FlagValues(object):
  """Flag values registry."""

  __metaclass__ = Singleton

  def __init__(self):
    parser = OptionParser()
    parser.add_option("", "--dryrun", action="store_true", default=False,
                      dest="dryrun", help="Print only the commands")
    parser.add_option("", "--reinstall", action="store_true", default=False,
                      dest="reinstall", help="Force reinstall the package")
    parser.add_option("-v", "--verbose", action="store_true", default=False,
                      dest="verbose", help="Verbose mode")
    (options, args) = parser.parse_args()

    self.dryrun = options.dryrun
    self.reinstall = options.reinstall
    self.verbose = options.verbose
    self.args = args

FLAGS = FlagValues()
