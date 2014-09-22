# Copyright (c) 2014 SUSE LLC.
#  All Rights Reserved.

#  This program is free software; you can redistribute it and/or
#  modify it under the terms of version 2 or 3 of the GNU General
# Public License as published by the Free Software Foundation.

#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.   See the
#  GNU General Public License for more details.

#  You should have received a copy of the GNU General Public License
#  along with this program; if not, contact SUSE LLC.

#  To contact Novell about this file by physical or electronic mail,
#  you may find current contact information at www.suse.com

require "yast"

module YDocker
  class ChangesDialog
    def initialize(container)
      @container = container
    end

    def run
      return unless create_dialog

      begin
        return controller_loop
      ensure
        close_dialog
      end
    end

    def create_dialog
      Yast::UI.OpenDialog dialog_content
    end

    def close_dialog
      Yast::UI.CloseDialog
    end

    def controller_loop
      while true do
        input = Yast::UI.UserInput
        case input
        when :ok, :cancel
          return :ok
        else
          raise "Unknown action #{input}"
        end
      end
    end

    def dialog_content
      VBox(
        headings,
        changes_table,
        ending_buttons
      )
    end

    def headings
      Heading(_("Changes in Container"))
    end


    def changes_table
      Table(
        Id(:changes_table),
        Header(
          _("Status"),
          _("Path")
        ),
        changes_items
      )
    end

    STATUS_MAPPING = {
      0 => _("Modified"),
      1 => _("Created"),
      2 => _("Deleted")
    }

    def changes_items
      changes = @container.changes
      changes.map do |change|
        Item(
          STATUS_MAPPING[change["Kind"]] || change["Kind"],
          change["Path"]
        )
      end
    end

    def ending_buttons
      PushButton(Id(:ok), _("&Exit"))
    end

  end
end
