# Copyright (C) 2010-2012, InSTEDD
#
# This file is part of Verboice.
#
# Verboice is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Verboice is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Verboice.  If not, see <http://www.gnu.org/licenses/>.

class RecordLocalizedResource < LocalizedResource

  attr_accessible :encoded_audio

  def audio
    self.recorded_audio
  end

  def audio= an_audio_stream
    self.recorded_audio= an_audio_stream
  end

  def play_command_for play_resource_command
    play_resource_command.play_record_command_for self
  end

  def capture_resource_for play_resource_command, session
    play_resource_command.record_capture_resource_for self, session
  end

  def encoded_audio= encoded_audio
    self.recorded_audio = Base64.decode64 encoded_audio
  end
end
