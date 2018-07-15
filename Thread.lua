--
--	@author: l0nger <l0nger.programmer@gmail.com>
--

Thread={ }
local threads={ }
local THREAD_INTERVAL=5000
local __DEBUG=true 

function Thread:new( ... )
	local o=setmetatable( { }, { __index=self } )
	if o.constuctor then
		o:constuctor( ... )
	end

	return o
end

-- szName - thread name 
-- uFunc - callback
-- iAmounts - how many times to call
function Thread:constuctor( szName, uFunc, iAmounts )
	assert( threads[szName]==nil )

	self.name=szName
	self.func=uFunc
	self.amounts=iAmounts or 1

	threads[szName]=self

	if __DEBUG then
		outputDebugString( "[thread: "..self.name.."] created" )
	end
end

function Thread:start( ms )
	self.thread=coroutine.create( self.func )
	self.yields=0
	self.tick=getTickCount( )

	self:resume( )

	self.timer=setTimer( function( )
		if self:status( )=="suspended" then
			if getTickCount( )-self.tick>THREAD_INTERVAL then
				self.tick=getTickCount( )

				if __DEBUG then
					outputDebugString( "[thread: "..self.name.."] yield "..self.yields )
				end
			end
			for i=1, self.amounts, 1 do
				self.yields=self.yields+1
				self:resume( )
			end
		end
		if self:status( )=="dead" then
			if self.timer then 
				killTimer( self.timer )
			end
			self:stop( )
		end
	end, ms, 0 )
end

function Thread:resume( )
	coroutine.resume( self.thread )
end

function Thread:status( )
	if self.thread then
		return coroutine.status( self.thread )
	end
end

function Thread:stop( )
	self.thread=nil

	if __DEBUG then
		outputDebugString( "thread: "..self.name.." completed, yields: "..self.yields )
	end
end