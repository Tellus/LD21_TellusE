package  
{
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Text;
	/**
	 * Large text that splashes in yo' face!
	 * @author ...
	 */
	public class FlashTextEntity extends BaseEntity 
	{
		public var Content:Text;
		
		public var Background:Canvas;
		
		public function FlashTextEntity(text:String = "", x:int = 0, y:int = 0) 
		{
			super(x, y);
			
			var w:int = FP.width, h:int = FP.height;
			
			setHitbox(w, h);
			
			var ps:uint = Text.size;
			Text.size = 40
			Content = new Text(text);
			Text.size = ps;
			
			Background = new Canvas(width, height);
			Background.fill(new Rectangle(0, 0, width, height), 0x000000, 0.5)
			graphic = Background;
			
			Background.drawGraphic(halfWidth - Content.width / 2, halfHeight - Content.height / 2, Content);
			
			// Content.scrollX = Content.scrollY = Background.scrollX = Background.scrollY = 1;
			
		}
	}
}