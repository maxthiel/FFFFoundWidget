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



package fr.thiel.ffffoundwidget.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Maximilien Thiel
	 */
	public class ImageEvent extends Event 
	{
		static public const PIC_DRAWN:String = "pic_drawn";
		static public const PIC_HANDLER_READY:String = "pic_handler_ready";
		public static const PIC_READY:String = "pic_ready";
		public static const	ERR_PIC_LOADING:String = "err_pic_loading";
		public static const ERR_RSS_LOADING:String = "err_rss_loading";
		public static const ERR_RSS_READ:String = "err_rss_read";
		public static const RSS_LOADING:String = "rss_loading";
		public static const RSS_READY:String = "rss_ready";
		
		private var _picIndex:int = -1;
		
		public function ImageEvent(type:String, pictureIndex:int=-1, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			_picIndex = pictureIndex
			
		} 
		
		public override function clone():Event 
		{ 
			return new ImageEvent(type, pictureIndex, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{
			if(_picIndex >= 0)
				return formatToString("ImageEvent", "type", "pictureIndex", "bubbles", "cancelable", "eventPhase"); 
			else
				return formatToString("ImageEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get pictureIndex():int 
		{
			return _picIndex;
		}
		
	}
	
}