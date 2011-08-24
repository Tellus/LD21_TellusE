package  
{
	import evidence.EvidenceWorld;
	import flash.sampler.NewObjectSample;
	import intro.IntroWorld;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Johannes L. Borresen
	 */
	public class TitleWorld extends BaseWorld 
	{
		[Embed(source = '../img/title/title.png')] public static const TITLE_IMAGE:Class;
		
		public function TitleWorld() 
		{
			super();
			
			var e:Entity = new Entity(0, 0, new Image(TITLE_IMAGE));
			add(e);
			
			FadeTime = 1.2;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Input.mousePressed)
			{
				// Proceed to intro with fade.
				// FP.world = new IntroWorld();
				FadeOut("", IntroWorld);
			}
		}
	}
}