assert(coroutine.resume(coroutine.create(function()
  require = function(m)
    return dofile(m .. '.lc')
  end

  -- print(pcall(function()
    require 'App'()
  -- end))
end)))
