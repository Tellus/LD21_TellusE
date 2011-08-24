package trial 
{
	import net.flashpunk.graphics.Image;
	/**
	 * The Jury is an abstract progression indicator. It shifts from its
	 * starting position at the trial, towards either a prison if failing
	 * or a sunshined, glorified, heavenly freedom scenario.
	 * 
	 * @author ...
	 */
	public class JuryEntity extends BaseEntity 
	{
		[Embed(source = '../../img/trial/action.png')] public static const TRIAL_SPRITE:Class;
		[Embed(source = '../../img/trial/action_freedom.png')] public static const FREE_SPRITE:Class;
		[Embed(source = '../../img/trial/action_guilty.png')] public static const GUILTY_SPRITE:Class;
		
		public var FreeImg:Image;
		public var TrialImg:Image;
		public var JailImg:Image;
		
		/**
		 * Number of steps from trial to either free or guilty. Determines alpha changes.
		 */
		public static var Steps:int = 20;
		
		/**
		 * The jury's current decision.
		 */
		public var Decision:int = 0;
		
		/**
		 * Function to call when the player is found guilty.
		 */
		public var OnGuilty:Function = null;
		
		/**
		 * Function to call when the player is found innocent.
		 */
		public var OnInnocent:Function = null;
		
		public function JuryEntity() 
		{
			FreeImg = _createImg(FREE_SPRITE);
			TrialImg = _createImg(TRIAL_SPRITE);
			JailImg = _createImg(GUILTY_SPRITE);
			
			// Get current jury decision from main.
			Decision = Main.JuryOffset;
			
			doShading();
		}
		
		/**
		 * Add another jury member to the player's side.
		 */
		public function Absolve():void
		{
			Decision++;
			doShading();
		}
		
		/**
		 * Add another jury member to the opponent's side.
		 */
		public function Condemn():void
		{
			Decision--;
			doShading();
		}
		
		/**
		 * Set the alpha levels according to the current jury majority.
		 */
		protected function doShading():void
		{
			if (Decision == 0)
			{
				JailImg.alpha = FreeImg.alpha = 0;
				TrialImg.alpha = 1;
			}
			else if (Decision < 0)
			{
				FreeImg.alpha = 0;
				TrialImg.alpha = (Steps + Decision) / Steps;
				JailImg.alpha = -1 * Decision / Steps;
			}
			else if (Decision > 0)
			{
				JailImg.alpha = 0;
				TrialImg.alpha = (Steps - Decision) / Steps;
				FreeImg.alpha = Decision / Steps;
			}
		}
		
		private function _createImg(source:Class):Image
		{
			var i:Image = new Image(source);
			i.scale = Main.GAME_SCALE;
			addGraphic(i);
			return i;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Decision * -1 >= Steps) OnGuilty.call(this);
			else if (Decision >= Steps) OnInnocent.call(this);
		}
	}
}