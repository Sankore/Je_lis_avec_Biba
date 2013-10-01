package view
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import tools.CustomEvent;
	import tools.Dispatcher;
	
	
	
	public class BoutonFermerDemo extends MovieClip
	{		
		private static const LABEL_OUT:String = "_out";
		private static const LABEL_OVER:String = "_over";
		public static const CLOSE_DEMO:String = "close_demo";
		public static const AIR:int = 10;
		
		
		
		//---------------------------------------------------------------------------------------
		// INIT
		//---------------------------------------------------------------------------------------
		
		public function BoutonFermerDemo()
		{
			mouseChildren = false;
			addEventListener(MouseEvent.ROLL_OVER, overMe);
			addEventListener(MouseEvent.ROLL_OUT, outMe);
			addEventListener(MouseEvent.CLICK, clickMe);
		}
		
		private function overMe(_event:MouseEvent):void
		{
			gotoAndStop(LABEL_OVER);
		}
		
		private function outMe(_event:MouseEvent):void
		{
			gotoAndStop(LABEL_OUT);
		}
		
		private function clickMe(_event:MouseEvent):void
		{
			removeEventListener(MouseEvent.ROLL_OVER, overMe);
			removeEventListener(MouseEvent.ROLL_OUT, outMe);
			removeEventListener(MouseEvent.CLICK, clickMe);
			Dispatcher.dispatchEvent(new CustomEvent(CLOSE_DEMO));
		}
	}	
}