#!/usr/bin/env zsh

source "../../lib/init.zsh"
source "../../lib/base.zsh"

set -x

# 2. Binary
# 3. File or Directory
function test::base::variable_exists() {
  declare __TEST_FOO__
  base::exists __TEST_FOO__
}
test::base::variable_exists
