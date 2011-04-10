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
	/**
	 * ...
	 * @author Maximilien Thiel
	 */
	public class PictureInfos 
	{
		private var _title:String;
		private var _link:String;
		private var _urlOnFFFF:String;
		private var _urlOnAuthor:String;
		private var _author:String;
		private var _pubDate:Date;
		private var _source:String;
		private var _savedBy:int;
		
		
		
		
		public function PictureInfos(title:String = "", link:String = "", urlOnFFFF:String = "", urlOnAuthor:String = "", author:String = "", pubDate:* = null, source:String = "", savedBy:int = 0) 
		{
			init(title, link, urlOnFFFF, urlOnAuthor, author, pubDate, source, savedBy);
		}
		
		public function init(title:String = "", link:String = "", urlOnFFFF:String = "", urlOnAuthor:String = "", author:String = "", pubDate:* = null, source:String = "", savedBy:int = 0):void
		{
			_title = title;
			_link = link;
			_urlOnFFFF = urlOnFFFF;
			_urlOnAuthor = urlOnAuthor;
			_author = author;
			createPubDate(pubDate);
			
			_source = source;
			_savedBy = savedBy;
			
		}
		
		
		private function createPubDate(value:*):void 
		{
			if (value is Date)
			{
				_pubDate = value;
			}
			else if (value is String)
			{
				//from rss pattern :			Sat, 09 Apr 2011 01:58:30 +0900
				//convert to flash std :	Sat Apr 09 01:58:30 GMT+0900 2011
				var s:String = String(value).substr(0, 3) +" " + String(value).substr(8, 3) + " " + String(value).substr(5, 2)+" " + String(value).substr(17, 8) + " GMT" + String(value).substr(26, 5)+" " + String(value).substr(12, 4);
				_pubDate = new Date(Date.parse(s));
			}
			else if (value is Number)
			{
				_pubDate = new Date(value);
			}
			else _pubDate = new Date();
		}
		
		public function get Title():String 
		{
			return _title;
		}
		
		public function set Title(value:String):void 
		{
			_title = value;
		}
		
		public function get Link():String 
		{
			return _link;
		}
		
		public function set Link(value:String):void 
		{
			_link = value;
		}
		
		public function get Author():String 
		{
			return _author;
		}
		
		public function set Author(value:String):void 
		{
			_author = value;
		}
		
		public function get PubDate():Date 
		{
			return _pubDate;
		}
		
		public function set PubDate(value:*):void 
		{
			createPubDate(value);
		}
		
		public function get Source():String 
		{
			return _source;
		}
		
		public function set Source(value:String):void 
		{
			_source = value;
		}
		
		public function get SavedBy():int 
		{
			return _savedBy;
		}
		
		public function set SavedBy(value:int):void 
		{
			_savedBy = value;
		}
		
		public function get UrlOnFFFF():String 
		{
			return _urlOnFFFF;
		}
		
		public function set UrlOnFFFF(value:String):void 
		{
			_urlOnFFFF = value;
		}
		
		public function get UrlOnAuthor():String 
		{
			return _urlOnAuthor;
		}
		
		public function set UrlOnAuthor(value:String):void 
		{
			_urlOnAuthor = value;
		}
		
		
		
		public function toString():String
		{
			return "[PictureInfos: title: " + _title + " link: " + _link + " author: " + _author + " published: " + _pubDate.toString() + "]";
		}
	}

}