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
	import com.adobe.crypto.MD5;
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Maximilien Thiel
	 */
	public class Transition 
	{
		public static const ALPHA:String						= "alpha";
		public static const MOVE_RIGHT:String				= "move_right";
		public static const MOVE_LEFT:String				= "move_left";
		public static const MOVE_UP:String					= "move_up";
		public static const MOVE_DOWN:String				= "move_down";
		
		private var _previous:BitmapData;
		private var _next:BitmapData;
		private var _container:BitmapData;
		
		private var _pMatrix:Matrix;
		private var _nMatrix:Matrix;
		
		private var _type:String;
		
		private var _tweens:Vector.<TweenLite>;
		
		private var _duration:Number = 0.25;
		
		private var _status:Boolean = false;
		
		public function Transition(container:BitmapData = null) 
		{
			trace(container);
			_container = container;
			_tweens = new Vector.<TweenLite>();
		}
		
		
		public function startTransition(previous:BitmapData, pMatrix:Matrix, next:BitmapData, nMatrix:Matrix, container:BitmapData = null, type:String = ALPHA):void
		{
			if (container != null) _container = container;
			else if (_container == null)
			{
				throw new Error("You need a container for the transition to draw in.");
				return;
			}
			trace(previous.height);
			trace(next.height);
			_previous = previous;
			_next = next;
			_type = (type == null) ? ALPHA : type;
			_pMatrix = pMatrix;
			_nMatrix = nMatrix;
			
			Main.MainStage.frameRate = Main.ANIM_FRAMERATE;
			
			var dest:Number;
			switch(_type)
			{
				case ALPHA:
				{
					var color:ColorTransform = new ColorTransform();
					color.alphaMultiplier = 1;
					color.alphaOffset = -255;
					_tweens.push(TweenLite.to(color, _duration, { alphaOffset:0, data:color } ));
					color = new ColorTransform();
					color.alphaMultiplier = 1;
					color.alphaOffset = 0;
					_tweens.push(TweenLite.to(color, _duration, { alphaOffset:-255, data:color, onComplete:endTransition } ));
				}break;
				
				case MOVE_LEFT:
				{
					dest = _nMatrix.tx;
					_nMatrix.translate(_next.width, 0);
					_tweens.push(TweenLite.to(_nMatrix, _duration, { tx:dest } ));
					_tweens.push(TweenLite.to(_pMatrix, _duration, { tx:_pMatrix.tx - _previous.width, onComplete:endTransition } ));
				}break;
				
				case MOVE_RIGHT:
				{
					dest = _nMatrix.tx;
					_nMatrix.translate(-_next.width, 0);
					_tweens.push(TweenLite.to(_nMatrix, _duration, { tx:dest } ));
					_tweens.push(TweenLite.to(_pMatrix, _duration, { tx:_pMatrix.tx + _previous.width, onComplete:endTransition } ));
				}break;
				
				case MOVE_DOWN:
				{
					dest = _nMatrix.ty;
					_nMatrix.translate(0, -_next.height);
					_tweens.push(TweenLite.to(_nMatrix, _duration, { ty:dest } ));
					_tweens.push(TweenLite.to(_pMatrix, _duration, { ty:_pMatrix.ty + _previous.height, onComplete:endTransition } ));
				}break;
				
				case MOVE_UP:
				{
					dest = _nMatrix.ty;
					_nMatrix.translate(0, _next.height);
					_tweens.push(TweenLite.to(_nMatrix, _duration, { ty:dest } ));
					_tweens.push(TweenLite.to(_pMatrix, _duration, { ty:_pMatrix.ty - _previous.height, onComplete:endTransition } ));
				}break;
			}
			
			Main.MainStage.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			_status = true;
		}
		
		private function update(e:Event):void
		{
			if (!_status) return;
			
			_container.fillRect(Main.DIMENSION, Main.BG_COLOR);
			switch(_type)
			{
				case ALPHA:
				{
					var c:ColorTransform = ColorTransform(_tweens[1].data);
					_container.draw(_previous, _pMatrix, c);
					c = ColorTransform(_tweens[0].data);
					_container.draw(_next, _nMatrix, c);
				}break;
				
				case MOVE_LEFT:
				case MOVE_RIGHT:
				case MOVE_UP:
				case MOVE_DOWN:
				{
					_container.draw(_previous, _pMatrix);
					_container.draw(_next, _nMatrix);
				}break;
			}
			
			
		}
		
		public function stopTransition():void
		{
			//terminate all tweens
			for (var i:int = 0; i < _tweens.length; i++)
			{
				if (_tweens[i].active) _tweens[i].complete(false, true);
			}
			endTransition();
		}
		
		private function endTransition():void
		{
			//kill all tweens
			for (var i:int = 0; i < _tweens.length; i++)
			{
				_tweens.splice(i, 1);
				i--;
			}
			Main.MainStage.frameRate = Main.DEFAULT_FRAMERATE;
			//release objects
			_previous = null;
			_next = null;
			_pMatrix = null;
			_nMatrix = null;
			Main.MainStage.removeEventListener(Event.ENTER_FRAME, update);
			_status = false;
		}
		
		public function get Duration():Number 
		{
			return _duration;
		}
		
		public function set Duration(value:Number):void 
		{
			_duration = value;
		}
		
		public function get Active():Boolean { return _status; }
	}

}