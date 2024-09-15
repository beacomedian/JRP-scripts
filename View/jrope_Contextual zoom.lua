--[[
 * Name: Contextual Zoom
 * Author: Jesse Rope
 * Repository: github.com/beacomedian/JRope-Scripts
 * Licence: GPL v3
 * REAPER: 7.0
 * Version: 1.0
 * Provides:
 * Link: https://www.jesserope.com
 * noindex
 * About:
    Zoom-to depending on selection 
    Items -> Time Selection -> Project

 

 * Changelog:
    # Initial Release

]]


---------------------------------
----------- CONSTANTS -----------
---------------------------------

local SCRIPT_NAME = ({reaper.get_action_context()})[2]:match("([^/\\_]+)%.lua$")
local SCRIPT_DIR = ({reaper.get_action_context()})[2]:sub(1,({reaper.get_action_context()})[2]:find("\\[^\\]*$"))
time_init = reaper.time_precise()
r = reaper
proj = 0

---------------------------------
----------- FUNCTIONS -----------
---------------------------------


function Main( ... )
    -- Check if there are selected media items
    local selected_items_count = reaper.CountSelectedMediaItems(0)

    if selected_items_count > 0 then
        -- If there are selected items, zoom to those items
        reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_HZOOMITEMS"), 0) -- View: Zoom to selected items
        reaper.Main_OnCommand(1011, 0)
        reaper.Main_OnCommand(1011, 0) -- zoom out a bit
        -- reaper.Main_OnCommand(1011, 0)

    else
        -- Check if there is a time selection
        local start_time, end_time = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)

        if start_time ~= end_time then
            -- If there is a time selection, zoom to the time selection
            reaper.Main_OnCommand(40031, 0) -- View: Zoom to time selection
            reaper.Main_OnCommand(1011, 0)
            reaper.Main_OnCommand(1011, 0) -- zoom out a bit
            -- reaper.Main_OnCommand(1011, 0)
        else
            -- If there is nothing selected, zoom out to the project
            reaper.Main_OnCommand(40295, 0) -- View: Zoom to project
            reaper.Main_OnCommand(1012, 0)
            reaper.Main_OnCommand(1012, 0) -- zoom in a bit
            -- reaper.Main_OnCommand(1012, 0)
        end
    end
end



---------------------------------
-------------- MAIN -------------
---------------------------------

-- reaper.APITest()
-- reaper.ShowConsoleMsg("-- Script started\n")

-- Begin the undo block
reaper.PreventUIRefresh(1)
-- reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.


Main()


-- Update the arrangement to reflect the new selection
-- reaper.Undo_EndBlock("jrope_"..SCRIPT_NAME, -1)
reaper.PreventUIRefresh(-1)
-- reaper.UpdateTimeline()
-- reaper.UpdateArrange()

-- End the undo block with a description
-- reaper.ShowConsoleMsg("-- Script finished\n\n")

-- reaper.ShowMessageBox("Script executed in (s): "..tostring(reaper.time_precise() - time_init), "", 0)