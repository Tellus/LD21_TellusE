package cutscenes 
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	/**
	 * Final scene with two possible endings.
	 * @author ...
	 */
	public class GameOverScene extends CutsceneWorld 
	{
		[Embed(source = '../../data/endings/best.txt', mimeType = "application/octet-stream")] public static const BEST_ENDING:Class;
		[Embed(source = '../../data/endings/good.txt', mimeType = "application/octet-stream")] public static const GOOD_ENDING:Class;
		[Embed(source = '../../data/endings/bad.txt', mimeType = "application/octet-stream")] public static const BAD_ENDING:Class;
		[Embed(source = '../../data/endings/worst.txt', mimeType = "application/octet-stream")] public static const WORST_ENDING:Class;
		
		/*
		[Embed(source = '../../snd/best_speak.mp3')] public static const BEST_SPEAK:Class;
		[Embed(source = '../../snd/good_speak.mp3')] public static const GOOD_SPEAK:Class;
		[Embed(source = '../../snd/bad_speak.mp3')] public static const BAD_SPEAK:Class;
		[Embed(source = '../../snd/worst_speak.mp3')] public static const WORST_SPEAK:Class;
		*/
		
		[Embed(source = '../../snd/best_speak_low.mp3')] public static const BEST_SPEAK:Class;
		[Embed(source = '../../snd/good_speak_low.mp3')] public static const GOOD_SPEAK:Class;
		[Embed(source = '../../snd/bad_speak_low.mp3')] public static const BAD_SPEAK:Class;
		[Embed(source = '../../snd/worst_speak_low.mp3')] public static const WORST_SPEAK:Class;
		
		[Embed(source='../../img/trial/bg_freedom.png')] public static const FREE_SPRITE:Class;
		[Embed(source='../../img/trial/bg_guilty.png')] public static const JAIL_SPRITE:Class;
		
		public var Background:Image;
		
		public function GameOverScene() 
		{
			var ending:Class;
			var ending_speak:Class;
			
			if (Main.Innocent)
			{
				if (Main.Perfect)
				{
					ending = BEST_ENDING;
					ending_speak = BEST_SPEAK;
				}
				else
				{
					ending = GOOD_ENDING;
					ending_speak = GOOD_SPEAK;
				}
			}
			else
			{
				if (Main.Perfect)
				{
					ending = BAD_ENDING;
					ending_speak = BAD_SPEAK;
				}
				else
				{
					ending = WORST_ENDING;
					ending_speak = WORST_SPEAK;
				}
			}
			
			super(ending, ending_speak, FlashPunkWorld);
			
			if (ending == BEST_ENDING || ending == GOOD_ENDING)
			{
				Background = new Image(FREE_SPRITE);
			}
			else
			{
				Background = new Image(JAIL_SPRITE);
			}
			
			Background.scale = 4;
			addGraphic(Background, 9);
			
			TextEntity.BgColour = 0x000000;
		}
		
		
		override public function update():void 
		{
			super.update();
			
			if (Input.check(Key.LEFT)) TextEntity.x--;
			else if (Input.check(Key.RIGHT)) TextEntity.x++;
			else if (Input.check(Key.UP)) TextEntity.y--;
			else if (Input.check(Key.DOWN)) TextEntity.y++;
		}
	}

}