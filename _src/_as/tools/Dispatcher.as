package tools
{	
	public const Dispatcher:DispatcherI = new DispatcherI();	
}	

//......................................................................................................

import flash.events.Event;
import flash.events.EventDispatcher;

internal class DispatcherI extends EventDispatcher
{	
	public function DispatcherI() 
	{
		super();
	}
}