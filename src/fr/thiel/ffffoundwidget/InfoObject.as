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
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Maximilien Thiel
	 */
	public class InfoObject extends Sprite 
	{
		public static const TRANSITION_DEFAULT:Number = 0.25;
		private var _color:uint;
		private var _alpha:Number;
		private var _dimension:Rectangle
		
		public function InfoObject(dimension:Rectangle, color:uint, transparency:Number=0.7) 
		{
			init(dimension, color, transparency);
		}
		
		private function init(dimension:Rectangle, color:uint, transparency:Number):void 
		{
			_dimension = dimension;
			_color = color;
			_alpha = transparency;
			alpha = 0;//hidden by default
			drawBG();
		}
		
		private function drawBG():void 
		{
			graphics.clear();
			graphics.beginFill(_color, _alpha);
			graphics.drawRect(0, 0, _dimension.width, _dimension.height);
			graphics.endFill();
			trace("numChildren " + numChildren);
		}
		
		public function show(container:DisplayObjectContainer = null, duration:Number=TRANSITION_DEFAULT):void
		{
			if (container) container.addChild(this);
			TweenLite.to(this, duration, { alpha:1 } );
		}
		
		public function hide(removeChild:Boolean = true, duration:Number = TRANSITION_DEFAULT):void
		{
			TweenLite.to(this, duration, { alpha:0, onComplete:remove } );
		}
		
		private function remove():void
		{
			if (parent) parent.removeChild(this);
		}
		
		/**
		 * Color of the background.
		 */
		public function get Color():uint 
		{
			return _color;
		}
		/**
		 * @private
		 */
		public function set Color(value:uint):void 
		{
			_color = value;
			drawBG();
		}
		
		/**
		 * Alpha value of the background.
		 */
		public function get Alpha():Number 
		{
			return _alpha;
		}
		/**
		 * @private
		 */
		public function set Alpha(value:Number):void 
		{
			_alpha = value;
			drawBG();
		}
		
		/**
		 * Size of the object
		 */
		public function get dimension():Rectangle 
		{
			return _dimension;
		}
		/**
		 * @private
		 */
		public function set dimension(value:Rectangle):void 
		{
			_dimension = value;
			drawBG();
		}
		
	}

}