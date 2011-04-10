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
	public class MenuEvent extends Event 
	{
		static public const URL_AUTHOR:String = "urlAuthor";
		static public const SAVE:String = "save";
		static public const FFFF_LINK:String = "ffff_link";
		static public const WIDGET_LINK:String = "widget_link";
		static public const COPY:String = "copy";
		static public const DEFAULT:String = "default";
		static public const SOURCE:String = "source";
		static public const AUTHOR:String = "author";
		static public const URL_FFFF:String = "url_ffff";
		static public const LINK:String = "link";
		
		public function MenuEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new MenuEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("MenuEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}