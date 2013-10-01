package tools 
{	
	import flash.events.Event;
	
	
	
	public class CustomEvent extends Event
	{
		public var params:Object;
		
		
		//-----------------------------------------------------------------------------------
		// INIT
		//-----------------------------------------------------------------------------------
		
		public function CustomEvent(_type:String = "", _params:Object = null)
		{
			params = _params;
			super(_type);
		}
	}	
}