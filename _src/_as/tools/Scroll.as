package tools
{
	import flash.display.MovieClip;	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	
	
	public class Scroll extends MovieClip
	{
		public static const SCROLLING:String = "please_scroll_my_contenu";		
		private static const PAS:int = 40;	
		private var yMin:int;		
		private var yMax:int;			
		private var bounds:Rectangle;
		private var status:Boolean;
		public var poignee:MovieClip;
		public var zonePoignee:MovieClip;
		
		
		
		public function Scroll()
		{
			yMin = zonePoignee.y;
			yMax = yMin + zonePoignee.height - poignee.height;
			bounds = new Rectangle(0, yMin, 0, zonePoignee.height - poignee.height);
		}
		
		public function enable():void
		{						
			status = true;
			//poignee.visible = status;
			poignee.mouseChildren = false;
			poignee.addEventListener(MouseEvent.MOUSE_DOWN, dragMe);
		}		
		
		public function disable():void
		{
			status = false;
			//poignee.visible = status;
			poignee.removeEventListener(MouseEvent.MOUSE_DOWN, dragMe);			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveContent);
			stage.removeEventListener(MouseEvent.MOUSE_UP, dropMe);
		}	
		
		public function wheelContent(_delta:Number):void
		{
			if (_delta > 0) poignee.y -= PAS; 
			else poignee.y += PAS;				
			if (poignee.y < yMin) poignee.y = yMin;
			if (poignee.y > yMax) poignee.y = yMax;
			
			moveContent();
		}
		
		private function dragMe(_event:MouseEvent):void
		{			
			poignee.removeEventListener(MouseEvent.MOUSE_DOWN, dragMe);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, moveContent);
			stage.addEventListener(MouseEvent.MOUSE_UP, dropMe);
			
			poignee.startDrag(false, bounds);
		}
		
		private function dropMe(_event:MouseEvent):void
		{			
			poignee.addEventListener(MouseEvent.MOUSE_DOWN, dragMe);			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveContent);
			stage.removeEventListener(MouseEvent.MOUSE_UP, dropMe);
			
			poignee.stopDrag();
		}
		
		private function moveContent(_event:MouseEvent = null):void
		{
			var pourcentage:Number = ((poignee.y - yMin) * 100) / (zonePoignee.height - poignee.height);			
			Dispatcher.dispatchEvent(new CustomEvent(SCROLLING, { pourcentage:pourcentage } ));
		}
	}	
}