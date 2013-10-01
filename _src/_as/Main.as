package 
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import events.*;
	import tools.*;
	import view.*;
	
	
	
	public class Main extends MovieClip
	{
		private static const DECALAGE:int = 20;
		private var mainXml:XML;
		private var container:MovieClip;	
		private var loaderItem:Loader;	
		private var loaderDemo:Loader;		
		private var popupConfig:PopupConfig;	
		public var background:Background;	
		public var masque:MovieClip;	
		public var roundMasque:MovieClip;	
		public var ariane:TextField;		
		public var scroll:Scroll;
		public var mainTitle:MovieClip;
		public var perso:MovieClip;
		public static var instance:Main;		
		private var itemNiveau:int;
		private var itemCompetence:int;
		private var itemType:int;
		private var itemSource:String;
		private var itemSourceMeta:String;
		private var itemFeedBackMode:int;		
		private var itemIdExercice:int;		
		private var boutonFermerDemo:BoutonFermerDemo;		
		
		
		
		//---------------------------------------------------------------------------------------
		// INIT
		//---------------------------------------------------------------------------------------
		
		public function Main()
		{
			visible = false;
			
			instance = this;
			
			stage.showDefaultContextMenu = false;			
			stage.stageFocusRect = false;
			
			loadMainXml();		
		}
		
		
		
		//---------------------------------------------------------------------------------------
		// LOAD MAIN XML
		//---------------------------------------------------------------------------------------
		
		private function loadMainXml():void
		{
			var mainXmlLoader:URLLoader = new URLLoader();				
			mainXmlLoader.addEventListener(Event.COMPLETE, onMainXmlLoaded);			
			mainXmlLoader.load(new URLRequest("files/xml/explorer.xml"));
		}
		
		private function onMainXmlLoaded(_event:Event):void
		{
			_event.target.removeEventListener(Event.COMPLETE, onMainXmlLoaded);	
			
			mainXml = new XML(_event.target.data);
			
			Dispatcher.addEventListener(ArianeEvent.OPEN_ARIANE, openAriane);
			Dispatcher.addEventListener(ArianeEvent.CLOSE_ARIANE, closeAriane);
			
			if (mainXml.@intro == "true")
				initMainTitle();
			else
				onMainTitleEnd(null);
				
			initBackground();
			initMenu();
			initScroll();
			
			visible = true;
		}
		
		
		
		//---------------------------------------------------------------------------------------
		// MAIN TITLE
		//---------------------------------------------------------------------------------------
		
		private function initMainTitle():void
		{
			mainTitle.addEventListener("MAIN_TITLE_END", onMainTitleEnd);
			mainTitle.gotoAndPlay(1);
		}
		
		private function onMainTitleEnd(_event:Event):void
		{
			mainTitle.visible = false;
			mainTitle.gotoAndStop(1);
		}
		
		
		
		//---------------------------------------------------------------------------------------
		// GET XML DATAS
		//---------------------------------------------------------------------------------------
		
		public function getNiveauName(_idNiveau:int):String
		{
			return mainXml.noms.niveaux.niveau.(@id == _idNiveau).@nom;
		}
		
		public function getCompetenceName(_idCompetence:int):String
		{
			return mainXml.noms.competences.competence.(@id == _idCompetence).@nom;
		}
		
		public function getTypeName(_idType:int):String
		{
			return mainXml.noms.types.type.(@id == _idType).@nom;
		}
		
		
		
		//-----------------------------------------------------------------------------------
		// SCROLL
		//-----------------------------------------------------------------------------------
		
		private function initScroll():void
		{		
			if (container.height > masque.height)
			{
				scroll.enable();
				Dispatcher.addEventListener(Scroll.SCROLLING, onScrolling);
				addEventListener(MouseEvent.MOUSE_WHEEL, onWheeling);
			}
			else
				cleanScroll();
		}
		
		private function cleanScroll():void
		{
			scroll.disable();
			Dispatcher.removeEventListener(Scroll.SCROLLING, onScrolling);
			removeEventListener(MouseEvent.MOUSE_WHEEL, onWheeling);
		}
		
		private function onScrolling(_event:CustomEvent):void
		{
			container.y = int( -((container.height + (DECALAGE * 2) - masque.height) * (_event.params.pourcentage / 100)) + masque.y + DECALAGE);
		}
		
		private function onWheeling(_event:MouseEvent):void
		{
			scroll.wheelContent(_event.delta);
		}
		
		
		
		//-----------------------------------------------------------------------------------
		// ARIANE
		//-----------------------------------------------------------------------------------
		
		private function openAriane(_event:CustomEvent):void
		{				
			setAriane
			(
				_event.params.niveau,
				_event.params.competence,
				_event.params.type,
				_event.params.source,
				_event.params.idExercice
			);
		}
		
		private function closeAriane(_event:CustomEvent):void
		{
			if (popupConfig == null)
			{
				ariane.htmlText = "";
				ariane.visible = false;
			}
		}
		
		private function setAriane(_niveau:int, _competence:int, _type:int, _source:String, _idExercice:int):void
		{				
			var separateur:String = " / ";
			var arianeContent:String = getNiveauName(_niveau);
			arianeContent += separateur;
			arianeContent += getCompetenceName(_competence);
			arianeContent += separateur;
			arianeContent += getTypeName(_type);
			arianeContent += separateur;
			arianeContent += _source;
			
			if (_type == 3)
			{
				arianeContent += separateur;
				arianeContent += "exercice : " + _idExercice;
			}
			
			ariane.multiline = false;
			ariane.autoSize = TextFieldAutoSize.LEFT;
			ariane.htmlText = arianeContent;
			ariane.visible = true;
		}
		
		
		
		//-----------------------------------------------------------------------------------
		// BACKGROUND
		//-----------------------------------------------------------------------------------
		
		private function initBackground():void
		{	
			background.init();
			background.visible = false;
		}
		
		private function cleanBackground():void
		{	
			background.clean();
			background.visible = false;
		}
		
		private function openBackground(_idBg:int, _alpha:Number = 1, _bgColor:String = ""):void
		{	
			var bgColor:String;
			if (_bgColor == "")	bgColor = Background.BG_COLOR_BLACK;
			else bgColor = _bgColor;
			
			background.showBgById(_idBg, _alpha, bgColor);
			background.visible = true;
		}
		
		
		
		//---------------------------------------------------------------------------------------
		// MENU
		//---------------------------------------------------------------------------------------
		
		private function initMenu():void
		{				
			mask = null;
			roundMasque.visible = false;
			
			perso.visible = true;
			
			if (container == null)
			{
				container = new MovieClip();
				container.x = masque.x + DECALAGE + 160;
				container.y = masque.y + DECALAGE;
				container.mask = masque;
				addChildAt(container, numChildren - 1);
				
				var newX:int;
				var newY:int;
				var nNiveaux:int;
				var nCompetences:int;
				var nItems:int;
				var item:ItemLine;
				var type:int;
				var niveau:int;
				var competence:int;
				var nom:String;
				var source:String;
				var sourceMeta:String;
				var idExercice:int;
				var xml:XML;
				
				nNiveaux = mainXml.items.niveau.length();
				
				for (var idNiveau:int = 1; idNiveau <= nNiveaux; idNiveau++)
				{						
					newX = 0;
					
					nom = getNiveauName(idNiveau);
					
					niveau = idNiveau;
					
					item = new ItemLine(masque.width - container.x - newX - DECALAGE, nom, niveau);
					item.x = newX;
					item.y = newY;				
					container.addChild(item);
					
					newY += item.height + DECALAGE;
					
					nCompetences = mainXml.items.niveau.(@id == idNiveau).competence.length();
					
					for (var idCompetence:int = 1; idCompetence <= nCompetences; idCompetence++)
					{		
						newX = item.getPictoWidth();
						
						nom = getCompetenceName(idCompetence);
						
						competence = idCompetence;
						
						item = new ItemLine(masque.width - container.x - newX - DECALAGE, nom, niveau, competence);
						item.x = newX;
						item.y = newY;					
						container.addChild(item);
						
						newY += item.height + DECALAGE;
						
						nItems = mainXml.items.niveau.(@id == idNiveau).competence.(@id == idCompetence).item.length();
						
						for (var idItem:int = 0; idItem < nItems; idItem++)
						{								
							newX = item.getPictoWidth() * 2;
							
							xml = mainXml.items.niveau.(@id == idNiveau).competence.(@id == idCompetence).item[idItem];
							
							nom = xml.@nom;						
							type = int(xml.@type);						
							source = xml.@source;
							sourceMeta = mainXml.items.niveau.(@id == idNiveau).competence.(@id == idCompetence).item.(@type == 2).@source;
							idExercice = xml.@idExercice;
							
							if (type == 3) newX += item.getPictoWidth();
							
							item = new ItemLine(masque.width - container.x - newX - DECALAGE, nom, niveau, competence, type, source, sourceMeta, idExercice);
							item.x = newX;
							item.y = newY;		
							container.addChild(item);
							
							newY += item.height;
							
							if (idItem == (nItems - 1)) newY += DECALAGE;
							else newY += 1;
						}
					}
				}
			}
			else
				container.visible = true;			
			
			Dispatcher.addEventListener(ItemLine.OPEN_ITEM, clickItemLine);
		}
		
		private function cleanMenu():void
		{	
			perso.visible = false;
		
			if (container != null)
				container.visible = false;
			
			Dispatcher.removeEventListener(ItemLine.OPEN_ITEM, clickItemLine);
		}
		
		private function clickItemLine(_event:CustomEvent):void
		{	
			itemNiveau = _event.params.niveau;
			itemCompetence = _event.params.competence;
			itemType = _event.params.type;
			itemSource = _event.params.source;
			itemSourceMeta = _event.params.sourceMeta;
			itemIdExercice = _event.params.idExercice;
			
			switch(itemType)
			{	
				case 1 : openDemo(); break;
				case 2 : openMetaLoader(); break;
				case 3 : openExercice(); break;
			}
		}
		
		
		
		//-----------------------------------------------------------------------------------
		// OPEN DEMO
		//-----------------------------------------------------------------------------------
		
		private function openDemo():void
		{			
			loaderDemo = new Loader();
			loaderDemo.contentLoaderInfo.addEventListener(Event.COMPLETE, onDemoLoaded);
			loaderDemo.load(new URLRequest(itemSource));
		}
		
		private function onDemoLoaded(_event:Event):void
		{	
			loaderDemo.contentLoaderInfo.removeEventListener(Event.COMPLETE, onDemoLoaded);			
			loaderDemo.content.addEventListener("DEMO_END", onDemoEnd);			
			loaderDemo.x = int((background.width - loaderDemo.width) / 2);
			loaderDemo.y = int((background.height - loaderDemo.height) / 2);
			addChild(loaderDemo);
			
			Dispatcher.addEventListener(BoutonFermerDemo.CLOSE_DEMO, onDemoEnd);
			
			boutonFermerDemo = new BoutonFermerDemo();
			boutonFermerDemo.x = int(background.width - boutonFermerDemo.width) - BoutonFermerDemo.AIR;
			boutonFermerDemo.y = BoutonFermerDemo.AIR;
			addChild(boutonFermerDemo);
			
			cleanMenu();
			cleanScroll();
			openBackground(itemNiveau, .5, Background.BG_COLOR_WHITE);
			mask = roundMasque;
			roundMasque.visible = true;
		}
		
		private function onDemoEnd(_event:Event):void
		{				
			Dispatcher.removeEventListener(BoutonFermerDemo.CLOSE_DEMO, onDemoEnd);
			
			if (loaderDemo != null)
			{
				loaderDemo.content.removeEventListener("DEMO_END", onDemoEnd);
				MovieClip(loaderDemo.content).stop();
				loaderDemo.unload();
				removeChild(loaderDemo);
				loaderDemo = null;
			}
			
			if (boutonFermerDemo != null)
			{
				removeChild(boutonFermerDemo);
				boutonFermerDemo = null;
			}
			
			cleanBackground();
			initMenu();
			initScroll();
			
			container.visible = true;
		}
		
		
		
		//-----------------------------------------------------------------------------------
		// OPEN META LOADER
		//-----------------------------------------------------------------------------------
		
		private function openMetaLoader():void
		{				
			openPopupConfig();
			
			setAriane
			(
				itemNiveau,
				itemCompetence,
				itemType,
				itemSource,
				itemIdExercice
			);
		}
		
		
		
		//-----------------------------------------------------------------------------------
		// OPEN EXERCICE
		//-----------------------------------------------------------------------------------
		
		private function openExercice():void
		{
			openMetaLoader();
		}
		
		
		
		//-----------------------------------------------------------------------------------
		// POPUP CONFIG
		//-----------------------------------------------------------------------------------
		
		private function cleanPopupConfig():void
		{				
			if (popupConfig != null)
			{
				popupConfig.clean();
				removeChild(popupConfig);
				popupConfig = null;
			}
			
			Dispatcher.removeEventListener(PopupConfigEvent.CANCEL_CONFIG, onCancelConfig);
			Dispatcher.removeEventListener(PopupConfigEvent.CHOOSE_CONFIG, onChooseConfig);
			
			closeAriane(null);
		}
		
		private function openPopupConfig():void
		{			
			cleanScroll();			
			cleanPopupConfig();
			
			Dispatcher.addEventListener(PopupConfigEvent.CANCEL_CONFIG, onCancelConfig);
			Dispatcher.addEventListener(PopupConfigEvent.CHOOSE_CONFIG, onChooseConfig);
			
			popupConfig = new PopupConfig();	
			addChild(popupConfig);
		}
		
		private function onCancelConfig(_event:CustomEvent):void
		{	
			initScroll();			
			cleanPopupConfig();
		}
		
		private function onChooseConfig(_event:CustomEvent):void
		{	
			itemFeedBackMode = _event.params.feedBackMode;	
			
			cleanPopupConfig();
			cleanMenu();
			cleanScroll();
			openBackground(itemNiveau);
			
			loaderItem = new Loader();
			loaderItem.contentLoaderInfo.addEventListener(Event.COMPLETE, onItemLoaded);
			loaderItem.load(new URLRequest("files/swf/oaalMetaloader.swf"));
		}
		
		private function onItemLoaded(_event:Event):void
		{	
			loaderItem.contentLoaderInfo.removeEventListener(Event.COMPLETE, onItemLoaded);		
			loaderItem.content.addEventListener("exit", exitItem);
			addChild(loaderItem);
			
			mask = roundMasque;
			roundMasque.visible = true;
			
			Dispatcher.dispatchEvent
			(
				new CustomEvent
				(
					"SET_PARAMS",
					{
						niveau:itemNiveau,
						competence:itemCompetence,
						type:itemType,
						source:itemSource,
						sourceMeta:itemSourceMeta,
						feedBackMode:itemFeedBackMode,
						idExercice:itemIdExercice
					}
				)
			);
		}
		
		private function exitItem(_event:Event):void
		{			
			if (loaderItem != null)
			{
				loaderItem.content.removeEventListener("exit", exitItem);
				loaderItem.unload();
				removeChild(loaderItem);
				loaderItem = null;
			}
			
			cleanBackground();
			initMenu();
			initScroll();
			container.visible = true;
			
			//Son.stopBruits();
		}
	}
}