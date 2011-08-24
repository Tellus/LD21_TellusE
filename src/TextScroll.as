package  
{
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.motion.LinearMotion;
	
	/**
	 * Entity that shows text in a canvas box and 
	 * @author ...
	 */
	public class TextScroll extends Entity 
	{
		/**
		 * The tween used to move the text up.
		 */
		public var ScrollTween:LinearMotion;
		
		/**
		 * How far the text moves.
		 */
		public var Speed:Number = 10;
		
		/**
		 * Padding from edges to text.
		 */
		private var _padding:int = 10;
		
		public function get Padding():int { return _padding; }
		
		public function set Padding(value:int):void
		{
			_padding = Content.x = Content.y = value;
			// _redrawText();
		}
		
		/**
		 * Colour of the backround.
		 */
		private var _bgcolour:uint = 0;
		
		public function get BgColour():uint { return _bgcolour; }
		
		public function set BgColour(value:uint):void
		{
			_bgcolour = value;
			_redrawBg();
			// _createText();
		}
		
		/**
		 * Alpha value of the background.
		 */
		private var _alpha:Number = 0.5;
		
		public function set Alpha(value:Number):void
		{
			Background.alpha = value;
			_redrawBg();
			// _createText();
		}
		
		public function get Alpha():Number { return _alpha; }
		
		/**
		 * Colour of the text.
		 */
		private var _textColour:uint = 0xFFFFFF;
		
		/**
		 * Sets the colour of the text.
		 */
		public function set TextColour(value:uint):void
		{
			_textColour = Content.color = value;
		}
		
		/**
		 * Sets the colour of the text.
		 */
		public function get TextColour():uint { return _textColour; }
		
		/**
		 * Background graphic. Shown behind the text.
		 */
		public var Background:Canvas;
		
		/**
		 * The text part.
		 */
		public var Content:Text;
		
		public var RawText:String;
		
		public function TextScroll(text:Class, w:int = 0, h:int = 0) 
		{
			super();
			
			if (!w) w = FP.width;
			if (!h) h = FP.height;
			
			setHitbox(w, h);
			
			var c:Class = text as Class;
			var bb:ByteArray = new c();
			RawText = bb.toString();
			
			_createBg();
			_createText();
			
			_createTweens();
		}
		
		private function _createText():void
		{
			var s:int = Text.size;
			Text.size = 20;
			Content = new Text(RawText);
			addGraphic(Content);
			// Background.drawGraphic(0, 0, Content);
			Text.size = s;
			trace("Cliprect: " + Content.clipRect.toString())
		}
		
		private function _createBg():void
		{
			Background = new Canvas(width, height);
			addGraphic(Background);
			_redrawBg();
		}
		
		private function _redrawText():void
		{
			(graphic as Graphiclist).remove(Content);
			_createText();
		}
		
		private function _redrawBg():void
		{
			var g:Canvas = Background as Canvas;
			g.fill(new Rectangle(0, 0, width, height), BgColour, 0.5);			
		}
		
		private function _createTweens():void
		{
			ScrollTween = new LinearMotion(OnScrollDone, Tween.ONESHOT);
			
			ScrollTween.setMotionSpeed(0, height, 0, 0 - height, Speed);
			
			addTween(ScrollTween, false);
		}
		
		public function Start():void
		{
			ScrollTween.start();
		}
		
		public function OnScrollDone():void
		{
			
		}
		
		override public function update():void 
		{
			super.update();
			
			// Content.x = ScrollTween.x;
			Content.y = ScrollTween.y;
			Content.clipRect.y++;
		}
	}

}