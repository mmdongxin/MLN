---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by szt.
--- DateTime: 2020/12/29 下午3:53
--- @version 1.0

local class = {
    _watchIndex = 0,
    _watchs = {}, --- k, funcs
    _watchIds = {},
    _listView = setmetatable({}, { __mode = "v" }),
    --_listHasSection = {},
    _listWatchs = {}
}

function class:init()
    __open_use_set_cache__ = false
    __open_use_argo_bind__ = true
    __open_cell_data__     = false

    if DataBinding == class then return end

    DataBinding = class

    local argo = require("Argo")
    class._argo = argo

    for k, v in pairs(argo) do
        class[k] = function(t, ...)
            if t == class then
                return v(...)
            end
            return v(t, ...)
        end
    end

    class.watch = function(t, k, filter, func)
        if func == nil then
            func = filter
        end
        filter = 1
        class._watchIndex = class._watchIndex + 1
        local wfs = class._watchs[k]
        if wfs == nil then
            wfs = {}
            class._watchs[k] = wfs
            argo.watch(k, filter, function(...)
                for _, f in pairs(wfs) do
                    f(...)
                end
            end)
        end
        local index = #wfs + 1
        local wid = tostring(class._watchIndex)
        wfs[index] = func
        class._watchIds[wid] = { index, wfs }
        return wid
    end

    class.watchValueAll = class.watch
    class.watchValue = class.watch

    function class:mock(k, v)
        _G[k] = argo.bind(k, v)
        _G[k .. "_mock"] = _G[k]
    end

    function class:get(p)
        local s, r = pcall(function()
            return argo.get(p)
        end)
        if not s then
            r = nil
        end
        return r
    end

    function class:arraySize(p)
        return argo.len(p)
    end

    function class:removeObserver(id)
        local t = class._watchIds[id]
        if t then
            t[2][t[1]] = nil
        end
    end

    function class:bindListView(p, listView)
        class._listView[p] = listView
    end

    function class:getSectionCount(p)
        -- 目前接口暂时无法判断是否是二维数组
        --class._listHasSection[p] = false
        return -1
    end

    function class:getRowCount(p, section)
        -- 目前接口无法判断二维数组，所以无法使用section
        return argo.len(p)
    end

    function class:bindCell(p, section, row, ps)
        local key = p .. tostring(row)
        local ws = class._listWatchs[key]
        if ws ~= nil then
            for _, v in pairs(ws) do
                class:removeObserver(v)
            end
        end
        ws = {}
        class._listWatchs[key] = ws

        local closure = function()
            local view = class._listView[p]
            if view then
                view:reloadData()
            end
        end
        for _, v in pairs(ps) do
            ws[#ws + 1] = class:watch(v, 1, closure)
        end
    end

    function class:getCellData()
        assert(false, "getCellData -- not implement ... ")
    end

end




return class