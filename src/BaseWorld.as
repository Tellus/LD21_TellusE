package  
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.ColorTween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BaseWorld extends World 
	{
		public var NextWorld:Class;
		
		public var Curtain:BaseEntity;
		public var FadeTween:VarTween;
		
		public var HelpEntity:FlashTextEntity;
		
		/**
		 * Time in seconds for a fade.
		 */
		public var FadeTime:Number = 3.5;
		
		/**
		 * Colour of the fade before transparency ensues.
		 */
		public var CurtainColour:uint = 0;
		
		/**
		 * True when the freeze function has been called before the unfreeze function.
		 */
		public var Frozen:Boolean = false;
		
		public function BaseWorld() 
		{
			super();
			_createCurtain();
			FadeIn();
			
			Curtain.visible = false;
		}
		
		private function _createCurtain():void
		{
			Curtain = new BaseEntity(0, 0, new Canvas(FP.width, FP.height));
			add(Curtain);
			
			var g:Canvas = Curtain.graphic as Canvas;
			
			g.fill(new Rectangle(0, 0, FP.width, FP.height), CurtainColour, 1);
			
			bringToFront(Curtain);
		}
		
		public function FadeIn():void
		{
			FadeTween = new VarTween(OnFadeIn, Tween.ONESHOT);
			FadeTween.tween((Curtain.graphic as Canvas), "alpha", 0, FadeTime);
			addTween(FadeTween, true);
		}
		
		public function FadeOut(text:String = null, newWorld:Class = null):void
		{
			NextWorld = newWorld;
			
			Freeze();
			
			var t:FlashTextEntity = new FlashTextEntity(text);
			add(t);
			bringForward(t);
			t.graphic.scrollX = t.graphic.scrollY = 0;
			// t.x = camera.x;
			// t.y = camera.y;
			
			FadeTween = new VarTween(OnFadeOut, Tween.ONESHOT);
			FadeTween.tween(Curtain.graphic as Canvas, "alpha", 1, FadeTime);
			addTween(FadeTween);
		}
		
		public function OnFadeIn():void
		{
			// Do nothing in base class.
		}
		
		public function OnFadeOut():void
		{
			// FP.world = new CutsceneWorld(ENDING_TEXT, InterrogationWorld);
			FP.world = new NextWorld();
		}
		
		public function Freeze():void
		{
			setActiveState(false);
			Frozen = true;
		}
		
		public function Unfreeze():void
		{
			setActiveState(true);
			Frozen = false;
		}
		
		public function Pause():void
		{
			if (HelpEntity != null)
			{
				add(HelpEntity);
				HelpEntity.visible = true;
				bringToFront(HelpEntity);
			}
			Freeze();
		}
		
		public function Unpause():void
		{
			if (HelpEntity != null)
			{
				HelpEntity.visible = false;
				sendToBack(HelpEntity);
				remove(HelpEntity);
			}
			Unfreeze();
		}
		
		protected function setActiveState(s:Boolean):void
		{

		}
	}
}