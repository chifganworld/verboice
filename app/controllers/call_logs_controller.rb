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

class CallLogsController < ApplicationController
  before_filter :authenticate_account!
  before_filter :prepare_log_detail, only: [:show, :progress, :play_result, :download_details]

  def index
  end

  def show
    set_fixed_width_content
  end

  def progress
    @log.entries.each do |entry|
      if entry.details.has_key?(:activity)
        activity = JSON.load(entry.details[:activity]) rescue {}
        entry.details[:description] = activity["body"]["@description"] rescue nil
      end
    end
    render :layout => false
  end

  def play_result
    if current_account.projects.find_by_id(@log.project_id) || !current_account.shared_projects.where(:model_id => @log.project_id, :role => 'admin').empty?
      # Checks if the current_user is the owner of @log.project
      # ideally it should use ApplicationController#check_project_admin
      # but it can be done without some further refactors
      send_file RecordingManager.for(@log).result_path_for(params[:key]), :x_sendfile => true
    else
      head :unauthorized
    end
  end

  def download_details
    @filename = "Call details #{@log.id} (#{Time.now}).csv"
    @streaming = true
    @csv_options = { :col_sep => ',' }
  end

private

  def prepare_log_detail
    @log = CallLog.for_account(current_account).find params[:id]
    @activities = CallLog.poirot_activities(@log.id).sort_by(&:start)
  end

end
