package trial 
{
	import net.flashpunk.graphics.Image;
	/**
	 * Shows the future!!!!!
	 * @author ...
	 */
	public class FutureEntity extends BaseEntity 
	{
		[Embed(source = '../../img/trial/bg_freedom.png')] public static const FREE_SPRITE:Class;
		[Embed(source = '../../img/trial/bg_guilty.png')]	public static const GUILTY_SPRITE:Class;
		[Embed(source = '../../img/trial/bg_action.png')]	public static const ACTION_SPRITE:Class;
		
		public var FreeSprite:Image;
		public var JailSprite:Image;
		public var JurySprite:Image;
		
		public function FutureEntity() 
		{
			FreeSprite = new Image(FREE_SPRITE);
			JailSprite = new Image(GUILTY_SPRITE);
			JurySprite = new Image(ACTION_SPRITE);
			
			FreeSprite.scale = JailSprite.scale = JurySprite.scale = Main.GAME_SCALE;
			
			addGraphic(FreeSprite);
			addGraphic(JailSprite);
			addGraphic(JurySprite);
		}
		
		public function UpdateDecision():void
		{
			var w:TrialWorld = (world as TrialWorld);
			FreeSprite.alpha = w.Jury.FreeImg.alpha;
			JailSprite.alpha = w.Jury.JailImg.alpha;
			JurySprite.alpha = w.Jury.TrialImg.alpha;
		}
		
		override public function update():void 
		{
			super.update();
			UpdateDecision();
		}
	}

}