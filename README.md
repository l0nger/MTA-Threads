# MTA-Threads
Thread system using lua-coroutines


# Operation on Thread
```lua
local process=0
local function CThreadTest( )
	for i=1, 10 do
		process=process+1
		outputDebugString( "thread process: "..process )

		coroutine.yield( ) -- wymagane
	end
end

local thread=Thread:new( "Test thread", CThreadTest )

addCommandHandler( "tstart", function( )
	thread:start( 1000 )
end )
```


# All functions for Thread
```lua
Thread:new( name, callback, amount ) -- create a new thread (default amount is 1)
Thread:start( time ) -- start thread, time set in miliseconds
Thread:resume( )
Thread:status( )
Thread:stop( )
```
