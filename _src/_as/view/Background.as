package view
{
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	
	
	
	public class Background extends MovieClip
	{		
		public static const BG_COLOR_BLACK:String = "bg_color_black";
		public static const BG_COLOR_WHITE:String = "bg_color_white";
		private static const N_BG:int = 7;
		private static const FADE_SPEED:Number = 3;
		private var currentIdBg:int;
		private var currentBg:MovieClip;
		private var nextBg:MovieClip;
		public var bgBlack:MovieClip;
		public var bgWhite:MovieClip;
		public var bg_1:MovieClip;
		public var bg_2:MovieClip;
		public var bg_3:MovieClip;
		public var bg_4:MovieClip;
		public var bg_5:MovieClip;
		public var bg_6:MovieClip;
		public var bg_7:MovieClip;
		
		
		
		//---------------------------------------------------------------------------------------
		// INIT / CLEAN
		//---------------------------------------------------------------------------------------
		
		public function init():void
		{			
			clean();
		}
		
		public function clean():void
		{			
			currentIdBg = 0;
			
			if (currentBg != null)
			{
				TweenMax.killTweensOf(currentBg);
				TweenMax.killDelayedCallsTo(currentBg);
				currentBg = null;
			}
			
			if (nextBg != null)
			{
				TweenMax.killTweensOf(nextBg);
				TweenMax.killDelayedCallsTo(nextBg);
				nextBg = null;
			}
			
			for (var idBg:int = 1; idBg <= N_BG; idBg++)
			{				
				MovieClip(getChildByName("bg_" + idBg)).visible = false;
			}
		}
		
		
		
		//---------------------------------------------------------------------------------------
		// SHOW BG BY ID
		//---------------------------------------------------------------------------------------
		
		public function showBgById(_idBg:int, _alpha:Number = 1, _bgColor:String = ""):void
		{			
			if (_idBg != currentIdBg)
			{
				bgBlack.visible =
				bgWhite.visible = false;
				
				var bgColor:String;
				if (_bgColor == "")	bgColor = BG_COLOR_BLACK;
				else bgColor = _bgColor;
				
				if (bgColor == BG_COLOR_BLACK) bgBlack.visible = true;
				else bgWhite.visible = true;
				
				currentIdBg = _idBg;
				
				if (currentIdBg > 0)
				{
					nextBg = MovieClip(getChildByName("bg_" + currentIdBg));
					nextBg.alpha = 0;
					nextBg.visible = true;
				}
				
				if (currentBg != null)
				{
					TweenMax.to(currentBg, FADE_SPEED, { alpha:0, onComplete:function()
					{
						currentBg.visible = false;
						
						if (nextBg != null)
						{
							TweenMax.to(nextBg, FADE_SPEED, { alpha:_alpha, onComplete:function()
							{
								currentBg = nextBg;
							}});
						}
					}});
				}
				else
				{					
					if (nextBg != null)
					{
						TweenMax.to(nextBg, FADE_SPEED, { alpha:_alpha, onComplete:function()
						{
							currentBg = nextBg;
						}});
					}
				}
			}
		}
	}
}