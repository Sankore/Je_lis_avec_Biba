package view
{
	import events.ArianeEvent;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import tools.CustomEvent;
	import tools.Dispatcher;
	
	
	
	public class ItemLine extends MovieClip
	{			
		public static const OPEN_ITEM:String = "open_item";
		private var newX:int;
		private var newWidth:int;
		private var newText:String;
		private var nom:String;
		private var niveau:int;
		private var competence:int;
		private var type:int;
		private var source:String;
		private var sourceMeta:String;
		private var idExercice:int;
		private var goodFrame:String;
		public var texte:TextField;
		public var picto:MovieClip;
		public var fond:MovieClip;
		
		
		
		//---------------------------------------------------------------------------------------
		// INIT / CLEAN
		//---------------------------------------------------------------------------------------
		
		public function ItemLine
		(
			_newWidth:int,
			_nom:String,
			_niveau:int = 0,
			_competence:int = 0,
			_type:int = 0,
			_source:String = "",
			_sourceMeta:String = "",
			_idExercice:int = 0
		):void
		{				
			newWidth = _newWidth;
			nom = _nom;
			niveau = _niveau;
			competence = _competence;
			type = _type;
			source = _source;			
			sourceMeta = _sourceMeta;			
			idExercice = _idExercice;
			
			initPicto();
			initTexte();
			initFond();
			initButtonState();
		}
		
		public function clean():void
		{
			cleanTexte();
			cleanPicto();
			cleanFond();
			cleanButtonState();
		}
		
		
		
		//---------------------------------------------------------------------------------------
		// TEXTE
		//---------------------------------------------------------------------------------------
		
		private function initTexte():void
		{			
			texte.x = newX;
			texte.width = newWidth;
			texte.multiline = true;
			texte.autoSize = TextFieldAutoSize.LEFT;
			texte.htmlText = newText;
		}
		
		private function cleanTexte():void
		{
		}
		
		
		
		//---------------------------------------------------------------------------------------
		// PICTO
		//---------------------------------------------------------------------------------------
		
		private function initPicto():void
		{		
			var newFontSize:int;
			
			newText = nom;	
			
			if (type != 0)
			{
				if (type == 1) goodFrame = "demonstration";
				else if (type == 2) goodFrame = "sequence";
				else if (type == 3) goodFrame = "exercice";
				
				newX = picto.width + 5;
				newWidth -= newX;
				newFontSize = 12;			
			}
			else
			{					
				if (competence != 0)
				{
					goodFrame = "competence";
					newFontSize = 16;
				}
				else
				{
					goodFrame = "niveau";
					newFontSize = 20;
					newText = nom.toUpperCase();
				}
				
				picto.visible = false;
				
				newX = 0;
			}
			
			newText = "<font size='" + newFontSize + "'>" + newText + "</font>";
			
			picto.gotoAndStop(goodFrame);
		}
		
		private function cleanPicto():void
		{
		}
		
		public function getPictoWidth():int
		{
			return picto.width;
		}
		
		
		
		//---------------------------------------------------------------------------------------
		// FOND
		//---------------------------------------------------------------------------------------
		
		private function initFond():void
		{
			fond.x = newX;
			fond.width = int(texte.width);
			fond.alpha = 0;
			
			if (texte.height > fond.height)
				fond.height = int(texte.height);
		}
		
		private function cleanFond():void
		{
		}
		
		
		
		//---------------------------------------------------------------------------------------
		// BUTTON STATE
		// only for type 1, 2, 3
		//---------------------------------------------------------------------------------------
		
		private function initButtonState():void
		{	
			if (type != 0)
			{
				mouseChildren = false;
				addEventListener(MouseEvent.ROLL_OVER, overMe);
				addEventListener(MouseEvent.ROLL_OUT, outMe);
				addEventListener(MouseEvent.CLICK, clickMe);
			}	
		}
		
		private function cleanButtonState():void
		{	
			if (type != 0)
			{
				mouseChildren = false;
				addEventListener(MouseEvent.ROLL_OVER, overMe);
				addEventListener(MouseEvent.ROLL_OUT, outMe);
				addEventListener(MouseEvent.CLICK, clickMe);
			}
		}
		
		
		
		//---------------------------------------------------------------------------------------
		// OVER / OUT / CLICK
		//---------------------------------------------------------------------------------------
		
		private function overMe(_event:MouseEvent):void
		{	
			Dispatcher.dispatchEvent(new CustomEvent(ArianeEvent.OPEN_ARIANE, { niveau:niveau, competence:competence, type:type, source:source, idExercice:idExercice } ));
			
			texte.htmlText = "<u><font color='#FFFF00'>" + newText + "</font></u>";
		}
		
		private function outMe(_event:MouseEvent):void
		{		
			Dispatcher.dispatchEvent(new CustomEvent(ArianeEvent.CLOSE_ARIANE));
			
			texte.htmlText = "<font color='#FFFFFF'>" + newText + "</font>";
		}
		
		private function clickMe(_event:MouseEvent):void
		{		
			Dispatcher.dispatchEvent(new CustomEvent(OPEN_ITEM, { niveau:niveau, competence:competence, type:type, source:source, sourceMeta:sourceMeta, idExercice:idExercice } ));	
		}
	}
}