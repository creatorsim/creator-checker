#!/bin/bash
#set -x

#  Copyright 2018-2026 CREATOR Team.
#
#  This file is part of CREATOR.
#
#  CREATOR is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  CREATOR is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public License
#  along with CREATOR.  If not, see <http://www.gnu.org/licenses/>.



# Mount the creator folder to /workspace/creator
ln -s /creator /workspace/creator

# Start SSHD
/usr/sbin/sshd -D
status=$?
if [ $status -ne 0 ]; then
     echo "Failed to start sshd: $status"
     exit $status
fi