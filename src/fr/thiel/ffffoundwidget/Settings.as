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
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Maximilien Thiel
	 */
	public class Settings 
	{
		
		//key used to navigate
		public static const NEXT:String					= "next";
		public static const PREVIOUS:String			= "previous";
		public static const FIRST:String				= "first";
		public static const LAST:String					= "last";
		public static const SAVE:String					= "save";
		public static const COPY:String					= "copy";
		public static const DIAPORAMA:String		= "diaporama";
		public static const REFRESH:String			= "refresh";
		public static const FULLSCREEN:String		= "fullscreen";
		public static const HELP:String					= "help";
		public static const DEBUG:String				= "debug";
		public static const QUIT:String					= "quit";
		
		private var _keys:Vector.<String>;
		
		private var _smoothScaling:int = 3;
		
		
		public function Settings() 
		{
			init();
		}
		
		private function init():void 
		{
			//set defaults keys
			_keys = new Vector.<String>(300, true);
			_keys[Keyboard.N]				= NEXT;
			_keys[Keyboard.RIGHT]		= NEXT;
			_keys[Keyboard.P]				= PREVIOUS;
			_keys[Keyboard.LEFT]		= PREVIOUS;
			_keys[Keyboard.UP]			= FIRST;
			_keys[Keyboard.DOWN]		= LAST;
			_keys[Keyboard.S]				= SAVE;
			_keys[Keyboard.C]				= COPY;
			_keys[Keyboard.D]				= DIAPORAMA;
			_keys[Keyboard.SPACE]		= DIAPORAMA;
			_keys[Keyboard.R]				= REFRESH;
			_keys[Keyboard.F5]			= REFRESH;
			_keys[Keyboard.F]				= FULLSCREEN;
			_keys[Keyboard.H]				= HELP;
			_keys[Keyboard.F1]			=	HELP;
			_keys[Keyboard.D]				=	DEBUG;
			_keys[Keyboard.I]				=	DEBUG;
			_keys[Keyboard.Q]				=	QUIT;
		}
		
		
		
		
		public function get Keys():Vector.<String>
		{
			return _keys;
		}
		
		public function get SmoothScaling():int 
		{
			return _smoothScaling;
		}
		
		public function set SmoothScaling(value:int):void 
		{
			_smoothScaling = value;
		}
	}

}