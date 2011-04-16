/**************************************************************************
#	This file is part of FFFFound Widget.
#
#	© Maximilien Thiel (2011)
#
#	Contact available on http://www.thiel.fr
#
#	This software is a computer program whose purpose is to let you browse
#	the latest picture posted on ffffound.com
#
#	This software is governed by the CeCILL license under French law and
#	abiding by the rules of distribution of free software. You can use, 
#	modify and/ or redistribute the software under the terms of the CeCILL
#	license as circulated by CEA, CNRS and INRIA at the following URL
#	"http://www.cecill.info". 
#
#	As a counterpart to the access to the source code and rights to copy,
#	modify and redistribute granted by the license, users are provided only
#	with a limited warranty and the software's author, the holder of the
#	economic rights, and the successive licensors have only limited
#	liability. 
#
#	In this respect, the user's attention is drawn to the risks associated
#	with loading, using, modifying and/or developing or reproducing the
#	software by the user in light of its specific status of free software,
#	that may mean that it is complicated to manipulate, and that also
#	therefore means that it is reserved for developers and experienced
#	professionals having in-depth computer knowledge. Users are therefore
#	encouraged to load and test the software's suitability as regards their
#	requirements in conditions enabling the security of their systems and/or 
#	data to be ensured and, more generally, to use and operate it in the 
#	same conditions as regards security. 
#
#	The fact that you are presently reading this means that you have had
#	knowledge of the CeCILL license and that you accept its terms.
#**************************************************************************/



package fr.thiel.ffffoundwidget
{
	import com.greensock.TweenLite;
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeApplication;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.system.fscommand;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.ContextMenu;
	import flash.ui.Keyboard;
	import fr.thiel.ffffoundwidget.events.ImageEvent;
	import fr.thiel.ffffoundwidget.events.MenuEvent;
	
	/**
	 * ...
	 * @author Maximilien Thiel
	 */
	public class Main extends Sprite 
	{
		static public const SOFT_NAME:String = "FFFFoundWidget";
		
		public static const DIMENSION:Rectangle = new Rectangle(0, 0, 320, 240);
		
		[Embed(source = '../../../../lib/yapix.ttf', fontFamily = "Yapix")] private var font:Class;
		
		public static const DEFAULT_FONT:String = "Yapix";
		public static var BG_COLOR:uint = 0x141414;//TODO settings
		
		public static const DEFAULT_FRAMERATE:int = 15;
		public static const ANIM_FRAMERATE:int = 30;
		
		
		private var _info:DebugInfo;
		private var _images:ImageHandler;
		private var _imagesSources:String;
		private var _menu:Menu;
		private var _bg:Sprite;
		
		private var _settings:Settings;
		
		public static var MainStage:Stage;
		
		public function Main():void 
		{
			init();
		}
		
		private function init():void 
		{
			MainStage = stage;
			//TODO save this
			Loc.getInstance().Language = Loc.FRENCH;
			
			_settings = new Settings();
			
			//context menu
			_menu = new Menu();
			_menu.addEventListener(MenuEvent.AUTHOR, menuHandler);
			_menu.addEventListener(MenuEvent.COPY, menuHandler);
			_menu.addEventListener(MenuEvent.DEFAULT, menuHandler);
			_menu.addEventListener(MenuEvent.FFFF_LINK, menuHandler);
			_menu.addEventListener(MenuEvent.LINK, menuHandler);
			_menu.addEventListener(MenuEvent.SAVE, menuHandler);
			_menu.addEventListener(MenuEvent.SOURCE, menuHandler);
			_menu.addEventListener(MenuEvent.URL_AUTHOR, menuHandler);
			_menu.addEventListener(MenuEvent.URL_FFFF, menuHandler);
			_menu.addEventListener(MenuEvent.WIDGET_LINK, menuHandler);
			contextMenu = _menu.contextMenu;
			
			_bg = new Sprite();
			updateInteractiveBG();
			_bg.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler, false, 0, true);
			
			//Create main textfield
			_info = new DebugInfo(Main.DIMENSION, Main.BG_COLOR);
			_info.text = Loc.getInstance().__("init");
			addChild(_info);
			_info.show();
			
			//create ffffound image handler
			_imagesSources = "http://feeds.feedburner.com/ffffound/everyone";//TODO settings
			_images = new ImageHandler(_imagesSources);
			_images.addEventListener(ImageEvent.ERR_RSS_LOADING, imagesHandler);
			_images.addEventListener(ImageEvent.ERR_RSS_READ, imagesHandler);
			_images.addEventListener(ImageEvent.RSS_READY, imagesHandler);
			_images.addEventListener(ImageEvent.RSS_LOADING, imagesHandler);
			_images.addEventListener(ImageEvent.PIC_HANDLER_READY, imagesHandler);
			_images.addEventListener(ImageEvent.PIC_READY, imagesHandler);
			_images.addEventListener(ImageEvent.PIC_DRAWN, imagesHandler);
			_images.addEventListener(ImageEvent.ERR_PIC_LOADING, imagesHandler);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, kbHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, kbHandler);
		}
		
		private function menuHandler(e:MenuEvent):void 
		{
			switch(e.type)
			{
				case MenuEvent.FFFF_LINK :
				{
					navigateTo("http://ffffound.com");
				}break;
				case MenuEvent.WIDGET_LINK :
				{
					//widget homepage
					navigateTo("http://www.thiel.fr");
				}break;
				case MenuEvent.DEFAULT :
				case MenuEvent.LINK :
				{
					navigateTo(_menu.PicInfos.Link);
				}break;
				case MenuEvent.URL_FFFF :
				{
					navigateTo(_menu.PicInfos.UrlOnFFFF);
				}break;
				case MenuEvent.URL_AUTHOR :
				{
					navigateTo(_menu.PicInfos.UrlOnAuthor);
				}break;
				case MenuEvent.AUTHOR :
				case MenuEvent.SOURCE :
				{
					navigateTo(_menu.PicInfos.Source);
				}break;
				case MenuEvent.COPY :
				{
					picToClipboard();
				}break;
				case MenuEvent.SAVE :
				{
					downloadPic();
				}break;
			}
		}
		
		private function downloadPic():void 
		{
			var f:FileReference = new FileReference();
			f.download(new URLRequest(_menu.PicInfos.UrlOnFFFF));
		}
		
		private function picToClipboard():void 
		{
			Clipboard.generalClipboard.clearData(ClipboardFormats.BITMAP_FORMAT);
			Clipboard.generalClipboard.setData(ClipboardFormats.BITMAP_FORMAT, _images.currentImage);
		}
		
		/**
		 * Navigate to an url
		 * @param	url
		 */
		public function navigateTo(url:String):void 
		{
			var ur:URLRequest = new URLRequest(url);
			navigateToURL(ur);
		}
		
		private function kbHandler(e:KeyboardEvent):void 
		{
			if (e.keyCode >= _settings.Keys.length)
			{
				trace("out of bound key code, sorry");
				return;
			}
			
			var action:String = _settings.Keys[e.keyCode];
			if (e.type == KeyboardEvent.KEY_DOWN)
			{
				switch(action)
				{
					case Settings.DEBUG :
					{
						if (contains(_info) || !contains(_images.view)) return;//still on startup
						_info.show(this)
					}break;
					
					case Settings.HELP:
					{
						//show help
					}break;
					
				}
			}
			if (e.type == KeyboardEvent.KEY_UP)
			{
				switch(action)
				{
					case Settings.DEBUG :
					{
						if (!contains(_info)) return;
						_info.hide(true);
					}break;
					
					case Settings.HELP:
					{
						//hide help
					}break;
					
					case Settings.NEXT :				{ _images.nextPicture(Transition.MOVE_RIGHT); } break;
					case Settings.PREVIOUS :		{ _images.previousPicture(Transition.MOVE_LEFT); } break;
					case Settings.LAST :				{ _images.lastPicture(Transition.MOVE_DOWN); } break;
					case Settings.FIRST :				{ _images.firstPicture(Transition.MOVE_UP); } break;
					
					case Settings.SAVE :				{ downloadPic(); } break;
					case Settings.COPY :				{ picToClipboard(); } break;
					case Settings.QUIT :				{ quit(); } break;
				}
			}
		}
		
		private function quit():void 
		{
			NativeApplication.nativeApplication.exit();
		}
		
		private function updateInteractiveBG():void 
		{
			_bg.graphics.beginFill(BG_COLOR, 0);
			_bg.graphics.drawRect(0, 0, DIMENSION.width, DIMENSION.height);
			_bg.graphics.endFill();
			addChildAt(_bg, 0);
		}
		
		private function mouseHandler(e:MouseEvent):void 
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
				{
					stage.nativeWindow.startMove();
				}break;
				case MouseEvent.MOUSE_UP:
				{
					stage.nativeWindow.startMove();
				}break;
			}
		}
		
		private function imagesHandler(e:ImageEvent):void 
		{
			switch(e.type)
			{
				case ImageEvent.PIC_HANDLER_READY:
				{
					//image handler has finished loading at least one picture
					//TODO reactivate controls
					_images.firstPicture();
					_menu.PicInfos = _images.currentImage.Infos;
					if (!contains(_images.view)) addChild(_images.view);
					if (contains(_info)) removeChild(_info);
				}break;
				
				case ImageEvent.PIC_READY :
				{
					_info.text = _info.text + "\n" + Loc.getInstance().__("pic_ready", _images.imageInfos(e.pictureIndex).Title);
				}break;
				case ImageEvent.PIC_DRAWN:
				{
					_menu.PicInfos = _images.currentImage.Infos;
					_info.text = _info.text + "\n" + Loc.getInstance().__("view_pic", e.pictureIndex+1, _images.TotalPictures);
				}break;
				
				case ImageEvent.ERR_RSS_LOADING :
				case ImageEvent.ERR_RSS_READ :
				case ImageEvent.ERR_PIC_LOADING :
				{
					_info.text = _info.text + "\n" + Loc.getInstance().__("error", e.toString());
				}break;
			}
		}
	}
	
}