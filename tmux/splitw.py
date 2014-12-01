#!/usr/bin/python

"""
Restore tmux session layout.
"""

import collections
import fileinput
from enum import Enum

class Split(Enum):
  vertical = 1
  horizontal = 2

class Pane(object):  # This specifies 'object' as the superclass
  """A pane in tmux."""

  def __init__(self, index, left, top, right, bottom, width, height):
    self.parent = None
    self.child1 = None
    self.child2 = None
    self.split =  None
    self.selector = None
    self.index = index
    self.left = left
    self.top = top
    self.right = right
    self.bottom = bottom
    self.width = width
    self.height = height
    self.pane_count = 1


def try_merge_pane(pane1, pane2):
  merged = False
  newpane = None
  # print_pane(pane1)
  # print_pane(pane2)
  if (pane1.left == pane2.left):
    if (pane1.width == pane2.width and abs(pane1.height - pane2.height) <= 1):
      merged = True
      newpane = Pane(next_index(), pane1.left, pane1.top, pane2.right, pane2.bottom, max(pane1.width, pane2.width), pane1.height + pane2.height + 1)
      newpane.child1 = pane1
      newpane.child2 = pane2
      newpane.split = Split.vertical
      newpane.pane_count = pane1.pane_count + pane2.pane_count
      pane1.parent = newpane
      pane2.parent = newpane
  elif (pane1.top == pane2.top):
    if (pane1.height == pane2.height and abs(pane1.width - pane2.width) <= 1):
      merged = True
      newpane = Pane(next_index(), pane1.left, pane1.top, pane2.right, pane2.bottom, pane1.width + pane2.width + 1, max(pane1.height, pane2.height))
      newpane.child1 = pane1
      newpane.child2 = pane2
      newpane.split = Split.horizontal
      newpane.pane_count = pane1.pane_count + pane2.pane_count
      pane1.parent = newpane
      pane2.parent = newpane

  # if merged:
    # print_pane(newpane)
  # else:
    # print "Not merged"

  return merged, newpane


def print_pane(pane, recursive=False):
  if not recursive:
    print '%d: %d %d %d %d %d %d %d' % (pane.index, pane.left, pane.top, pane.right, pane.bottom, pane.width, pane.height, pane.pane_count)
    return

  print "tmux select-pane -t test:1.%d" % pane.selector
  if pane.split == None:
    return
  elif pane.split == Split.horizontal:
    print "tmux split-window -h -p 50"
  else:
    print "tmux split-window -v -p 50"

  if pane.child1 == None and pane.child2 == None:
    return

  pane.child1.selector = pane.selector
  print_pane(pane.child1, True)
  pane.child2.selector = pane.child1.pane_count + pane.selector
  print_pane(pane.child2, True)


def next_index():
  next_index.index += 1
  return next_index.index

def main():
  dq = collections.deque()
  for line in fileinput.input():
    coords = line.rstrip().split(" ")
    assert len(coords) == 7
    dq.append(Pane(int(coords[0]), int(coords[1]), int(coords[2]), int(coords[3]), int(coords[4]), int(coords[5]), int(coords[6])))

  next_index.index = len(dq)
  s = list()
  while (len(dq) > 1):
    # print "======"
    pane1 = dq[0]
    pane2 = dq[1]
    merged, newpane = try_merge_pane(pane1, pane2)
    if merged:
      dq.popleft()
      dq.popleft()
      dq.appendleft(newpane)
      if (len(s) > 0):
        dq.appendleft(s[-1])
        s.pop()
    else:
      s.append(pane1)
      dq.popleft()
    # print ""

  print "tmux new-session -s 'test' -d"
  dq[0].selector = 1
  print_pane(dq[0], True)


if __name__ == "__main__":
  main()
