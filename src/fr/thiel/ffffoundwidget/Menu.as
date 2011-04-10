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
	import flash.display.NativeMenu;
	import flash.events.ContextMenuEvent;
	import flash.events.EventDispatcher;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import fr.thiel.ffffoundwidget.events.MenuEvent;
	
	/**
	 * ...
	 * @author Maximilien Thiel
	 */
	public class Menu extends EventDispatcher
	{
		private var _contextMenu:ContextMenu;
		
		/**
		 * Reference to the current picinfo from the Image object
		 */
		private var _picInfos:PictureInfos;
		
		private var _ffffLink:ContextMenuItem;
		
		private var _title:ContextMenuItem;
		private var _link:ContextMenuItem;
		private var _urlOnFFFF:ContextMenuItem;
		private var _urlOnAuthor:ContextMenuItem;
		private var _author:ContextMenuItem;
		private var _pubDate:ContextMenuItem;
		private var _source:ContextMenuItem;
		private var _savedBy:ContextMenuItem;
		private var _copy:ContextMenuItem;
		private var _save:ContextMenuItem;
		
		private var _wdgtLink:ContextMenuItem;
		
		public function Menu() 
		{
			super();
			init();
		}
		
		private function init():void 
		{
			_contextMenu = new ContextMenu();
			_contextMenu.hideBuiltInItems();
			_ffffLink = new ContextMenuItem("FFFFound.com");
			_contextMenu.addItem(_ffffLink);
			
			_title = new ContextMenuItem(Loc.getInstance().__("no_pic_yet"), true, false);
			_contextMenu.addItem(_title);
			_link = new ContextMenuItem(Loc.getInstance().__("view_on_ffffound"),false, true, false);
			_contextMenu.addItem(_link);
			_urlOnFFFF = new ContextMenuItem(Loc.getInstance().__("picture_link_ffff"),false, true, false);
			_contextMenu.addItem(_urlOnFFFF);
			_urlOnAuthor = new ContextMenuItem(Loc.getInstance().__("picture_link_author"),false, true, false);
			_contextMenu.addItem(_urlOnAuthor);
			_author = new ContextMenuItem("",false, true, false);
			_contextMenu.addItem(_author);
			_pubDate = new ContextMenuItem("",false, true, false);
			_contextMenu.addItem(_pubDate);
			_source = new ContextMenuItem("",false, true, false);
			_contextMenu.addItem(_source);
			_savedBy = new ContextMenuItem("",false, true, false);
			_contextMenu.addItem(_savedBy);
			_copy = new ContextMenuItem(Loc.getInstance().__("copy_pic"),false, true, false);
			_contextMenu.addItem(_copy);
			_save = new ContextMenuItem(Loc.getInstance().__("save_pic"),false, true, false);
			_contextMenu.addItem(_save);
			
			_wdgtLink = new ContextMenuItem(Main.SOFT_NAME, true);
			_contextMenu.addItem(_wdgtLink);
			
			for (var i:int = 0; i < _contextMenu.numItems;i++ )
				_contextMenu.items[i].addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, selectHandler);
		}
		
		private function selectHandler(e:ContextMenuEvent):void 
		{
			switch(e.target)
			{
				case _ffffLink:				dispatchEvent(new MenuEvent(MenuEvent.FFFF_LINK));		break;
				case _wdgtLink:				dispatchEvent(new MenuEvent(MenuEvent.WIDGET_LINK));	break;
				case _copy:						dispatchEvent(new MenuEvent(MenuEvent.COPY));					break;
				case _save:						dispatchEvent(new MenuEvent(MenuEvent.SAVE));					break;
				case _link:						dispatchEvent(new MenuEvent(MenuEvent.LINK));					break;
				case _urlOnFFFF:			dispatchEvent(new MenuEvent(MenuEvent.URL_FFFF));			break;
				case _urlOnAuthor:		dispatchEvent(new MenuEvent(MenuEvent.URL_AUTHOR));		break;
				case _author:					dispatchEvent(new MenuEvent(MenuEvent.AUTHOR));				break;
				case _source:					dispatchEvent(new MenuEvent(MenuEvent.SOURCE));				break;
				
				//all the other, default go to fffound page
				case _pubDate :
				case _title :
				case _savedBy :
				{
					dispatchEvent(new MenuEvent(MenuEvent.DEFAULT));
				} break;
			}
		}
		
		
		public function set PicInfos(p:PictureInfos):void
		{
			if (p == null)
			{
				_title.caption = Loc.getInstance().__("no_pic_yet");
				_title.enabled = false;
				_link.visible = false;
				_urlOnFFFF.visible = false;
				_urlOnAuthor.visible = false;
				_author.visible = false;
				_pubDate.visible = false;
				_source.visible = false;
				_copy.visible = false;
				_savedBy.visible = false;
				_picInfos = null;
			}
			else
			{
				_picInfos = p;
				_title.caption			= Loc.getInstance().__("title", p.Title);
				_title.enabled			= true;
				_author.caption			= Loc.getInstance().__("author", p.Author);
				//arguments order : YYYY MM DD HH mm ss T
				_pubDate.caption		= Loc.getInstance().__("pub_date", p.PubDate.fullYear, p.PubDate.month, p.PubDate.day, p.PubDate.hours, p.PubDate.minutes, p.PubDate.seconds, p.PubDate.timezoneOffset );
				var s:String
				if (p.Source.length > 40)
				{
					//rm www ?
					if (p.Source.substr(7, 4) == "www.") s = p.Source.substr(11, 20) + "..." + p.Source.substr(p.Source.length - 6, 5);
					else s = p.Source.substr(7, 15) + "..." + p.Source.substr(p.Source.length - 6, 3);
				}
				else s = p.Source;
				_source.caption			= Loc.getInstance().__("source", s);
				if(p.SavedBy <= 1)
					_savedBy.caption		= Loc.getInstance().__("saved_by_singular", p.SavedBy.toString());
				else
					_savedBy.caption		= Loc.getInstance().__("saved_by_plural", p.SavedBy.toString());
				
				_link.visible					= true;
				_urlOnFFFF.visible		= true;
				_urlOnAuthor.visible	= true;
				_author.visible				= true;
				_pubDate.visible			= true;
				_source.visible				= true;
				_copy.visible					= true;
				_save.visible					= true;
				_savedBy.visible			= true;
			}
		}
		
		public function get PicInfos():PictureInfos { return _picInfos; };
		
		
		public function get contextMenu():ContextMenu
		{
			return _contextMenu;
		}
	}

}