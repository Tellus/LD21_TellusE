package trial 
{
	import dk.homestead.utils.Data;
	import flash.geom.Point;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	/**
	 * The mouth stores saliva. It can be emptied.
	 * If filling up, you will drool and look like a retard.
	 * If used too often, you will dry up and cough, looking guilty.
	 * @author ...
	 */
	public class Mouth extends BaseEntity 
	{
		[Embed(source = '../../img/trial/mouth.png')] public static const MOUTH_SPRITE:Class;
		
		/**
		 * Amount of saliva building up.
		 */
		public var Saliva:Number = 0;
		
		/**
		 * Amount of saliva swallowed per use.
		 */
		public var SwallowStrength:Number = 80;
		
		/**
		 * Amount of saliva before coughing.
		 */
		public var Threshold:Number = 100;
		
		/**
		 * Amount of saliva generated per frame.
		 */
		public var SalivaGeneration:Number = 15;
		
		public var SalivaTimer:Alarm = new Alarm(1, Salivate, Tween.LOOPING);
		
		public function get Sprite():Spritemap { return graphic as Spritemap; }
		
		public function set Sprite(value:Spritemap):void { graphic = value; }
		
		/**
		 * Whether the swallowing animation is active.
		 */
		private var _swallowing:Boolean = false;
		
		public function Mouth() 
		{
			Sprite = new Spritemap(MOUTH_SPRITE, 30, 15, OnAnimEnd);
			Sprite.add("swallow", Data.FillArray(6), 15, false);
			Sprite.add("talk0", Data.FillArray(4, 6), 5, false);
			Sprite.add("talk1", Data.FillArray(4, 6), 10, false);
			Sprite.add("talk2", Data.FillArray(4, 6), 15, false);
			Sprite.add("talk3", Data.FillArray(4, 6), 20, false);
			Sprite.add("talk4", Data.FillArray(4, 6), 25, false);
			Sprite.play(_getTalkAnim());
			
			Sprite.scale = Main.GAME_SCALE;
			
			addTween(SalivaTimer, true);
			
			setHitbox(Sprite.scaledWidth, Sprite.scaledHeight);
		}
		
		/**
		 * Sets the swallow button.
		 * @param	k
		 */
		public function SetKey(k:int):void
		{
			Input.define("MOUTH", k);
		}
		
		/**
		 * You swallow. Removes 80 saliva. If too much, you cough, if too little, you're fine.
		 */
		public function Swallow():void
		{
			if (_swallowing) return; // Disallow quick swallos.
			Sprite.play("swallow", true);
			_swallowing = true;
		}
		
		public function Salivate():void
		{
			Saliva += SalivaGeneration;
			trace("Saliva now " + Saliva);
		}
		
		/**
		 * You cough when you've either too much or too little saliva.
		 */
		public function Cough():void
		{
			trace("You cough (" + Saliva + "/" + Threshold + "), reducing the jury's belief in you."),
			(world as TrialWorld).Jury.Condemn();
			Saliva = 0;
		}
		
		private function _getTalkAnim():String
		{
			var s:String = "talk" + Math.floor(Math.random() * 5);
			// trace("Activating " + s);
			return s;
		}
		
		public function OnAnimEnd():void
		{
			if (_swallowing)
			{
				_swallowing = false;
				if (Saliva - SwallowStrength < 0) Cough();
			}
			Sprite.play(_getTalkAnim() , true);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Saliva > Threshold) Cough();
			
			if (Input.pressed("MOUTH")) { Swallow(); }
		}
	}
}