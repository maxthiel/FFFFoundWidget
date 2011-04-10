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
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author Maximilien Thiel
	 */
	public class DebugInfo extends InfoObject
	{
		private var _tf:TextField;
		
		public function DebugInfo(dimension:Rectangle, color:uint, transparency:Number=0.7) 
		{
			super(dimension, color, transparency);
			
			_tf = new TextField();
			var format:TextFormat = new TextFormat();
			format.font = Main.DEFAULT_FONT;
			format.size = 10;
			format.color = 0xFFFFFF;
			format.align = TextFormatAlign.LEFT;
			_tf.defaultTextFormat = format;
			_tf.width = Main.DIMENSION.width;
			_tf.height = Main.DIMENSION.height;
			_tf.wordWrap = true;
			_tf.multiline = true;
			addChild(_tf);
		}
		
		
		public function get text():String { return _tf.text; }
		public function set text(s:String):void { _tf.text = s;}
		
	}

}