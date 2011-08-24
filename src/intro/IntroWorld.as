package intro
{
	import adobe.utils.CustomActions;
	import evidence.EvidenceWorld;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Johannes L. Borresen
	 */
	public class IntroWorld extends CutsceneWorld 
	{
		[Embed(source = '../../img/intro/car.png')] public static var CAR_SPRITE:Class;
		[Embed(source = '../../img/intro/wheels.png')] public static var WHEEL_SPRITE:Class;
		[Embed(source = '../../data/intro_start.txt', mimeType = "application/octet-stream")] public static var INTRO_TEXT:Class;
		[Embed(source = '../../img/intro/bg.png')] public static var SKY_SPRITE:Class;
		
		// [Embed(source = '../../snd/intro_speak.mp3')] public static const INTRO_SPEAK:Class;
		[Embed(source = '../../snd/intro_speak_low.mp3')] public static const INTRO_SPEAK:Class;
		
		public var Car:BaseEntity;
		public var Wheel1:BaseEntity;
		public var Wheel2:BaseEntity;
		public var Background:BaseEntity;
		
		public function IntroWorld() 
		{
			super(INTRO_TEXT, INTRO_SPEAK, EvidenceWorld);
			
			_createBg();
			_createWheel1();
			_createWheel2();
			_createCar();
			
			TextEntity.graphic.scrollX = 0;
		}
		
		private function _createBg():void
		{
			Background = new BaseEntity(0, 0, new Backdrop(SKY_SPRITE, true, false));
			var g:Backdrop = Background.graphic as Backdrop;
			trace(g.scrollX);
			g.scrollX = 0.5;
			add(Background);
		}
		
		private function _createCar():void
		{
			Car = new BaseEntity(0, 0, new Image(CAR_SPRITE));
			var g:Image = Car.graphic as Image;
			g.scale = Main.GAME_SCALE;
			g.scrollX = g.scrollY = 0;
			Car.setHitbox(g.scaledWidth, g.scaledHeight);
			Car.x = FP.halfWidth - Car.halfWidth;
			Car.y = FP.halfHeight - Car.halfHeight;
			add(Car);
		}
		
		private function _createWheel(X:int, Y:int):BaseEntity
		{
			var w:BaseEntity = new BaseEntity(0, 0, new Image(WHEEL_SPRITE));
			var g:Image = w.graphic as Image;
			g.scale = Main.GAME_SCALE;
			g.scrollX = g.scrollY = 0;
			g.centerOO();
			
			w.setHitbox(g.scaledWidth, g.scaledHeight);
			w.centerOrigin();
			w.x = X;
			w.y = Y;
			add(w);
			return w;
		}
		
		private function _createWheel2():void
		{
			Wheel2 = _createWheel(456, 312);
		}
		
		private function _createWheel1():void
		{
			Wheel1 = _createWheel(140, 312);
		}
		
		override public function update():void 
		{
			super.update();
			
			var tweak:Number = Math.random() * 20;
			(Wheel1.graphic as Image).angle -= (30 + tweak);
			(Wheel2.graphic as Image).angle -= (30 + tweak);
			
			camera.x++;
		}
	}
}