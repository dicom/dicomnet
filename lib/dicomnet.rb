#    Copyright 2008-2014 Christoffer Lervag
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# External dependencies:
require 'dicom'
require 'bindata'

# General module features/settings:
require_relative 'dicomnet/general/constants'
require_relative 'dicomnet/general/logging'
require_relative 'dicomnet/general/methods'
require_relative 'dicomnet/general/variables'
require_relative 'dicomnet/general/version'

# Core library files:
require_relative 'dicomnet/association_abort'

require_relative 'dicomnet/d_client'
require_relative 'dicomnet/d_server'
require_relative 'dicomnet/file_handler'
require_relative 'dicomnet/link'