-- created by l0nger

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