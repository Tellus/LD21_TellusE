package police 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.motion.LinearMotion;
	/**
	 * ...
	 * @author ...
	 */
	public class ProgressBarEntity extends BaseEntity 
	{
		[Embed(source = '../../img/police/progress.png')] public static const PROGRESS_SPRITE:Class;
		
		/**
		 * Progression speed.
		 */
		public var Speed:Number = 10;
		
		/**
		 * Progress in percentage.
		 */
		// public function get Percent():Number { return (x / FP.width); }
		public function get Percent():Number { return Movement.percent; }
		
		/**
		 * Progress in percentage.
		 */
		// public function set Percent(value:Number):void { x = FP.width * value; }
		public function set Percent(value:Number):void { Movement.percent = value; }
		
		public var Movement:LinearMotion;
		
		public var OnReachedEnd:Function = null;
		
		/**
		 * The starting credibility bash.
		 */
		public var BaseDamage:Number = 0.05;
		
		/**
		 * How much each consequent hit hurts your credibility.
		 */
		public var DamageModifier:Number = 0.03;
		
		/**
		 * Number of times bashed.
		 */
		public var Hits:int = 0;
		
		/**
		 * Whether the bar has run its course.
		 */
		public var Done:Boolean = false;
		
		public function ProgressBarEntity() 
		{
			super(0, 0, new Image(PROGRESS_SPRITE));
			setHitbox((graphic as Image).width, (graphic as Image).height);
			Movement = new LinearMotion(OnReachedEnd, Tween.ONESHOT);
		}
		
		/**
		 * Starts the left to right movement.
		 */
		public function StartMovement():void
		{
			Movement.setMotionSpeed(0, y, FP.width - width, y, Speed);
			addTween(Movement, true);
		}
		
		/**
		 * Stops the movement, temporarily, saving progress.
		 */
		public function Pause():void
		{
			Movement.active = false;
		}
		
		/**
		 * Resumes movement.
		 */
		public function Unpause():void
		{
			Movement.active = true;
		}
		
		public function Bash():void
		{
			Percent -= BaseDamage;
			Hits++;
			if (Percent < 0 && !Done)
			{
				(world as InterrogationWorld).Guilty();
				Done = true;
			}
			// trace("Percent after hurt: " + Percent.toString());
			BaseDamage += DamageModifier;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Movement) x = Movement.x;
			
			if (Percent < 0) Bash();
			if (Percent >= 1) OnReachedEnd.call(this);
		}
	}
}