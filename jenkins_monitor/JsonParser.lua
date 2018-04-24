return function()
  local data = {}

  local decoder = sjson.decoder({ metatable = {
    checkpath = function(t, path)
      if #path <= 1 then return true end

      if #path == 2 then
        table.insert(data, {})
        local i = #data
        setmetatable(t, {
          __newindex = function(_, k, v)
            if k == 'displayName' or k == 'offline' then
              data[i][k] = v
            end
          end
        })

        return true
      end
    end
  } })

  return {
    feed = function(json)
      pcall(function()
        decoder:write(json)
      end)
    end,

    finished = function()
      return (pcall(function() decoder:result() end))
    end,

    finalize = function()
      return data
    end
  }
end
