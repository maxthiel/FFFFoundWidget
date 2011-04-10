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
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import com.adobe.crypto.MD5;
	
	/**
	 * ...
	 * @author Maximilien Thiel
	 */
	public class Image extends BitmapData 
	{
		
		private var _infos:PictureInfos;
		private var _hashId:String = "";
		private var _error:String;
		
		public function Image(source:DisplayObject, transparent:Boolean = true, fillColor:uint = 4294967295) 
		{
			super(source.width, source.height, transparent, fillColor);
			init(source);
		}
		
		private function init(source:DisplayObject):void 
		{
			fillRect(new Rectangle(0, 0, source.width, source.height), Main.BG_COLOR);
			draw(source);
		}
		
		public function get Infos():PictureInfos { return _infos; }
		public function set Infos(p:PictureInfos):void { _infos = p; }
		public function setInfos(title:String = "", link:String = "", urlOnFFFF:String = "", urlOnAuthor:String = "", author:String = "", pubDate:* = null, source:String = "", savedBy:int = 0):void
		{
			if (!_infos) _infos = new PictureInfos(title, link, urlOnFFFF, urlOnAuthor, author, pubDate, source, savedBy);
			else _infos.init(title, link, urlOnFFFF, urlOnAuthor, author, pubDate, source, savedBy);
			
			_hashId = MD5.hash(title + link);
		}
		
		override public function dispose():void
		{
			_infos = null;
			super.dispose();
		}
		
		public function get HashId():String { return _hashId; }
		
		public function get error():String 
		{
			return _error;
		}
		
		public function set error(value:String):void 
		{
			_error = value;
		}
		
	}

}