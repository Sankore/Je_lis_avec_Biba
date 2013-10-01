package view
{
	import com.greensock.easing.Strong;
	import com.greensock.TweenMax;
	import events.PopupConfigEvent;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import tools.CustomEvent;
	import tools.Dispatcher;
	
	
	
	public class PopupConfig extends MovieClip
	{		
		private static const BT_LABEL_OUT:String = "_out";
		private static const BT_LABEL_OVER:String = "_over";
		//private static const N_MODES:int = 3;
		private static const N_MODES:int = 2;
		public var bouton_1:MovieClip;
		public var bouton_2:MovieClip;
		//public var bouton_3:MovieClip;
		public var fond:MovieClip;
		
		
		
		//---------------------------------------------------------------------------------------
		// CONSTRUCTOR
		//---------------------------------------------------------------------------------------
		
		public function PopupConfig()
		{			
			alpha = 0;
			y = 20;
			
			TweenMax.to(this, .3, { y:0, alpha:1, ease:Strong.easeOut, onComplete:function()
			{
				var bouton:MovieClip;
				for (var i:int = 1; i <= N_MODES; i++)
				{
					bouton = getChildByName("bouton_" + i) as MovieClip;
					bouton.gotoAndStop(BT_LABEL_OUT);
					bouton.mouseChildren = false;
					bouton.addEventListener(MouseEvent.ROLL_OVER, overBouton);
					bouton.addEventListener(MouseEvent.ROLL_OUT, outBouton);
					bouton.addEventListener(MouseEvent.CLICK, chooseConfig);
				}
				
				fond.addEventListener(MouseEvent.CLICK, cancelConfig);
			}});
		}
		
		public function clean():void
		{	
			TweenMax.killTweensOf(this);
			TweenMax.killDelayedCallsTo(this);
			
			var bouton:MovieClip;
			for (var i:int = 1; i <= N_MODES; i++)
			{
				bouton = getChildByName("bouton_" + i) as MovieClip;
				bouton.gotoAndStop(BT_LABEL_OUT);
				bouton.removeEventListener(MouseEvent.ROLL_OVER, overBouton);
				bouton.removeEventListener(MouseEvent.ROLL_OUT, outBouton);
				bouton.removeEventListener(MouseEvent.CLICK, chooseConfig);
			}
			
			fond.removeEventListener(MouseEvent.CLICK, cancelConfig);
		}
		
		
		
		//---------------------------------------------------------------------------------------
		// OVER / OUT / CLICK BOUTONS
		//---------------------------------------------------------------------------------------
		
		private function overBouton(_event:MouseEvent):void
		{
			MovieClip(_event.currentTarget).gotoAndStop(BT_LABEL_OVER);
		}
		
		private function outBouton(_event:MouseEvent):void
		{
			MovieClip(_event.currentTarget).gotoAndStop(BT_LABEL_OUT);
		}
		
		private function chooseConfig(_event:MouseEvent):void
		{
			Dispatcher.dispatchEvent(new CustomEvent(PopupConfigEvent.CHOOSE_CONFIG, { feedBackMode:_event.currentTarget.name.split("_")[1] } ));
		}
		
		
		
		//---------------------------------------------------------------------------------------
		// CLICK FOND = CANCEL
		//---------------------------------------------------------------------------------------
		
		private function cancelConfig(_event:MouseEvent):void
		{
			Dispatcher.dispatchEvent(new CustomEvent(PopupConfigEvent.CANCEL_CONFIG));
		}
	}	
}