coroutine.resume(coroutine.create(function()
  require = function(m)
    return dofile(m .. '.lc')
  end

  require 'App'()
end))
