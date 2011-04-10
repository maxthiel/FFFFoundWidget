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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Matrix;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import fr.thiel.ffffoundwidget.events.ImageEvent;
	
	/**
	 * ...
	 * @author Maximilien Thiel
	 */
	public class ImageHandler extends Loader 
	{
		private var _rssFeed:XML;
		private var _picsNumber:int;
		private var _currentDisplayedPic:int;
		private var _previousDisplayedPic:int;
		private var _currentLoadingPic:int;
		private var _picPool:Vector.<Image>;
		
		private var _currentPicMatrix:Matrix;
		
		private var _view:Bitmap;
		private var _viewContent:BitmapData;
		
		private var _error:String = "";
		
		private var _request:URLRequest;
		
		private var _message:TextField;
		
		private var _transitionEngine:Transition;
		
		//FFFFound xml namespaces
		private var media:Namespace = new Namespace("http://search.yahoo.com/mrss/");
		private var atom:Namespace = new Namespace("http://www.w3.org/2005/Atom");
		private var ffffound:Namespace = new Namespace("http://ffffound.com/scheme/feed");
		
		public function ImageHandler(xmlSource:String) 
		{
			super();
			init(xmlSource);
		}
		
		
		private function init(xmlSource:String):void 
		{
			_picPool = new Vector.<Image>();
			_message = new TextField();
			var format:TextFormat = new TextFormat();
			format.font = Main.DEFAULT_FONT;
			format.size = 10;
			format.color = 0xFFFFFF;
			format.align = TextFormatAlign.CENTER;
			_message.defaultTextFormat = format;
			_message.width = Main.DIMENSION.width;
			_message.wordWrap = true;
			_message.multiline = true;
			
			//create display element
			_viewContent = new BitmapData(Main.DIMENSION.width, Main.DIMENSION.height, false, Main.BG_COLOR);
			_message.text = Loc.getInstance().__("load_rss");
			drawMessageInView();
			_view = new Bitmap(_viewContent);//TODO smooth with settings
			var rssLoader:URLLoader = new URLLoader();
			var ur:URLRequest = new URLRequest(xmlSource);
			setListeners(rssLoader);
			rssLoader.load(ur);
			_currentDisplayedPic = _previousDisplayedPic = _currentLoadingPic = -1;
			
			_transitionEngine = new Transition(_viewContent);
		}
		
		private function drawMessageInView():void 
		{
			resizeTF();
			_viewContent.fillRect(_viewContent.rect, Main.BG_COLOR);
			var m:Matrix = new Matrix();
			m.translate(_viewContent.width / 2 - _message.width / 2, _viewContent.height / 2 - _message.height / 2);
			_viewContent.draw(_message, m);
		}
		
		private function resizeTF():void
		{
			_message.height = (_message.textHeight < Main.DIMENSION.height) ? _message.textHeight*1.5 : Main.DIMENSION.height;
			//width doesn't change
		}
		
		private function setListeners(dispatcher:EventDispatcher, addOrRemove:Boolean = true):void
		{
			if (!dispatcher) return;
			if (addOrRemove)
			{
				if(!dispatcher.hasEventListener(Event.COMPLETE))
					dispatcher.addEventListener(Event.COMPLETE, loaderHandler);
				if(!dispatcher.hasEventListener(ProgressEvent.PROGRESS))
					dispatcher.addEventListener(ProgressEvent.PROGRESS, loaderHandler);
				if(!dispatcher.hasEventListener(SecurityErrorEvent.SECURITY_ERROR))
					dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderHandler);
				if(!dispatcher.hasEventListener(HTTPStatusEvent.HTTP_STATUS))
					dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, loaderHandler);
				if(!dispatcher.hasEventListener(IOErrorEvent.IO_ERROR))
					dispatcher.addEventListener(IOErrorEvent.IO_ERROR, loaderHandler);
			}
			else
			{
				if(dispatcher.hasEventListener(Event.COMPLETE))
					dispatcher.removeEventListener(Event.COMPLETE, loaderHandler);
				if(dispatcher.hasEventListener(ProgressEvent.PROGRESS))
					dispatcher.removeEventListener(ProgressEvent.PROGRESS, loaderHandler);
				if(dispatcher.hasEventListener(SecurityErrorEvent.SECURITY_ERROR))
					dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderHandler);
				if(dispatcher.hasEventListener(HTTPStatusEvent.HTTP_STATUS))
					dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, loaderHandler);
				if(dispatcher.hasEventListener(IOErrorEvent.IO_ERROR))
					dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, loaderHandler);
			}
		}
		
		private function loadPic(picToLoad:int):void 
		{
			if (picToLoad >= _picsNumber)
			{
				//this was the last one.
				//try and check if previous still need to be loaded
				var num:int = _picPool.indexOf(null);
				if (num >= 0) loadPic(num);
				return;
			}
			
			if (_picPool.length > picToLoad && _picPool[picToLoad] != null)
			{
				//already loaded, or kept from previous rss !
				if (picToLoad == 0) dispatchEvent(new ImageEvent(ImageEvent.PIC_READY));
				loadPic(++picToLoad);
				return;
			}
			
			_currentLoadingPic = picToLoad;
			if (!_request) _request = new URLRequest(_rssFeed.channel.item[_currentLoadingPic].media::content.@url);
			else _request.url = _rssFeed.channel.item[_currentLoadingPic].media::content.@url;
			
			setListeners(contentLoaderInfo);
			this.load(_request);
			
		}
		
		private function loaderHandler(e:Event):void 
		{
			if (e.currentTarget is URLLoader)
			{
				switch(e.type)
				{
					case Event.COMPLETE:
					{
						try
						{
							_rssFeed = new XML(URLLoader(e.target).data);
						}
						catch (err:Error)
						{
							_error = err.name+" - "+err.message;
							dispatchEvent(new ImageEvent(ImageEvent.ERR_RSS_READ));
							return;
						}
						initPool();
						_currentLoadingPic = 0;
						loadPic(_currentLoadingPic);
						setListeners(EventDispatcher(e.currentTarget), false);
					}break;
					
					case SecurityErrorEvent.SECURITY_ERROR :
					case IOErrorEvent.IO_ERROR :
					{
						_error = e.toString();
						dispatchEvent(new ImageEvent(ImageEvent.ERR_RSS_LOADING));
					}break;
					case HTTPStatusEvent.HTTP_STATUS :
					{
						if (HTTPStatusEvent(e).status != 404 && HTTPStatusEvent(e).status != 403) return;
						else
						{
							_error = e.toString();
							dispatchEvent(new ImageEvent(ImageEvent.ERR_RSS_LOADING));
						}
					}break;
				}
			}
			else if (e.currentTarget == contentLoaderInfo)
			{
				switch(e.type)
				{
					case Event.COMPLETE:
					{
						//save pic in pool
						_picPool[_currentLoadingPic] = new Image(this, true);
						//release loaded image
						unload();
						_picPool[_currentLoadingPic].setInfos(_rssFeed.channel.item[_currentLoadingPic].title,
																									_rssFeed.channel.item[_currentLoadingPic].link,
																									_rssFeed.channel.item[_currentLoadingPic].media::content.@url,
																									_rssFeed.channel.item[_currentLoadingPic].ffffound::source.@url,
																									_rssFeed.channel.item[_currentLoadingPic].author,
																									_rssFeed.channel.item[_currentLoadingPic].pubDate.toString(),
																									_rssFeed.channel.item[_currentLoadingPic].ffffound::source.@referer,
																									_rssFeed.channel.item[_currentLoadingPic].ffffound::savedby.@count);
						if (_currentLoadingPic == 0) dispatchEvent(new ImageEvent(ImageEvent.PIC_HANDLER_READY, _currentLoadingPic));
						dispatchEvent(new ImageEvent(ImageEvent.PIC_READY, _currentLoadingPic));
						//load next one
						loadPic(++_currentLoadingPic);
					}break;
					
					case SecurityErrorEvent.SECURITY_ERROR :
					case IOErrorEvent.IO_ERROR :
					{
						_message.text = Loc.getInstance().__("error_loading_pic");
						resizeTF();
						_picPool[_currentLoadingPic] = new Image(_message);
						_picPool[_currentLoadingPic].error = e.toString();
						dispatchEvent(new ImageEvent(ImageEvent.ERR_PIC_LOADING, _currentLoadingPic));
						//load next one
						loadPic(++_currentLoadingPic);
					}break;
					case HTTPStatusEvent.HTTP_STATUS :
					{
						if (HTTPStatusEvent(e).status != 404 && HTTPStatusEvent(e).status != 403) return;
						else
						{
							_message.text = Loc.getInstance().__("error_loading_pic");
							resizeTF();
							_picPool[_currentLoadingPic] = new Image(_message);
							_picPool[_currentLoadingPic].error = e.toString();
							dispatchEvent(new ImageEvent(ImageEvent.ERR_PIC_LOADING, _currentLoadingPic));
							//load next one
							loadPic(++_currentLoadingPic);
						}
					}break;
				}
			}
		}
		
		private function initPool():void 
		{
			_picsNumber = _rssFeed.channel.item.length();
			//if the pool is not empty, see if we cannot use the picture
			if (_picPool.length > 0)
			{
				var tmpPool:Vector.<Image> = new Vector.<Image>(_picsNumber, true );
				var i:int = 0;
				var j:int = 0;
				var hash:String;
				for (i = 0; i < _picsNumber; i++)
				{
					hash = MD5.hash(String(_rssFeed.channel.item[i].title + _rssFeed.channel.item[i].link));
					for (j = 0; j < _picPool.length; j++)
					{
						if (hash == _picPool[j].HashId)
						{
							tmpPool[i] = _picPool[j];
							break;
						}
					}
				}
				//TODO optimize with dispose for unkept image
				//nullify the ref in the old pool
				for (j = 0; j < _picPool.length; j++)
				{
					_picPool[j] = null;
				}
				
				//copy the new pool
				_picPool = tmpPool;
				
			}
		}
		
		private function displayPic(picIndex:int):void 
		{
			if (picIndex >= _picPool.length) picIndex %= _picsNumber;//loop
			else if (picIndex < 0) picIndex = (_picsNumber + picIndex % _picsNumber);
			
			//already transitioning ? end it
			if (_transitionEngine.Active) _transitionEngine.stopTransition();
			
			var m:Matrix = computeFinalPosition(_picPool[picIndex]);
			var current:BitmapData;
			if (_currentDisplayedPic < 0)
			{
				//first time, use a fake one
				current = new BitmapData(Main.DIMENSION.width, Main.DIMENSION.height, true, Main.BG_COLOR);
				_currentPicMatrix = new Matrix();
			}
			else current = _picPool[_currentDisplayedPic] as BitmapData;
			trace("curent " + _currentDisplayedPic + " and next " + picIndex);
			_transitionEngine.startTransition(current, _currentPicMatrix, _picPool[picIndex], m, _viewContent);
			
			_previousDisplayedPic = _currentDisplayedPic,
			_currentDisplayedPic = picIndex;
			_currentPicMatrix = m;
			dispatchEvent(new ImageEvent(ImageEvent.PIC_DRAWN, picIndex));
		}
		
		
		private function computeFinalPosition(pic:BitmapData):Matrix
		{
			var newMatrix:Matrix = new Matrix();
			if (pic.width > Main.DIMENSION.width && pic.width / Main.DIMENSION.width > pic.height / Main.DIMENSION.height)
			{
				trace("hop");
				newMatrix.scale(Main.DIMENSION.width / pic.width, Main.DIMENSION.width / pic.width);
				newMatrix.translate(0, (Main.DIMENSION.height - (pic.height * ( Main.DIMENSION.width / pic.width))) / 2);
			}
			else if (pic.height >= Main.DIMENSION.height && pic.height / Main.DIMENSION.height >= pic.width / Main.DIMENSION.width)
			{
				newMatrix.scale(Main.DIMENSION.height / pic.height, Main.DIMENSION.height / pic.height);
				newMatrix.translate((Main.DIMENSION.width - (pic.width * (Main.DIMENSION.height / pic.height))) / 2, 0);
			}
			
			return newMatrix;
		}
		
		
		
		
		
		/**
		 * The latest error that occured
		 */
		public function get error():String { return _error; }
		/**
		 * The currently viewed picture
		 */
		public function get view():DisplayObject { return DisplayObject(_view); }
		
		
		
		public function get currentImage():Image
		{
			if (_currentDisplayedPic < 0 || (_picPool && _currentDisplayedPic >= _picPool.length)) return null;
			else return _picPool[_currentDisplayedPic];
		}
		
		public function imageInfos(picIndex:int):PictureInfos
		{
			if (!_picPool || picIndex < 0 || picIndex > _picPool.length) return null;
			return _picPool[picIndex].Infos;
		}
		
		public function firstPicture():void 
		{
			displayPic(0);
		}
		
		public function nextPicture():void 
		{
			displayPic(_currentDisplayedPic+1);
		}
		
		public function previousPicture():void 
		{
			displayPic(_currentDisplayedPic-1);
		}
		
		public function lastPicture():void 
		{
			displayPic(_picsNumber-1);
		}
		
		public function get TotalPictures():int
		{
			return _picsNumber;
		}
		
	}
}