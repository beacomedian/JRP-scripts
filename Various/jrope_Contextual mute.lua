--[[
 * Name: Contextual Mute
 * Author: Jesse Rope
 * Repository: github.com/beacomedian/JRope-Scripts
 * Licence: GPL v3
 * REAPER: 7.0
 * Version: 1.0
 * Provides:
 * Link: https://www.jesserope.com
 * About:
    Replaces: "Item properties: Toggle items/tracks mute (depending on focus)" to add item and tracks under mouse contexts
    Priority order: Item under mouse -> Selected Items -> Multiple Selected Tracks -> Track under mouse (arrange, TCP, MCP)

 

 * Changelog:
    # Initial Release

]]



---------------------------------
----------- FUNCTIONS -----------
---------------------------------

-- Get the item under the mouse cursor
function get_item_under_mouse()
    local window, segment, details = reaper.BR_GetMouseCursorContext()
    if details == "item" then
        return reaper.BR_GetMouseCursorContext_Item()
    end
    return nil
end

-- Get the track under the mouse cursor
function get_track_under_mouse()
    local window, segment, details = reaper.BR_GetMouseCursorContext()
    if segment == "track" then --and (window == "tcp" or window == "mcp") then
        return reaper.BR_GetMouseCursorContext_Track()
    end
    return nil
end

-- Toggle mute for a given item
function toggle_item_mute(item)
    if item then
        local mute_state = reaper.GetMediaItemInfo_Value(item, "B_MUTE")
        reaper.SetMediaItemInfo_Value(item, "B_MUTE", mute_state == 0 and 1 or 0)
        reaper.UpdateItemInProject(item)
    end
end

-- Toggle mute for a given track
function toggle_track_mute(track)
    if track then
        local mute_state = reaper.GetMediaTrackInfo_Value(track, "B_MUTE")
        reaper.SetMediaTrackInfo_Value(track, "B_MUTE", mute_state == 0 and 1 or 0)
    end
end

-- Toggle mute for all selected items
function toggle_selected_items_mute()
    local item_count = reaper.CountSelectedMediaItems(0)
    for i = 0, item_count - 1 do
        local item = reaper.GetSelectedMediaItem(0, i)
        toggle_item_mute(item)
    end
end

-- Toggle mute for all selected tracks
function toggle_selected_tracks_mute()
    local track_count = reaper.CountSelectedTracks(0)
    for i = 0, track_count - 1 do
        local track = reaper.GetSelectedTrack(0, i)
        toggle_track_mute(track)
    end
end

-- Main function
function main()
    -- Try to get the item under the mouse cursor
    local item_under_mouse = get_item_under_mouse()
    -- Try to get the track under the mouse cursor
    local track_under_mouse = get_track_under_mouse()

    if item_under_mouse then
        -- If there is an item under the mouse, toggle its mute state
        toggle_item_mute(item_under_mouse)
    elseif reaper.CountSelectedMediaItems(0) > 0 then
        -- If there are selected items, toggle their mute state
        toggle_selected_items_mute()
    elseif reaper.CountSelectedTracks(0) > 1 then
        -- If there are selected tracks, toggle their mute state
        toggle_selected_tracks_mute()
    elseif track_under_mouse then
        -- If there is a track under the mouse, toggle its mute state
        toggle_track_mute(track_under_mouse)
    end
end



---------------------------------
-------------- MAIN -------------
---------------------------------

reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock("jrope_Contextual Mute Toggle", -1)