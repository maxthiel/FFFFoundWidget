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
	 * Localisation class
	 * @author Maximilien Thiel
	 */
	public class Loc 
	{
		public static const ENGLISH:String = 'en_UK';
		public static const FRENCH:String = 'fr_FR';
		
		
		private static var _instance:Loc;
		private var _currentLanguage:String;
		private var _availableLanguages:Vector.<String>;
		
		[Embed(source = '../../../../lib/Localisation.xml', mimeType = 'application/octet-stream')] private var lang:Class;
		private var _langFile:XML;
		
		/**
		 * Constructor shouldn't be called, this is a singleton based class.
		 * @private
		 */
		public function Loc() 
		{
			if(_instance)
			{
				throw new Error ("We only use this as a singleton. Use getInstance() please.");
			}
			init();
		}
		
		private function init():void 
		{
			_availableLanguages = new Vector.<String>(2, true);
			_availableLanguages[0] = FRENCH;
			_availableLanguages[1] = ENGLISH;
			_langFile = new XML(new lang());
		}
		
		/**
		 * Acces to the singleton instance of the Loc class
		 * @return		Singleton instance of Loc
		 */
		public static function getInstance():Loc
		{
			if (!_instance) _instance = new Loc();
			return _instance;
		}
		
		/**
		 * Translation function
		 * @param	s				String ID of the text to be translated
		 * @param ...rest	Parameters that will replace each occurence of %%x, given their orders
		 * @return				Translated text if it exists, or string id.
		 */
		public function __(s:String, ...rest ):String
		{
			var ret:String = _langFile[s][_currentLanguage].toString();
			if (ret == null || ret == "") ret = s;
			
			if (rest)
			{
				var p:RegExp;
				for (var i:int = 0; i < rest.length; i++)
				{
					p = new RegExp("%%" + String(i + 1), 'g');
					ret = ret.replace(p, rest[i]);
				}
			}
			return ret;
		}
		
		/**
		 * Current selected language
		 */
		public function get Language():String { return _currentLanguage; }
		/**
		 * @private
		 */
		public function set Language(s:String):void
		{
			if (_availableLanguages.indexOf(s) >= 0) _currentLanguage = s;
			else
			{
				throw new Error("This language is not available, sorry.");
			}
		}
		
	}

}