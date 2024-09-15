--[[
 * Name: Add items after selected items on the same track to the selection
 * Author: Jesse Rope
 * Repository: github.com/beacomedian/JRope-Scripts
 * Licence: GPL v3
 * REAPER: 7.0
 * Version: 1.0
 * Provides:
 * Link: https://www.jesserope.com
 * noindex
 * About:
    # Add items after selected items on the same track to the selection

 

 * Changelog:
    # Initial Release

]]



---------------------------------
---------- USER CONFIG ----------
---------------------------------


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

function main()
    -- Get the number of selected items
    local num_sel_items = reaper.CountSelectedMediaItems(0)
    if num_sel_items == 0 then
        reaper.Undo_EndBlock("No items to add", -1)
        return
    end

    -- Table to store tracks with selected items
    local tracks = {}

    -- Get the positions of all selected items and the tracks they are on
    for i = 0, num_sel_items - 1 do
        local item = reaper.GetSelectedMediaItem(0, i)
        local track = reaper.GetMediaItem_Track(item)
        local pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
        
        -- Store the earliest position for each track
        if not tracks[track] or pos < tracks[track] then
            tracks[track] = pos
        end
    end

    -- Loop through all items in the project
    local num_items = reaper.CountMediaItems(0)
    for i = 0, num_items - 1 do
        local item = reaper.GetMediaItem(0, i)
        local track = reaper.GetMediaItem_Track(item)
        
        -- Check if the item is on a track with selected items
        if tracks[track] then
            local pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
            
            -- Check if the item is after the earliest selected item on the same track
            if pos > tracks[track] then
                -- Select the item
                reaper.SetMediaItemSelected(item, true)
            end
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
reaper.Undo_BeginBlock() -- Begining of the undo block. Leave it at the top of your main function.

--SaveView()
--SaveCursorPos()
--SaveLoopTimesel()
-- SaveSelectedItems(init_sel_items)
--SaveSelectedTracks(init_sel_tracks)

main()

--RestoreCursorPos()
--RestoreLoopTimesel()
-- RestoreSelectedItems(init_sel_items)
--RestoreSelectedTracks(init_sel_tracks)
--RestoreView()

-- Update the arrangement to reflect the new selection
reaper.Undo_EndBlock("jrope_"..SCRIPT_NAME, -1)
reaper.PreventUIRefresh(-1)
reaper.UpdateTimeline()
reaper.UpdateArrange()

-- End the undo block with a description
-- reaper.ShowConsoleMsg("-- Script finished\n\n")

-- reaper.ShowMessageBox("Script executed in (s): "..tostring(reaper.time_precise() - time_init), "", 0)